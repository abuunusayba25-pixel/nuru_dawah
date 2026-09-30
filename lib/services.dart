import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data.dart';

String fmtDuration(Duration d) {
  String two(int n) => n.toString().padLeft(2, '0');
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
}

String fmtBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

/// A file saved on the device (audio or book).
class DownloadRecord {
  final String id;
  final String kind; // 'audio' | 'book'
  final String title;
  final String subtitle; // sheikh or author
  final String fileName;
  final int bytes;
  final int durationSec;

  const DownloadRecord({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.fileName,
    required this.bytes,
    this.durationSec = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind,
        'title': title,
        'subtitle': subtitle,
        'fileName': fileName,
        'bytes': bytes,
        'durationSec': durationSec,
      };

  factory DownloadRecord.fromJson(Map<String, dynamic> j) => DownloadRecord(
        id: j['id'] as String,
        kind: j['kind'] as String,
        title: j['title'] as String,
        subtitle: j['subtitle'] as String,
        fileName: j['fileName'] as String,
        bytes: j['bytes'] as int,
        durationSec: (j['durationSec'] ?? 0) as int,
      );
}

/// Single app-wide state: audio player + downloads.
class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  final AudioPlayer player = AudioPlayer();
  final Dio _dio = Dio();
  late Directory _dir;
  late SharedPreferences _prefs;

  List<DownloadRecord> downloads = [];
  final Map<String, double> progress = {}; // id -> 0..1 (active downloads)
  AudioItem? current;

  Future<void> init() async {
    final base = await getApplicationDocumentsDirectory();
    _dir = Directory('${base.path}/nuru');
    if (!await _dir.exists()) await _dir.create(recursive: true);
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs.getStringList('downloads') ?? [];
    downloads = raw
        .map((e) => DownloadRecord.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .where((r) => File(pathOf(r)).existsSync())
        .toList();
  }

  String pathOf(DownloadRecord r) => '${_dir.path}/${r.fileName}';

  DownloadRecord? recordOf(String id) {
    for (final r in downloads) {
      if (r.id == id) return r;
    }
    return null;
  }

  bool isDownloaded(String id) => recordOf(id) != null;
  bool isDownloading(String id) => progress.containsKey(id);
  int get totalBytes => downloads.fold(0, (sum, r) => sum + r.bytes);

  Future<void> _save() => _prefs.setStringList(
      'downloads', downloads.map((r) => jsonEncode(r.toJson())).toList());

  // ------------------------------------------------------------ playback
  /// Plays [item] (from the device if downloaded, otherwise streams).
  /// Calling it for the current item toggles play/pause.
  Future<bool> play(AudioItem item) async {
    if (current?.id == item.id) {
      if (player.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
        player.play();
      } else if (player.playing) {
        player.pause();
      } else {
        player.play();
      }
      return true;
    }
    current = item;
    notifyListeners();
    try {
      final rec = recordOf(item.id);
      if (rec != null) {
        await player.setFilePath(pathOf(rec));
      } else {
        await player.setUrl(item.url);
      }
      player.play(); // not awaited: completes only when playback ends
      return true;
    } catch (_) {
      current = null;
      notifyListeners();
      return false;
    }
  }

  Future<void> closePlayer() async {
    await player.stop();
    current = null;
    notifyListeners();
  }

  // ----------------------------------------------------------- downloads
  Future<bool> downloadAudio(AudioItem a) => _download(
        id: a.id,
        url: a.url,
        kind: 'audio',
        title: a.title,
        subtitle: a.sheikh,
        ext: 'mp3',
        durationSec: a.duration.inSeconds,
      );

  Future<bool> downloadBook(BookItem b) => _download(
        id: b.id,
        url: b.url,
        kind: 'book',
        title: b.title,
        subtitle: b.author,
        ext: 'pdf',
      );

  Future<bool> _download({
    required String id,
    required String url,
    required String kind,
    required String title,
    required String subtitle,
    required String ext,
    int durationSec = 0,
  }) async {
    if (isDownloaded(id)) return true;
    if (isDownloading(id)) return false;

    final fileName = '${kind}_$id.$ext';
    final path = '${_dir.path}/$fileName';
    progress[id] = 0;
    notifyListeners();

    try {
      await _dio.download(
        url,
        path,
        onReceiveProgress: (received, total) {
          if (total <= 0) return;
          final p = received / total;
          // throttle rebuilds to ~1% steps
          if (p - (progress[id] ?? 0) >= 0.01) {
            progress[id] = p;
            notifyListeners();
          }
        },
      );
      final bytes = await File(path).length();
      downloads.add(DownloadRecord(
        id: id,
        kind: kind,
        title: title,
        subtitle: subtitle,
        fileName: fileName,
        bytes: bytes,
        durationSec: durationSec,
      ));
      await _save();
      return true;
    } catch (_) {
      final f = File(path);
      if (await f.exists()) await f.delete();
      return false;
    } finally {
      progress.remove(id);
      notifyListeners();
    }
  }

  Future<void> delete(DownloadRecord r) async {
    if (current?.id == r.id) await closePlayer();
    final f = File(pathOf(r));
    if (await f.exists()) await f.delete();
    downloads.removeWhere((d) => d.id == r.id);
    await _save();
    notifyListeners();
  }
}

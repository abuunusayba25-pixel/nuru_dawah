import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pdfrx/pdfrx.dart';

import 'data.dart';
import 'services.dart';

final _s = AppState.instance;

const kEmerald = Color(0xFF047857);
const kEmeraldDark = Color(0xFF064E3B);
const kEmeraldSoft = Color(0xFFD1FAE5);
const kSlate = Color(0xFF1E293B);
const kSlateSoft = Color(0xFF64748B);
const kField = Color(0xFFF1F5F9);
const kBorder = Color(0xFFE2E8F0);

void toast(BuildContext c, String m) =>
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m)));

// ===========================================================================
// Shared widgets
// ===========================================================================

/// Eight-pointed star lattice - the one decorative motif of the app.
class StarPatternPainter extends CustomPainter {
  final Color color;
  const StarPatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    const step = 44.0;
    const r = 14.0;
    for (double y = 0; y < size.height + step; y += step) {
      for (double x = 0; x < size.width + step; x += step) {
        canvas.save();
        canvas.translate(x, y);
        canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: r * 2, height: r * 2), p);
        canvas.rotate(math.pi / 4);
        canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: r * 2, height: r * 2), p);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const SearchField({super.key, required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search_rounded, color: kSlateSoft),
        filled: true,
        fillColor: kField,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String hint;
  const EmptyState({super.key, required this.icon, required this.title, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: kEmerald.withOpacity(.35)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: kSlate)),
            const SizedBox(height: 6),
            Text(hint, textAlign: TextAlign.center, style: const TextStyle(color: kSlateSoft, height: 1.4)),
          ],
        ),
      ),
    );
  }
}

/// Round play/pause button that reflects the shared player.
class PlayCircle extends StatelessWidget {
  final AudioItem item;
  final double size;
  const PlayCircle(this.item, {super.key, this.size = 46});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _s,
      builder: (context, _) {
        final isCurrent = _s.current?.id == item.id;
        return StreamBuilder<PlayerState>(
          stream: _s.player.playerStateStream,
          builder: (context, snap) {
            final st = snap.data;
            final state = st?.processingState;
            final loading = isCurrent &&
                (state == ProcessingState.loading || state == ProcessingState.buffering);
            final playing = isCurrent && (st?.playing ?? false) && state != ProcessingState.completed;
            return SizedBox(
              width: size,
              height: size,
              child: Material(
                color: kEmerald,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final ok = await _s.play(item);
                    if (!ok) {
                      messenger.showSnackBar(const SnackBar(
                          content: Text('Imeshindwa kucheza. Angalia mtandao wako.')));
                    }
                  },
                  child: Center(
                    child: loading
                        ? SizedBox(
                            width: size * .42,
                            height: size * .42,
                            child: const CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                          )
                        : Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white, size: size * .62),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _DownloadButton extends StatelessWidget {
  final String id;
  final Future<bool> Function() onDownload;
  const _DownloadButton({required this.id, required this.onDownload});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _s,
      builder: (context, _) {
        if (_s.isDownloaded(id)) {
          return const SizedBox(
            width: 48,
            height: 48,
            child: Icon(Icons.check_circle_rounded, color: kEmerald),
          );
        }
        if (_s.isDownloading(id)) {
          final p = _s.progress[id] ?? 0;
          return SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  value: p > 0 ? p : null,
                  strokeWidth: 2.6,
                  color: kEmerald,
                  backgroundColor: kEmeraldSoft,
                ),
              ),
            ),
          );
        }
        return IconButton(
          tooltip: 'Pakua',
          icon: const Icon(Icons.download_rounded, color: kSlateSoft),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            final ok = await onDownload();
            messenger.showSnackBar(SnackBar(
                content: Text(ok ? 'Imepakuliwa' : 'Imeshindwa kupakua. Jaribu tena.')));
          },
        );
      },
    );
  }
}

class AudioDownloadButton extends StatelessWidget {
  final AudioItem item;
  const AudioDownloadButton(this.item, {super.key});
  @override
  Widget build(BuildContext context) =>
      _DownloadButton(id: item.id, onDownload: () => _s.downloadAudio(item));
}

class BookDownloadButton extends StatelessWidget {
  final BookItem book;
  const BookDownloadButton(this.book, {super.key});
  @override
  Widget build(BuildContext context) =>
      _DownloadButton(id: book.id, onDownload: () => _s.downloadBook(book));
}

// ===========================================================================
// Mini player + full-screen player
// ===========================================================================

void openPlayer(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    fullscreenDialog: true,
    builder: (_) => const PlayerScreen(),
  ));
}

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _s,
      builder: (context, _) {
        final item = _s.current;
        if (item == null) return const SizedBox.shrink();
        return Material(
          color: kEmeraldDark,
          child: InkWell(
            onTap: () => openPlayer(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<Duration>(
                  stream: _s.player.positionStream,
                  builder: (context, snap) {
                    final total = (_s.player.duration ?? item.duration).inMilliseconds;
                    final pos = (snap.data ?? Duration.zero).inMilliseconds;
                    return LinearProgressIndicator(
                      value: total > 0 ? (pos / total).clamp(0.0, 1.0) : 0,
                      minHeight: 2.5,
                      color: kEmeraldSoft,
                      backgroundColor: Colors.white24,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                            const SizedBox(height: 2),
                            Text(item.sheikh,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                      StreamBuilder<PlayerState>(
                        stream: _s.player.playerStateStream,
                        builder: (context, snap) {
                          final playing = (snap.data?.playing ?? false) &&
                              snap.data?.processingState != ProcessingState.completed;
                          return IconButton(
                            iconSize: 34,
                            color: Colors.white,
                            icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
                            onPressed: () => _s.play(item),
                          );
                        },
                      ),
                      IconButton(
                        color: Colors.white70,
                        tooltip: 'Funga',
                        icon: const Icon(Icons.close_rounded),
                        onPressed: _s.closePlayer,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _s,
      builder: (context, _) {
        final item = _s.current;
        if (item == null) {
          // Player was closed (or the file deleted) - leave this screen.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted && Navigator.of(context).canPop()) Navigator.of(context).pop();
          });
          return const Scaffold();
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Inacheza sasa', style: TextStyle(fontSize: 16)),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              const DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [kEmerald, kEmeraldDark],
                                  ),
                                ),
                              ),
                              CustomPaint(painter: StarPatternPainter(Colors.white.withOpacity(.14))),
                              const Center(
                                child: Icon(Icons.mosque_rounded, size: 88, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(item.title,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kSlate, height: 1.2)),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(item.sheikh, style: const TextStyle(fontSize: 15, color: kSlateSoft)),
                  ),
                  const SizedBox(height: 8),
                  const _SeekBar(),
                  const _Controls(),
                  const SizedBox(height: 8),
                  _DownloadStatus(item),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SeekBar extends StatefulWidget {
  const _SeekBar();
  @override
  State<_SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<_SeekBar> {
  double? _drag;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration?>(
      stream: _s.player.durationStream,
      builder: (context, ds) {
        final total = ds.data ?? _s.current?.duration ?? Duration.zero;
        final maxMs = math.max(1.0, total.inMilliseconds.toDouble());
        return StreamBuilder<Duration>(
          stream: _s.player.positionStream,
          builder: (context, ps) {
            final pos = ps.data ?? Duration.zero;
            final value = (_drag ?? pos.inMilliseconds.toDouble()).clamp(0.0, maxMs).toDouble();
            return Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    activeTrackColor: kEmerald,
                    inactiveTrackColor: kEmeraldSoft,
                    thumbColor: kEmerald,
                  ),
                  child: Slider(
                    value: value,
                    max: maxMs,
                    onChanged: (v) => setState(() => _drag = v),
                    onChangeEnd: (v) {
                      _s.player.seek(Duration(milliseconds: v.round()));
                      setState(() => _drag = null);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(fmtDuration(Duration(milliseconds: value.round())),
                          style: const TextStyle(color: kSlateSoft, fontSize: 13)),
                      Text(fmtDuration(total), style: const TextStyle(color: kSlateSoft, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls();

  Future<void> _skip(int seconds) async {
    final dur = _s.player.duration ?? Duration.zero;
    var t = _s.player.position + Duration(seconds: seconds);
    if (t < Duration.zero) t = Duration.zero;
    if (dur > Duration.zero && t > dur) t = dur;
    await _s.player.seek(t);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SkipButton(forward: false, onTap: () => _skip(-15)),
        const SizedBox(width: 20),
        StreamBuilder<PlayerState>(
          stream: _s.player.playerStateStream,
          builder: (context, snap) {
            final st = snap.data;
            final state = st?.processingState;
            final busy = state == ProcessingState.loading || state == ProcessingState.buffering;
            final playing = (st?.playing ?? false) && state != ProcessingState.completed;
            return SizedBox(
              width: 76,
              height: 76,
              child: Material(
                color: kEmerald,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    final c = _s.current;
                    if (c != null) _s.play(c);
                  },
                  child: Center(
                    child: busy
                        ? const SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
                        : Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white, size: 46),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 20),
        _SkipButton(forward: true, onTap: () => _skip(15)),
      ],
    );
  }
}

class _SkipButton extends StatelessWidget {
  final bool forward;
  final VoidCallback onTap;
  const _SkipButton({required this.forward, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 32,
      child: SizedBox(
        width: 56,
        height: 56,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(forward ? Icons.rotate_right_rounded : Icons.rotate_left_rounded,
                size: 52, color: kSlate),
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text('15', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: kSlate)),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadStatus extends StatelessWidget {
  final AudioItem item;
  const _DownloadStatus(this.item);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _s,
      builder: (context, _) {
        final String label;
        if (_s.isDownloaded(item.id)) {
          label = 'Imepakuliwa - inapatikana bila mtandao';
        } else if (_s.isDownloading(item.id)) {
          label = 'Inapakua... ${((_s.progress[item.id] ?? 0) * 100).round()}%';
        } else {
          label = 'Haijapakuliwa';
        }
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 2, 4, 2),
          decoration: BoxDecoration(
            color: kField,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(color: kSlate, fontSize: 14))),
              AudioDownloadButton(item),
            ],
          ),
        );
      },
    );
  }
}

// ===========================================================================
// Tab 1 - Darsa & Mihadhara
// ===========================================================================

class DarsaPage extends StatefulWidget {
  const DarsaPage({super.key});
  @override
  State<DarsaPage> createState() => _DarsaPageState();
}

class _DarsaPageState extends State<DarsaPage> {
  String _query = '';
  String _category = 'Zote';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final items = sampleAudios.where((a) {
      final okCat = _category == 'Zote' || a.category == _category;
      final okQ = q.isEmpty || a.title.toLowerCase().contains(q) || a.sheikh.toLowerCase().contains(q);
      return okCat && okQ;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Darsa na Mihadhara')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: SearchField(
              hint: 'Tafuta sheikh au mada',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: kCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final c = kCategories[i];
                return ChoiceChip(
                  label: Text(c),
                  selected: _category == c,
                  showCheckmark: false,
                  selectedColor: kEmerald,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: kBorder),
                  labelStyle: TextStyle(
                    color: _category == c ? Colors.white : kSlate,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) => setState(() => _category = c),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: items.isEmpty
                ? const EmptyState(
                    icon: Icons.headphones_rounded,
                    title: 'Hakuna matokeo',
                    hint: 'Jaribu jina lingine la sheikh, mada, au chagua kundi la Zote.')
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: kBorder),
                    itemBuilder: (_, i) => AudioTile(items[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class AudioTile extends StatelessWidget {
  final AudioItem item;
  const AudioTile(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          PlayCircle(item),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kSlate)),
                const SizedBox(height: 3),
                Text('${item.sheikh}  |  ${fmtDuration(item.duration)}',
                    style: const TextStyle(fontSize: 13, color: kSlateSoft)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: kEmeraldSoft, borderRadius: BorderRadius.circular(6)),
                  child: Text('${item.type} - ${item.category}',
                      style: const TextStyle(fontSize: 12, color: kEmeraldDark, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          AudioDownloadButton(item),
        ],
      ),
    );
  }
}

// ===========================================================================
// Tab 2 - Fatawa & Rudud
// ===========================================================================

class FatawaPage extends StatefulWidget {
  const FatawaPage({super.key});
  @override
  State<FatawaPage> createState() => _FatawaPageState();
}

class _FatawaPageState extends State<FatawaPage> {
  int _mode = 0; // 0 = Fatawa, 1 = Rudud
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final items = sampleQa.where((e) {
      if (e.isRudud != (_mode == 1)) return false;
      return q.isEmpty ||
          e.question.toLowerCase().contains(q) ||
          e.answer.toLowerCase().contains(q) ||
          e.category.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Fatawa na Rudud')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<int>(
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: kEmerald,
                  selectedForegroundColor: Colors.white,
                  foregroundColor: kSlate,
                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                segments: const [
                  ButtonSegment(value: 0, label: Text('Fatawa (Maandishi)')),
                  ButtonSegment(value: 1, label: Text('Rudud (Audio/Text)')),
                ],
                selected: {_mode},
                onSelectionChanged: (s) => setState(() => _mode = s.first),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SearchField(
              hint: _mode == 0 ? 'Tafuta swali au jibu' : 'Tafuta rudd',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const EmptyState(
                    icon: Icons.question_answer_rounded,
                    title: 'Hakuna matokeo',
                    hint: 'Jaribu neno lingine la kutafuta.')
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => QaCard(items[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class QaCard extends StatefulWidget {
  final QaItem item;
  const QaCard(this.item, {super.key});
  @override
  State<QaCard> createState() => _QaCardState();
}

class _QaCardState extends State<QaCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.item;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(e.category,
              style: const TextStyle(fontSize: 13, color: kEmerald, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(e.question,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kSlate, height: 1.3)),
          const SizedBox(height: 10),
          Text(e.answer,
              maxLines: _open ? null : 3,
              overflow: _open ? TextOverflow.visible : TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, color: kSlate, height: 1.5)),
          const SizedBox(height: 4),
          Row(
            children: [
              TextButton(
                onPressed: () => setState(() => _open = !_open),
                style: TextButton.styleFrom(foregroundColor: kEmerald, padding: EdgeInsets.zero),
                child: Text(_open ? 'Onyesha kidogo' : 'Soma zaidi'),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Nakili',
                icon: const Icon(Icons.copy_rounded, size: 20, color: kSlateSoft),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: '${e.question}\n\n${e.answer}'));
                  toast(context, 'Imenakiliwa');
                },
              ),
            ],
          ),
          if (e.audio != null) ...[
            const Divider(height: 20, color: kBorder),
            Row(
              children: [
                PlayCircle(e.audio!, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Sikiliza jibu  |  ${fmtDuration(e.audio!.duration)}',
                      style: const TextStyle(fontSize: 14, color: kSlate, fontWeight: FontWeight.w600)),
                ),
                AudioDownloadButton(e.audio!),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ===========================================================================
// Tab 3 - Vitabu
// ===========================================================================

const _coverColors = [
  [Color(0xFF047857), Color(0xFF064E3B)],
  [Color(0xFF0F766E), Color(0xFF134E4A)],
  [Color(0xFF15803D), Color(0xFF14532D)],
  [Color(0xFF166534), Color(0xFF052E16)],
];

class BookCover extends StatelessWidget {
  final BookItem book;
  const BookCover(this.book, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = _coverColors[book.title.length % _coverColors.length];
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
            ),
          ),
          CustomPaint(painter: StarPatternPainter(Colors.white.withOpacity(.12))),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(book.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15, height: 1.2)),
            ),
          ),
        ],
      ),
    );
  }
}

void openBook(BuildContext context, BookItem b) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => PdfScreen(book: b)));
}

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});
  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  bool _grid = true;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final books = sampleBooks
        .where((b) => q.isEmpty || b.title.toLowerCase().contains(q) || b.author.toLowerCase().contains(q))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vitabu'),
        actions: [
          IconButton(
            tooltip: _grid ? 'Orodha' : 'Gridi',
            icon: Icon(_grid ? Icons.view_list_rounded : Icons.grid_view_rounded),
            onPressed: () => setState(() => _grid = !_grid),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: SearchField(hint: 'Tafuta kitabu au mwandishi', onChanged: (v) => setState(() => _query = v)),
          ),
          Expanded(
            child: books.isEmpty
                ? const EmptyState(
                    icon: Icons.menu_book_rounded,
                    title: 'Hakuna kitabu kilichopatikana',
                    hint: 'Jaribu jina lingine la kitabu au mwandishi.')
                : _grid
                    ? GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.58,
                        ),
                        itemCount: books.length,
                        itemBuilder: (_, i) => _BookGridCard(books[i]),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount: books.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) => _BookRow(books[i]),
                      ),
          ),
        ],
      ),
    );
  }
}

class _BookGridCard extends StatelessWidget {
  final BookItem book;
  const _BookGridCard(this.book);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => openBook(context, book),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: BookCover(book)),
          const SizedBox(height: 8),
          Text(book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: kSlate)),
          Text(book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: kSlateSoft)),
          Row(
            children: [
              Expanded(
                child: Text('${book.sizeMb.toStringAsFixed(1)} MB',
                    style: const TextStyle(fontSize: 13, color: kSlateSoft)),
              ),
              BookDownloadButton(book),
            ],
          ),
        ],
      ),
    );
  }
}

class _BookRow extends StatelessWidget {
  final BookItem book;
  const _BookRow(this.book);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => openBook(context, book),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          children: [
            SizedBox(width: 60, height: 82, child: BookCover(book)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: kSlate)),
                  const SizedBox(height: 3),
                  Text(book.author, style: const TextStyle(fontSize: 13, color: kSlateSoft)),
                  const SizedBox(height: 3),
                  Text('${book.sizeMb.toStringAsFixed(1)} MB',
                      style: const TextStyle(fontSize: 13, color: kSlateSoft)),
                ],
              ),
            ),
            BookDownloadButton(book),
          ],
        ),
      ),
    );
  }
}

class PdfScreen extends StatelessWidget {
  final BookItem book;
  const PdfScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17)),
        actions: [BookDownloadButton(book)],
      ),
      body: ListenableBuilder(
        listenable: _s,
        builder: (context, _) {
          final rec = _s.recordOf(book.id);
          // Offline copy is used whenever it exists; otherwise stream from the URL.
          if (rec != null) {
            return PdfViewer.file(_s.pathOf(rec), key: ValueKey('file_${book.id}'));
          }
          return PdfViewer.uri(Uri.parse(book.url), key: ValueKey('net_${book.id}'));
        },
      ),
    );
  }
}

// ===========================================================================
// Tab 4 - Downloads
// ===========================================================================

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Downloads'),
          bottom: const TabBar(
            labelColor: kEmerald,
            indicatorColor: kEmerald,
            unselectedLabelColor: kSlateSoft,
            labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            tabs: [Tab(text: 'Sauti'), Tab(text: 'Vitabu')],
          ),
        ),
        body: ListenableBuilder(
          listenable: _s,
          builder: (context, _) {
            final audios = _s.downloads.where((r) => r.kind == 'audio').toList();
            final books = _s.downloads.where((r) => r.kind == 'book').toList();
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(color: kEmeraldSoft, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Icon(Icons.sd_storage_rounded, color: kEmeraldDark, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'Nafasi iliyotumika: ${fmtBytes(_s.totalBytes)}  (${_s.downloads.length} faili)',
                        style: const TextStyle(color: kEmeraldDark, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _DownloadList(
                        records: audios,
                        emptyIcon: Icons.headphones_rounded,
                        emptyTitle: 'Hakuna sauti zilizopakuliwa',
                        emptyHint: 'Gusa aikoni ya kupakua kwenye Darsa au Rudud ili usikilize bila mtandao.',
                      ),
                      _DownloadList(
                        records: books,
                        emptyIcon: Icons.menu_book_rounded,
                        emptyTitle: 'Hakuna vitabu vilivyopakuliwa',
                        emptyHint: 'Pakua kitabu kwenye Vitabu ili ukisome bila mtandao.',
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DownloadList extends StatelessWidget {
  final List<DownloadRecord> records;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptyHint;
  const _DownloadList({
    required this.records,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptyHint,
  });

  Future<void> _confirmDelete(BuildContext context, DownloadRecord r) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Futa faili?'),
        content: Text('"${r.title}" (${fmtBytes(r.bytes)}) itafutwa kwenye simu yako.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Ghairi')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
            child: const Text('Futa'),
          ),
        ],
      ),
    );
    if (ok == true) await _s.delete(r);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return EmptyState(icon: emptyIcon, title: emptyTitle, hint: emptyHint);
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: records.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: kBorder),
      itemBuilder: (context, i) {
        final r = records[i];
        final isAudio = r.kind == 'audio';
        final audio = AudioItem(
          id: r.id,
          title: r.title,
          sheikh: r.subtitle,
          category: '',
          type: '',
          url: '',
          duration: Duration(seconds: r.durationSec),
        );
        final book = BookItem(
            id: r.id, title: r.title, author: r.subtitle, sizeMb: r.bytes / (1024 * 1024), url: '');
        return InkWell(
          onTap: () => isAudio ? _s.play(audio) : openBook(context, book),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                if (isAudio)
                  PlayCircle(audio)
                else
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(color: kEmeraldSoft, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.picture_as_pdf_rounded, color: kEmeraldDark),
                  ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kSlate)),
                      const SizedBox(height: 3),
                      Text('${r.subtitle}  |  ${fmtBytes(r.bytes)}',
                          style: const TextStyle(fontSize: 13, color: kSlateSoft)),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Futa',
                  icon: Icon(Icons.delete_outline_rounded, color: Colors.red.shade700),
                  onPressed: () => _confirmDelete(context, r),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

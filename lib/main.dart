import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NuruDawahApp());
}

class NuruDawahApp extends StatelessWidget {
  const NuruDawahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Nuru Dawah",
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> mainCategories = const [
    {"title": "Darsa", "count": 12772},
    {"title": "Kalima", "count": 5219},
    {"title": "Khutbah", "count": 4267},
    {"title": "Mihadhara", "count": 214},
    {"title": "E-books", "count": 92},
    {"title": "Dawrah/Nad-wah", "count": 1291},
    {"title": "Ruduud", "count": 1122},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuru Dawah'),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: mainCategories.length,
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey,
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final item = mainCategories[index];
          return ListTile(
            leading: const Icon(Icons.folder_outlined, color: Colors.grey),
            title: Text(
              item["title"].toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            trailing: Text(
              '(${item["count"]})',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryDetailScreen(
                    categoryTitle: item["title"].toString(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CategoryDetailScreen extends StatelessWidget {
  final String categoryTitle;
  const CategoryDetailScreen({super.key, required this.categoryTitle});

  final List<String> darsaTopics = const [
    "Fiqh",
    "Manhaj",
    "Siyrah",
    "Tawhiyd",
    "Wanawake",
    "'Aqiydah",
    "Lugha",
    "Tafsiri",
    "Hadithi",
    "Usuul",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: ListView.separated(
        itemCount: darsaTopics.length,
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey,
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              darsaTopics[index],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AudioPlayerScreen(
                    title: darsaTopics[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AudioPlayerScreen extends StatefulWidget {
  final String title;
  const AudioPlayerScreen({super.key, required this.title});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.music_note,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 30),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble().clamp(0, duration.inSeconds.toDouble()),
              onChanged: (value) async {
                final newPosition = Duration(seconds: value.toInt());
                await _audioPlayer.seek(newPosition);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(position)),
                Text(formatTime(duration - position)),
              ],
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.green,
              child: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () async {
                  if (isPlaying) {
                    await _audioPlayer.pause();
                  } else {
                    // Demo Audio URL
                    await _audioPlayer.play(
                      UrlSource('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

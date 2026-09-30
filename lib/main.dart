import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const NuruDawahApp());
}

class NuruDawahApp extends StatelessWidget {
  const NuruDawahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nuru Dawah',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          elevation: 0,
        ),
      ),
      home: const MainHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const Center(child: Text("Live Streams / Radio", style: TextStyle(color: Colors.white))),
    const Center(child: Text("Vitabu / E-Books", style: TextStyle(color: Colors.white))),
    const Center(child: Text("Mipangilio / Settings", style: TextStyle(color: Colors.white))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1F1F1F),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Nyumbani'),
          BottomNavigationBarItem(icon: Icon(Icons.radio), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.picture_as_pdf), label: 'Vitabu'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Mpangilio'),
        ],
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String searchQuery = "";

  final List<Map<String, dynamic>> mainCategories = const [
    {"title": "Darsa", "count": "12,772", "icon": Icons.folder, "color": Colors.green},
    {"title": "Kalima", "count": "5,219", "icon": Icons.folder, "color": Colors.blue},
    {"title": "Khutbah", "count": "4,267", "icon": Icons.folder, "color": Colors.orange},
    {"title": "Mihadhara", "count": "214", "icon": Icons.folder, "color": Colors.purple},
    {"title": "E-books", "count": "92", "icon": Icons.folder, "color": Colors.amber},
    {"title": "Dawrah / Nad-wah", "count": "1,291", "icon": Icons.folder, "color": Colors.teal},
    {"title": "Ruduud", "count": "1,122", "icon": Icons.folder, "color": Colors.red},
    {"title": "Minaaqashah", "count": "350", "icon": Icons.folder, "color": Colors.indigo},
  ];

  final List<Map<String, String>> mostListened = const [
    {
      "id": "ml1",
      "title": "Manhaj Assalikin - Darsa 01",
      "scholar": "Sheikh Abuul Fadhl",
      "plays": "12.5k Listens",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
    },
    {
      "id": "ml2",
      "title": "Bulugh al-Maram - Kitab al-Taharah",
      "scholar": "Sheikh Abuul Fadhl",
      "plays": "9.8k Listens",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
    },
    {
      "id": "ml3",
      "title": "Khutbah ya Ijumaa - Taqwa",
      "scholar": "Ustadh Abdallah",
      "plays": "8.2k Listens",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCategories = mainCategories
        .where((cat) => cat["title"].toString().toLowerCase().contains(searchQuery))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nuru Dawah"),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.green),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. SEARCH BAR
              TextField(
                onChanged: (val) {
                  setState(() {
                    searchQuery = val.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Tafuta Category, Darsa au Msomeshaji...",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1F1F1F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. MOST LISTENED SECTION
              const Text(
                "Zinazosikilizwa Zaidi (Most Listened)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mostListened.length,
                  itemBuilder: (context, index) {
                    final item = mostListened[index];
                    return Container(
                      width: 250,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1F1F),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.play_arrow, color: Colors.white),
                        ),
                        title: Text(
                          item["title"]!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            Text(item["scholar"]!, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.headset, size: 12, color: Colors.green),
                                const SizedBox(width: 4),
                                Text(item["plays"]!, style: const TextStyle(color: Colors.green, fontSize: 10)),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AudioPlayerScreen(
                                title: item["title"]!,
                                audioUrl: item["url"]!,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),

              // 3. CATEGORIES MAIN LIST
              const Text(
                "Makundi Makuu (Categories)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final cat = filteredCategories[index];
                  return Card(
                    color: const Color(0xFF1F1F1F),
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Icon(cat["icon"], color: cat["color"], size: 28),
                      title: Text(
                        cat["title"],
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                      ),
                      trailing: Text(
                        "(${cat['count']})",
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      onTap: () {
                        if (cat["title"] == "Darsa") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DarsaSubCategoriesScreen(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContentItemsListScreen(categoryTitle: cat["title"]),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SKRINI YA SUB-CATEGORIES ZA DARSA
class DarsaSubCategoriesScreen extends StatelessWidget {
  const DarsaSubCategoriesScreen({super.key});

  final List<Map<String, dynamic>> darsaSubjects = const [
    {"title": "Fiqh", "icon": Icons.auto_stories, "color": Colors.green},
    {"title": "Tawhiyd", "icon": Icons.account_balance, "color": Colors.blue},
    {"title": "Tafseer", "icon": Icons.menu_book, "color": Colors.orange},
    {"title": "Hadith", "icon": Icons.record_voice_over, "color": Colors.purple},
    {"title": "Sira", "icon": Icons.history_edu, "color": Colors.amber},
    {"title": "Usuul", "icon": Icons.account_tree, "color": Colors.teal},
    {"title": "Lugha", "icon": Icons.translate, "color": Colors.cyan},
    {"title": "Ahkaam Tajweed", "icon": Icons.record_voice_over, "color": Colors.lightGreen},
    {"title": "Manhaj", "icon": Icons.explore, "color": Colors.deepOrange},
    {"title": "Mustalahul Hadith", "icon": Icons.find_in_page, "color": Colors.indigo},
    {"title": "Darsa za Wanawake", "icon": Icons.female, "color": Colors.pink},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Makundi ya Darsa")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: darsaSubjects.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final cat = darsaSubjects[index];
            return Card(
              color: const Color(0xFF1F1F1F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContentItemsListScreen(categoryTitle: cat["title"]),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(cat["icon"], size: 36, color: cat["color"]),
                    const SizedBox(height: 8),
                    Text(
                      cat["title"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// 1. LIST YA MAUDHUI (VITABU/AUDIO) HUSIKA NA MSOMESHAJI
class ContentItemsListScreen extends StatelessWidget {
  final String categoryTitle;

  const ContentItemsListScreen({super.key, required this.categoryTitle});

  final List<Map<String, String>> sampleItems = const [
    {
      "book": "Manhaj Assalikin",
      "scholar": "Sheikh Abuul Fadhl",
      "description": "Darsa za masomo kulingana na muundo wa Chuo",
    },
    {
      "book": "Bulugh al-Maram",
      "scholar": "Sheikh Abuul Fadhl",
      "description": "Ahadith na Ahkam za masomo",
    },
    {
      "book": "Sharh Al-Sunnah",
      "scholar": "Ustadh Abdallah",
      "description": "Masomo ya Misingi na Taaliym",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryTitle)),
      body: ListView.builder(
        itemCount: sampleItems.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final item = sampleItems[index];
          return Card(
            color: const Color(0xFF1F1F1F),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.folder, color: Colors.white),
              ),
              title: Text(
                item["book"]!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "Msomeshaji: ${item['scholar']}\n${item['description']}",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.green, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioLessonsListScreen(
                      bookName: item["book"]!,
                      scholarName: item["scholar"]!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// 2. LIST YA AUDIO ZA DARSA HUSIKA NA DOWNLOAD
class AudioLessonsListScreen extends StatefulWidget {
  final String bookName;
  final String scholarName;

  const AudioLessonsListScreen({
    super.key,
    required this.bookName,
    required this.scholarName,
  });

  @override
  State<AudioLessonsListScreen> createState() => _AudioLessonsListScreenState();
}

class _AudioLessonsListScreenState extends State<AudioLessonsListScreen> {
  final List<Map<String, String>> lessons = [
    {
      "id": "1",
      "title": "Darsa 01 - Utulivu na Niyyah",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
    },
    {
      "id": "2",
      "title": "Darsa 02 - Hukumu za Twahara",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
    },
    {
      "id": "3",
      "title": "Darsa 03 - Aina za Maji na Uosaji",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
    },
  ];

  Map<String, double> downloadProgress = {};
  Map<String, bool> isOfflineDownloaded = {};

  Future<void> downloadAudioFile(String url, String filename, bool saveToPublicStorage, String lessonId) async {
    setState(() {
      downloadProgress[lessonId] = 0.1;
    });

    try {
      final response = await http.get(Uri.parse(url));
      Directory dir;

      if (saveToPublicStorage) {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          dir = await getApplicationDocumentsDirectory();
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final filePath = "${dir.path}/$filename.mp3";
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      setState(() {
        downloadProgress[lessonId] = 1.0;
        if (!saveToPublicStorage) {
          isOfflineDownloaded[lessonId] = true;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(saveToPublicStorage
                ? "Imepakuliwa kwenye Simu (Download Folder)!"
                : "Imepakuliwa kwenye App kwa ajili ya Offline!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        downloadProgress[lessonId] = 0.0;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Imefeli kupakua: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void showDownloadOptions(BuildContext context, Map<String, String> lesson) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson["title"]!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 15),
              ListTile(
                leading: const Icon(Icons.offline_pin, color: Colors.green),
                title: const Text("Pakua ndani ya App (Offline Playback)", style: TextStyle(color: Colors.white)),
                subtitle: const Text("Sikiliza bila MB ndani ya App tu", style: TextStyle(color: Colors.grey)),
                onTap: () {
                  Navigator.pop(context);
                  downloadAudioFile(lesson["url"]!, "${lesson['title']}_app", false, lesson["id"]!);
                },
              ),
              const Divider(color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.download_for_offline, color: Colors.blue),
                title: const Text("Pakua kwenye Simu (Download Folder)", style: TextStyle(color: Colors.white)),
                subtitle: const Text("Hifadhi file kwenye simu yako ili urushe au usikilize popote", style: TextStyle(color: Colors.grey)),
                onTap: () {
                  Navigator.pop(context);
                  downloadAudioFile(lesson["url"]!, "${lesson['title']}", true, lesson["id"]!);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.bookName, style: const TextStyle(fontSize: 16)),
            Text(widget.scholarName, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: lessons.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          final lessonId = lesson["id"]!;
          final isDownloaded = isOfflineDownloaded[lessonId] ?? false;
          final progress = downloadProgress[lessonId] ?? 0.0;

          return Card(
            color: const Color(0xFF1F1F1F),
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isDownloaded ? Colors.green.withOpacity(0.2) : Colors.white10,
                child: Icon(
                  isDownloaded ? Icons.check_circle : Icons.play_arrow,
                  color: isDownloaded ? Colors.green : Colors.white,
                ),
              ),
              title: Text(
                lesson["title"]!,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              subtitle: progress > 0.0 && progress < 1.0
                  ? LinearProgressIndicator(value: progress, color: Colors.green)
                  : Text(
                      isDownloaded ? "Tayari ipo Offline" : "Bonyeza kusikiliza",
                      style: TextStyle(color: isDownloaded ? Colors.green : Colors.grey, fontSize: 12),
                    ),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () => showDownloadOptions(context, lesson),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioPlayerScreen(
                      title: lesson["title"]!,
                      audioUrl: lesson["url"]!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// 3. AUDIO PLAYER SCREEN YENYE SPEED CONTROL
class AudioPlayerScreen extends StatefulWidget {
  final String title;
  final String audioUrl;

  const AudioPlayerScreen({super.key, required this.title, required this.audioUrl});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double playbackSpeed = 1.0;

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

    _audioPlayer.setSourceUrl(widget.audioUrl);
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

  void changeSpeed() {
    setState(() {
      if (playbackSpeed == 1.0) {
        playbackSpeed = 1.25;
      } else if (playbackSpeed == 1.25) {
        playbackSpeed = 1.5;
      } else if (playbackSpeed == 1.5) {
        playbackSpeed = 0.75;
      } else {
        playbackSpeed = 1.0;
      }
      _audioPlayer.setPlaybackRate(playbackSpeed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_note, size: 100, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 30),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble().clamp(0.0, duration.inSeconds.toDouble()),
              onChanged: (value) async {
                final pos = Duration(seconds: value.toInt());
                await _audioPlayer.seek(pos);
              },
              activeColor: Colors.green,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position), style: const TextStyle(color: Colors.grey)),
                  Text(formatTime(duration), style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: changeSpeed,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1F1F1F)),
                  child: Text("${playbackSpeed}x", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.green,
                  child: IconButton(
                    iconSize: 40,
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    color: Colors.white,
                    onPressed: () async {
                      if (isPlaying) {
                        await _audioPlayer.pause();
                      } else {
                        await _audioPlayer.play(UrlSource(widget.audioUrl));
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border, color: Colors.white),
                  onPressed: () {},
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

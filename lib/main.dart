import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const NuruDawahApp());
}

class NuruDawahApp extends StatefulWidget {
  const NuruDawahApp({super.key});

  static _NuruDawahAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_NuruDawahAppState>()!;

  @override
  State<NuruDawahApp> createState() => _NuruDawahAppState();
}

class _NuruDawahAppState extends State<NuruDawahApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFFFB300);

    return MaterialApp(
      title: 'Nuru Dawah',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          secondary: Color(0xFF0284C7),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: primaryColor,
          secondary: Color(0xFF38BDF8),
          surface: Color(0xFF1E293B),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E293B),
          foregroundColor: Colors.white,
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
    const Center(child: Text("Live Streams / Radio")),
    const EbooksListScreen(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        backgroundColor: theme.colorScheme.surface,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Nyumbani'),
          BottomNavigationBarItem(icon: Icon(Icons.radio_rounded), label: 'Live'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Vitabu'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Mpangilio'),
        ],
      ),
    );
  }
}

// ==================== DASHBOARD / HOME ====================
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String searchQuery = "";

  final List<Map<String, dynamic>> mainCategories = const [
    {"title": "Maswali na Majibu (Fatawa)", "count": "850+", "icon": Icons.quiz_rounded, "color": Color(0xFFEC4899)},
    {"title": "Darsa", "count": "12,772", "icon": Icons.auto_stories, "color": Color(0xFFFFB300)},
    {"title": "Kalima", "count": "5,219", "icon": Icons.record_voice_over, "color": Color(0xFF0284C7)},
    {"title": "Khutbah", "count": "4,267", "icon": Icons.campaign, "color": Color(0xFFF97316)},
    {"title": "Mihadhara", "count": "214", "icon": Icons.groups, "color": Color(0xFFA855F7)},
    {"title": "E-books", "count": "92", "icon": Icons.menu_book, "color": Color(0xFFEAB308)},
    {"title": "Dawrah / Nad-wah", "count": "1,291", "icon": Icons.school, "color": Color(0xFF14B8A6)},
    {"title": "Ruduud", "count": "1,122", "icon": Icons.gavel, "color": Color(0xFFEF4444)},
    {"title": "Minaaqashah", "count": "350", "icon": Icons.forum, "color": Color(0xFF6366F1)},
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
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredCategories = mainCategories
        .where((cat) => cat["title"].toString().toLowerCase().contains(searchQuery))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.menu_book_rounded, color: theme.colorScheme.primary, size: 22),
            ),
            const SizedBox(width: 10),
            const Text("Nuru Dawah", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: "Badili Mode",
            onPressed: () {
              NuruDawahApp.of(context).toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.admin_panel_settings_rounded, color: theme.colorScheme.primary),
            tooltip: "Admin Panel",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF1E293B), const Color(0xFF334155)]
                        : [const Color(0xFFFFF7ED), const Color(0xFFFFEDD5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kituo cha Darsa na Mawaidha",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Nuru Dawah App",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Sikiliza darsa, khutbah na tafuta hukumu za Dini kwa urahisi.",
                            style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[400] : Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.4), width: 1.5),
                      ),
                      child: Icon(Icons.auto_stories_rounded, size: 36, color: theme.colorScheme.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                onChanged: (val) {
                  setState(() {
                    searchQuery = val.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Tafuta Category, Darsa au Msomeshaji...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Zinazosikilizwa Zaidi (Most Listened)",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mostListened.length,
                  itemBuilder: (context, index) {
                    final item = mostListened[index];
                    return Container(
                      width: 250,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primary,
                          child: const Icon(Icons.play_arrow_rounded, color: Colors.black),
                        ),
                        title: Text(
                          item["title"]!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item["scholar"]!, style: const TextStyle(fontSize: 11)),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.headset, size: 12, color: theme.colorScheme.primary),
                                const SizedBox(width: 4),
                                Text(item["plays"]!, style: TextStyle(color: theme.colorScheme.primary, fontSize: 10)),
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
              const SizedBox(height: 22),
              const Text(
                "Makundi Makuu (Categories)",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final cat = filteredCategories[index];
                  return Card(
                    color: theme.colorScheme.surface,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (cat["color"] as Color).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(cat["icon"], color: cat["color"], size: 24),
                      ),
                      title: Text(
                        cat["title"],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      trailing: Text(
                        "(${cat['count']})",
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      onTap: () {
                        if (cat["title"] == "Maswali na Majibu (Fatawa)") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QnaSearchScreen(),
                            ),
                          );
                        } else if (cat["title"] == "E-books") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EbooksListScreen(),
                            ),
                          );
                        } else if (cat["title"] == "Darsa") {
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

// ==================== ADMIN DASHBOARD ====================
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            tooltip: "Toka (Logout)",
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainHomeScreen()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user_rounded, color: Colors.amber, size: 30),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Akaunti: Admin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("Panel ya Usimamizi wa Maudhui", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("Chagua Kitendo:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildAdminCard(
                    context,
                    title: "Pakia Audio",
                    subtitle: "Weka MP3 ya Darsa, Khutbah n.k.",
                    icon: Icons.upload_file_rounded,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UploadAudioScreen()),
                      );
                    },
                  ),
                  _buildAdminCard(
                    context,
                    title: "Pakia Kitabu (PDF/Word)",
                    subtitle: "Ongeza E-book mpya",
                    icon: Icons.picture_as_pdf_rounded,
                    color: Colors.redAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UploadPdfScreen()),
                      );
                    },
                  ),
                  _buildAdminCard(
                    context,
                    title: "Ongeza Fatwa",
                    subtitle: "Weka Maswali na Majibu",
                    icon: Icons.quiz_rounded,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddFatwaScreen()),
                      );
                    },
                  ),
                  _buildAdminCard(
                    context,
                    title: "Dhibiti Maudhui",
                    subtitle: "Futa au Badilisha Maudhui",
                    icon: Icons.edit_note_rounded,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ManageContentScreen()),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.15),
                radius: 26,
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 10),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== UPLOAD AUDIO SCREEN (WITH DARSA SUB-CATEGORIES) ====================
class UploadAudioScreen extends StatefulWidget {
  const UploadAudioScreen({super.key});

  @override
  State<UploadAudioScreen> createState() => _UploadAudioScreenState();
}

class _UploadAudioScreenState extends State<UploadAudioScreen> {
  final _titleController = TextEditingController();
  final _scholarController = TextEditingController();
  final _urlController = TextEditingController();
  String _selectedCategory = "Darsa";
  String _selectedDarsaSubject = "Fiqh";
  String _uploadedFileName = "";

  final List<String> _categories = [
    "Darsa",
    "Kalima",
    "Khutbah",
    "Mihadhara",
    "Dawrah / Nad-wah",
    "Ruduud",
    "Minaaqashah"
  ];

  final List<String> _darsaSubjects = [
    "Fiqh",
    "Tawhiyd",
    "Tafseer",
    "Hadith",
    "Seerah",
    "Akhlaq"
  ];

  void _pickLocalFile() {
    setState(() {
      _uploadedFileName = "darsa_audio_example.mp3";
      _urlController.text = "https://nurudawah.org/audio/$_uploadedFileName";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Faili la audio limechaguliwa kikamilifu!")),
    );
  }

  void _submitAudio() {
    if (_titleController.text.isEmpty || _scholarController.text.isEmpty || _urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tafadhali jaza taarifa zote!")),
      );
      return;
    }

    String locationInfo = _selectedCategory == "Darsa" ? "Category: Darsa -> $_selectedDarsaSubject" : "Category: $_selectedCategory";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Audio imehifadhiwa ($locationInfo)!"),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Pakia Audio Mpya")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Taarifa na Location ya Audio:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            
            // 1. SELECT MAIN CATEGORY
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: "Kundi Kuu (Main Category)",
                prefixIcon: const Icon(Icons.category_rounded),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
            ),
            const SizedBox(height: 14),

            // 2. SUB-CATEGORY OPTION (ONLY IF DARSA IS SELECTED)
            if (_selectedCategory == "Darsa") ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Chagua Somo / Location ya Darsa (Sub-Category):",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedDarsaSubject,
                      decoration: InputDecoration(
                        labelText: "Somo la Darsa (mf. Fiqh, Tawhiyd)",
                        prefixIcon: const Icon(Icons.menu_book_rounded),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: _darsaSubjects.map((sub) {
                        return DropdownMenuItem(value: sub, child: Text(sub));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedDarsaSubject = val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Kichwa cha Darsa / Audio",
                hintText: "mf. Manhaj Assalikin - Darsa 01",
                prefixIcon: const Icon(Icons.title_rounded),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _scholarController,
              decoration: InputDecoration(
                labelText: "Jina la Msomeshaji / Sheikh",
                hintText: "mf. Sheikh Abuul Fadhl",
                prefixIcon: const Icon(Icons.person_rounded),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 18),

            // AUDIO SOURCE (CHOICE: UPLOAD FROM PHONE OR PASTE LINK)
            const Text("Sauti / Audio File:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface,
                      foregroundColor: theme.colorScheme.primary,
                      side: BorderSide(color: theme.colorScheme.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _pickLocalFile,
                    icon: const Icon(Icons.audio_file_rounded),
                    label: const Text("Chagua Faili Simuni"),
                  ),
                ),
              ],
            ),
            if (_uploadedFileName.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text("Faili lililochaguliwa: $_uploadedFileName", style: const TextStyle(color: Colors.green, fontSize: 12)),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: "Au Weka Link ya Audio (Audio URL / MP3 Link)",
                hintText: "https://nurudawah.org/audio/sample.mp3",
                helperText: "Anwani ya intaneti ilipo hifadhiwa audio yako mp3",
                prefixIcon: const Icon(Icons.link_rounded),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _submitAudio,
                icon: const Icon(Icons.cloud_upload_rounded),
                label: const Text("Pakia / Hifadhi Audio", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== ADD FATWA SCREEN ====================
class AddFatwaScreen extends StatefulWidget {
  const AddFatwaScreen({super.key});

  @override
  State<AddFatwaScreen> createState() => _AddFatwaScreenState();
}

class _AddFatwaScreenState extends State<AddFatwaScreen> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _scholarController = TextEditingController();
  String _category = "Swala";

  final List<String> _categories = ["Swala", "Swaumu", "Zaka", "Hija", "Ndoa", "Biashara"];

  void _saveFatwa() {
    if (_questionController.text.isEmpty || _answerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tafadhali jaza Swali na Jibu!")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fatwa imehifadhiwa kikamilifu!"), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Ongeza Fatwa Mpya")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: _category,
              decoration: InputDecoration(
                labelText: "Kundi la Fatwa",
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: "Swali",
                hintText: "mf. Ni ipi hukumu ya...",
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _answerController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Jibu la Fatwa",
                hintText: "Andika maelezo ya jibu hapa...",
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _scholarController,
              decoration: InputDecoration(
                labelText: "Sheikh / Mwanachuoni Aliyetoa Fatwa",
                hintText: "mf. Sheikh Abuul Fadhl",
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _saveFatwa,
              icon: const Icon(Icons.check_circle_rounded),
              label: const Text("Hifadhi Fatwa", style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

// ==================== MANAGE CONTENT SCREEN ====================
class ManageContentScreen extends StatelessWidget {
  const ManageContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dhibiti Maudhui (Manage Content)")),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _buildItemTile(context, "Manhaj Assalikin - Darsa 01", "Darsa • Fiqh", "Sheikh Abuul Fadhl"),
          _buildItemTile(context, "Bulugh al-Maram - Kitab al-Taharah", "Darsa • Fiqh", "Sheikh Abuul Fadhl"),
          _buildItemTile(context, "Khutbah ya Ijumaa", "Khutbah", "Sheikh Abuul Fadhl"),
        ],
      ),
    );
  }

  Widget _buildItemTile(BuildContext context, String title, String category, String scholar) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$category • $scholar"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Hariri '$title'")),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Maudhui ya '$title' yamefutwa!")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== ADMIN LOGIN SCREEN ====================
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _loginAdmin() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email == "admin@nurudawah.org" && password == "admin123") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email au Password si sahihi! Jaribu tena."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Portal")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(Icons.admin_panel_settings_rounded, size: 70, color: theme.colorScheme.primary),
                  const SizedBox(height: 10),
                  const Text(
                    "Ingia kama Admin",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text("Ingiza taarifa zako ili kudhibiti maudhui", style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email ya Admin",
                hintText: "admin@nurudawah.org",
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _loginAdmin,
                icon: const Icon(Icons.login_rounded),
                label: const Text("Ingia (Login)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== UPLOAD PDF SCREEN ====================
class UploadPdfScreen extends StatefulWidget {
  const UploadPdfScreen({super.key});

  @override
  State<UploadPdfScreen> createState() => _UploadPdfScreenState();
}

class _UploadPdfScreenState extends State<UploadPdfScreen> {
  final _bookTitleController = TextEditingController();
  final _authorController = TextEditingController();
  final _pdfUrlController = TextEditingController();

  void _submitPdf() {
    if (_bookTitleController.text.isEmpty || _authorController.text.isEmpty || _pdfUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tafadhali jaza taarifa zote za Kitabu!")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Kitabu cha '${_bookTitleController.text}' kimepakiliwa kikamilifu!"),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Pakia Kitabu Cha PDF / DOCX")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Taarifa za Kitabu (E-Book):", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            TextField(
              controller: _bookTitleController,
              decoration: InputDecoration(
                labelText: "Jina la Kitabu",
                hintText: "mf. Bulugh al-Maram",
                prefixIcon: const Icon(Icons.menu_book_rounded),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: "Mwandishi / Sheikh",
                hintText: "mf. Al-Hafidh Ibn Hajar",
                prefixIcon: const Icon(Icons.edit_note_rounded),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _pdfUrlController,
              decoration: InputDecoration(
                labelText: "Link ya PDF / DOCX (URL / File Link)",
                hintText: "https://example.com/book.pdf",
                prefixIcon: const Icon(Icons.picture_as_pdf_rounded),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _submitPdf,
                icon: const Icon(Icons.picture_as_pdf_rounded),
                label: const Text("Pakia Kitabu", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== E-BOOKS (VITABU / PDF / WORDS) ====================
class EbooksListScreen extends StatefulWidget {
  const EbooksListScreen({super.key});

  @override
  State<EbooksListScreen> createState() => _EbooksListScreenState();
}

class _EbooksListScreenState extends State<EbooksListScreen> {
  String bookSearch = "";

  final List<Map<String, String>> ebooks = const [
    {
      "title": "Bulugh al-Maram (Fiqh)",
      "author": "Al-Hafidh Ibn Hajar Al-Asqalani",
      "pages": "340 Pages",
      "fileType": "PDF",
      "size": "4.2 MB",
      "content": "Sura ya 1: Kitabu cha Twahara (Usafi)..."
    },
    {
      "title": "Kitab At-Tawheed",
      "author": "Sheikh Muhammad bin Abdil-Wahhab",
      "pages": "120 Pages",
      "fileType": "DOCX",
      "size": "1.8 MB",
      "content": "Mlango wa 1: Fadhila za Tawhiyd..."
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredBooks = ebooks.where((book) {
      final q = bookSearch.toLowerCase();
      return book["title"]!.toLowerCase().contains(q) ||
          book["author"]!.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Maktaba ya Vitabu (E-Books)")),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            TextField(
              onChanged: (val) => setState(() => bookSearch = val),
              decoration: InputDecoration(
                hintText: "Tafuta kitabu au mwandishi...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = filteredBooks[index];
                  final isPdf = book["fileType"] == "PDF";

                  return Card(
                    color: theme.colorScheme.surface,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isPdf ? Colors.red.withOpacity(0.15) : Colors.blue.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isPdf ? Icons.picture_as_pdf_rounded : Icons.description_rounded,
                              color: isPdf ? Colors.redAccent : Colors.blue,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(book["title"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(height: 4),
                                Text(book["author"]!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.menu_book_rounded),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookReaderScreen(
                                    title: book["title"]!,
                                    author: book["author"]!,
                                    content: book["content"]!,
                                    fileType: book["fileType"]!,
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// BOOK READER SCREEN
class BookReaderScreen extends StatefulWidget {
  final String title;
  final String author;
  final String content;
  final String fileType;

  const BookReaderScreen({super.key, required this.title, required this.author, required this.content, required this.fileType});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  double _fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Inapakua ${widget.title}..."), backgroundColor: Colors.green),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Text(widget.content, style: TextStyle(fontSize: _fontSize, height: 1.6)),
      ),
    );
  }
}

// Q&A SEARCH
class QnaSearchScreen extends StatelessWidget {
  const QnaSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Maswali & Majibu (Fatawa)")),
      body: const Center(child: Text("Orodha ya Fatawa")),
    );
  }
}

// SETTINGS
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mpangilio")),
      body: ListTile(
        leading: const Icon(Icons.admin_panel_settings_outlined),
        title: const Text("Admin Portal"),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminLoginScreen()));
        },
      ),
    );
  }
}

// DARSA SUBCATEGORIES
class DarsaSubCategoriesScreen extends StatelessWidget {
  const DarsaSubCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Makundi ya Darsa")),
      body: const Center(child: Text("Fiqh, Tawhiyd, Tafseer n.k.")),
    );
  }
}

// CONTENT ITEMS LIST
class ContentItemsListScreen extends StatelessWidget {
  final String categoryTitle;
  const ContentItemsListScreen({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryTitle)),
      body: Center(child: Text("Orodha ya $categoryTitle")),
    );
  }
}

// AUDIO PLAYER SCREEN
class AudioPlayerScreen extends StatefulWidget {
  final String title;
  final String audioUrl;

  const AudioPlayerScreen({super.key, required this.title, required this.audioUrl});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, size: 80, color: theme.colorScheme.primary),
            const SizedBox(height: 20),
            Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

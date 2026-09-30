import 'package:flutter/material.dart';

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
    const DarsaSubCategoriesScreen(),
    const EbooksListScreen(),
    const QnaSearchScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.auto_stories_rounded), label: 'Darsa'),
          BottomNavigationBarItem(icon: Icon(Icons.picture_as_pdf_rounded), label: 'Vitabu (PDF)'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz_rounded), label: 'Fatawa'),
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

  final List<Map<String, dynamic>> banners = const [
    {
      "title": "Dawra ya Fiqh na Ahkaam",
      "subtitle": "Inaanza Alhamisi Hii • Sheikh Abuul Fadhl",
      "color": Color(0xFF0284C7),
      "icon": Icons.event_available_rounded
    },
    {
      "title": "Mhadhara Mkuu wa Mwaka",
      "subtitle": "Ukumbi wa Nuru • Ijumaa Hii",
      "color": Color(0xFF7C3AED),
      "icon": Icons.campaign_rounded
    },
  ];

  final List<Map<String, dynamic>> mainCategories = const [
    {"title": "Maswali na Majibu (Fatawa)", "count": "850+", "icon": Icons.quiz_rounded, "color": Color(0xFFEC4899)},
    {"title": "Darsa", "count": "12,772", "icon": Icons.auto_stories, "color": Color(0xFFFFB300)},
    {"title": "Kalima", "count": "5,219", "icon": Icons.record_voice_over, "color": Color(0xFF0284C7)},
    {"title": "Khutbah", "count": "4,267", "icon": Icons.campaign, "color": Color(0xFFF97316)},
    {"title": "Mihadhara", "count": "214", "icon": Icons.groups, "color": Color(0xFFA855F7)},
    {"title": "Vitabu (PDF)", "count": "92", "icon": Icons.picture_as_pdf, "color": Color(0xFFEF4444)},
    {"title": "Dawrah / Nad-wah", "count": "1,291", "icon": Icons.school, "color": Color(0xFF14B8A6)},
    {"title": "Ruduud", "count": "1,122", "icon": Icons.gavel, "color": Color(0xFFEAB308)},
    {"title": "Minaaqashah", "count": "350", "icon": Icons.forum, "color": Color(0xFF6366F1)},
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
        title: const Text("Nuru Dawah", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => NuruDawahApp.of(context).toggleTheme(),
          ),
          IconButton(
            icon: Icon(Icons.admin_panel_settings_rounded, color: theme.colorScheme.primary),
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
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. BANNER SLIDER (MOVABLE / STAGNANT BANNER)
            SizedBox(
              height: 120,
              child: PageView.builder(
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  final b = banners[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: b["color"],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("TANGAZO / DAWRA", style: const TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(b["title"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 4),
                              Text(b["subtitle"], style: const TextStyle(fontSize: 11, color: Colors.white70)),
                            ],
                          ),
                        ),
                        Icon(b["icon"], size: 48, color: Colors.white38),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // SEARCH BAR
            TextField(
              onChanged: (val) => setState(() => searchQuery = val.toLowerCase()),
              decoration: InputDecoration(
                hintText: "Tafuta Category, Darsa au Somo...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),

            const Text("Makundi Makuu (Categories)", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // 2. GRID VIEW FOR CATEGORIES (BADALA YA LIST)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.3,
              ),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final cat = filteredCategories[index];
                return Card(
                  color: theme.colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      if (cat["title"] == "Maswali na Majibu (Fatawa)") {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const QnaSearchScreen()));
                      } else if (cat["title"] == "Vitabu (PDF)") {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EbooksListScreen()));
                      } else if (cat["title"] == "Darsa") {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DarsaSubCategoriesScreen()));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ContentItemsListScreen(categoryTitle: cat["title"])));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: (cat["color"] as Color).withOpacity(0.15),
                            radius: 22,
                            child: Icon(cat["icon"], color: cat["color"], size: 24),
                          ),
                          const SizedBox(height: 8),
                          Text(cat["title"], textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text("(${cat['count']})", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== DARSA SUB-CATEGORIES SCREEN ====================
class DarsaSubCategoriesScreen extends StatelessWidget {
  const DarsaSubCategoriesScreen({super.key});

  final List<Map<String, dynamic>> darsaSubjects = const [
    {"title": "Fiqh", "desc": "Ahkaam na Hukumu za Dini", "icon": Icons.balance_rounded, "color": Colors.orange},
    {"title": "Tawhiyd", "desc": "Imani na Itikadi Sahihi", "icon": Icons.wb_sunny_rounded, "color": Colors.blue},
    {"title": "Tafseer", "desc": "Maana na Maelezo ya Qor'ani", "icon": Icons.menu_book_rounded, "color": Colors.green},
    {"title": "Hadith", "desc": "Maneno na Mwenendo wa Mtume (S.A.W)", "icon": Icons.format_quote_rounded, "color": Colors.purple},
    {"title": "Seerah", "desc": "Taarehe na Mwenendo wa Mtume", "icon": Icons.history_edu_rounded, "color": Colors.teal},
    {"title": "Akhlaq", "desc": "Tabia na Maadili Mema ya Kiislamu", "icon": Icons.favorite_rounded, "color": Colors.pink},
    {"title": "Adhkaar", "desc": "Nyiradi na Dua mbalimbali", "icon": Icons.self_improvement_rounded, "color": Colors.amber},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Makundi ya Darsa")),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: darsaSubjects.length,
        itemBuilder: (context, index) {
          final sub = darsaSubjects[index];
          return Card(
            color: theme.colorScheme.surface,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: (sub["color"] as Color).withOpacity(0.15),
                child: Icon(sub["icon"], color: sub["color"]),
              ),
              title: Text(sub["title"], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(sub["desc"], style: const TextStyle(fontSize: 12)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContentItemsListScreen(categoryTitle: "Darsa - ${sub['title']}")),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ==================== UPLOAD AUDIO SCREEN ====================
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
  String _selectedFileName = "";

  final List<String> _categories = ["Darsa", "Kalima", "Khutbah", "Mihadhara", "Dawrah / Nad-wah", "Ruduud", "Minaaqashah"];
  final List<String> _darsaSubjects = ["Fiqh", "Tawhiyd", "Tafseer", "Hadith", "Seerah", "Akhlaq", "Adhkaar"];

  void _pickAudioFile() {
    setState(() {
      _selectedFileName = "audio_somomo_01.mp3";
      _urlController.text = "https://nurudawah.org/uploads/$_selectedFileName";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Faili la Audio limechaguliwa kutoka simuni!"), backgroundColor: Colors.green),
    );
  }

  void _submitAudio() {
    if (_titleController.text.isEmpty || _urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Jaza Kichwa cha Audio na Faili/Link!")));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Audio imepakiwa kikamilifu!"), backgroundColor: Colors.green));
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
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(labelText: "Kundi Kuu", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            const SizedBox(height: 14),

            if (_selectedCategory == "Darsa") ...[
              DropdownButtonFormField<String>(
                value: _selectedDarsaSubject,
                decoration: InputDecoration(labelText: "Somo la Darsa (Location)", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                items: _darsaSubjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _selectedDarsaSubject = v!),
              ),
              const SizedBox(height: 14),
            ],

            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Kichwa cha Darsa / Audio", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _scholarController,
              decoration: InputDecoration(labelText: "Jina la Msomeshaji / Sheikh (Optional)", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 18),

            // FILE PICKER BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.surface, foregroundColor: theme.colorScheme.primary, side: BorderSide(color: theme.colorScheme.primary)),
                onPressed: _pickAudioFile,
                icon: const Icon(Icons.folder_open_rounded),
                label: Text(_selectedFileName.isEmpty ? "Chagua Faili la Audio Simuni/Kompyuta" : "Faili: $_selectedFileName"),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(labelText: "Au Weka Link ya Audio (Audio URL)", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)),
              onPressed: _submitAudio,
              child: const Text("Pakia / Hifadhi Audio", style: TextStyle(fontWeight: FontWeight.bold)),
            )
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
  String _selectedPdfFile = "";

  void _pickPdfFile() {
    setState(() {
      _selectedPdfFile = "kitabu_cha_tawheed.pdf";
      _pdfUrlController.text = "https://nurudawah.org/docs/$_selectedPdfFile";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Faili la PDF limechaguliwa kutoka simuni!"), backgroundColor: Colors.green),
    );
  }

  void _submitPdf() {
    if (_bookTitleController.text.isEmpty || _pdfUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Weka Jina la Kitabu na Faili/Link ya PDF!")));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kitabu kimepakiwa kikamilifu!"), backgroundColor: Colors.green));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Pakia Kitabu (PDF)")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _bookTitleController,
              decoration: InputDecoration(labelText: "Jina la Kitabu *", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(labelText: "Jina la Mtunzi (Hiari / Optional)", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 18),

            // FILE PICKER BUTTON FOR PDF
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.surface, foregroundColor: Colors.redAccent, side: const BorderSide(color: Colors.redAccent)),
                onPressed: _pickPdfFile,
                icon: const Icon(Icons.picture_as_pdf_rounded),
                label: Text(_selectedPdfFile.isEmpty ? "Chagua PDF Kutoka Simuni/Kompyuta" : "Faili: $_selectedPdfFile"),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _pdfUrlController,
              decoration: InputDecoration(labelText: "Au Weka Link ya PDF (URL)", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: _submitPdf,
              child: const Text("Pakia Kitabu", style: TextStyle(fontWeight: FontWeight.bold)),
            )
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
  final _customCategoryController = TextEditingController();

  String _category = "Swala";
  bool _isCustomCategory = false;

  final List<String> _categories = ["Swala", "Swaumu", "Zaka", "Hija", "Ndoa", "Biashara", "Nyingine (Andika Yako)"];

  void _saveFatwa() {
    if (_questionController.text.isEmpty || _answerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Jaza Swali na Jibu!")));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fatwa imehifadhiwa!"), backgroundColor: Colors.green));
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
              decoration: InputDecoration(labelText: "Kundi la Fatwa", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) {
                setState(() {
                  _category = v!;
                  _isCustomCategory = v == "Nyingine (Andika Yako)";
                });
              },
            ),
            if (_isCustomCategory) ...[
              const SizedBox(height: 10),
              TextField(
                controller: _customCategoryController,
                decoration: InputDecoration(labelText: "Andika Kundi Jipya la Fatwa", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ],
            const SizedBox(height: 14),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: "Swali", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _answerController,
              maxLines: 4,
              decoration: InputDecoration(labelText: "Jibu la Fatwa", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _scholarController,
              decoration: InputDecoration(labelText: "Sheikh / Mwanachuoni Aliyetoa Fatwa", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)),
              onPressed: _saveFatwa,
              child: const Text("Hifadhi Fatwa", style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
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
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainHomeScreen())),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
              child: const Row(
                children: [
                  Icon(Icons.verified_user_rounded, color: Colors.amber, size: 30),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Super Admin Portal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("Usimamizi wa Mfumo na Ruhusa", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.upload_file, color: Colors.blue),
              title: const Text("Pakia Audio Mpya"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadAudioScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
              title: const Text("Pakia Kitabu (PDF)"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadPdfScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.quiz, color: Colors.purple),
              title: const Text("Ongeza Fatwa"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFatwaScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings, color: Colors.teal),
              title: const Text("Dhibiti Ma-Admin / Ruhusa (Credentials)"),
              subtitle: const Text("Mpe mtu mwingine ruhusa ya kuendesha app"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageAdminsScreen())),
            ),
          ],
        ),
      ),
    );
  }
}

// MANAGE ADMINS / ROLES
class ManageAdminsScreen extends StatefulWidget {
  const ManageAdminsScreen({super.key});

  @override
  State<ManageAdminsScreen> createState() => _ManageAdminsScreenState();
}

class _ManageAdminsScreenState extends State<ManageAdminsScreen> {
  final _emailController = TextEditingController();
  String _role = "Limited Access (Upload Only)";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Dhibiti Ma-Admin")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email ya Admin Mpya", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: InputDecoration(labelText: "Kiwango cha Ruhusa (Limit)", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              items: const [
                DropdownMenuItem(value: "Full Access (Yote)", child: Text("Full Access (Ruhusa Yote)")),
                DropdownMenuItem(value: "Limited Access (Upload Only)", child: Text("Limited (Kupakia Tu)")),
              ],
              onChanged: (v) => setState(() => _role = v!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ruhusa imepatiwa kwa ${_emailController.text}"), backgroundColor: Colors.green));
                Navigator.pop(context);
              },
              child: const Text("Thibitisha Admin Mpya"),
            )
          ],
        ),
      ),
    );
  }
}

// OTHER SCREENS (VITABU / FATAWA / LOGIN)
class EbooksListScreen extends StatelessWidget {
  const EbooksListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vitabu (PDF)")),
      body: const Center(child: Text("Orodha ya Vitabu vya PDF")),
    );
  }
}

class QnaSearchScreen extends StatelessWidget {
  const QnaSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Maswali na Majibu (Fatawa)")),
      body: const Center(child: Text("Orodha ya Fatawa")),
    );
  }
}

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Portal")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboardScreen())),
          child: const Text("Ingia kama Admin"),
        ),
      ),
    );
  }
}

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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    const LiveRadioScreen(),
    const ArticlesPage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.article_rounded), label: 'Makala'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Mipangilio'),
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

  final List<Map<String, dynamic>> mostListened = const [
    {"title": "Manhaj Assalikin - Darsa 01", "scholar": "Sheikh Abuul Fadhl", "plays": "12.5k Listens"},
    {"title": "Bulugh al-Maram - Kitab al-Taharah", "scholar": "Sheikh Abuul Fadhl", "plays": "9.8k Listens"},
  ];

  final List<Map<String, dynamic>> mainCategories = const [
    {"title": "Maswali na Majibu (Fatawa)", "count": "850+", "icon": Icons.quiz_rounded, "color": Color(0xFFEC4899)},
    {"title": "Darsa", "count": "12,772", "icon": Icons.auto_stories, "color": Color(0xFFFFB300)},
    {"title": "Kalima", "count": "5,219", "icon": Icons.record_voice_over, "color": Color(0xFF0284C7)},
    {"title": "Khutbah", "count": "4,267", "icon": Icons.campaign, "color": Color(0xFFF97316)},
    {"title": "Mihadhara", "count": "214", "icon": Icons.groups, "color": Color(0xFFA855F7)},
    {"title": "Vitabu (PDF)", "count": "92", "icon": Icons.picture_as_pdf, "color": Color(0xFFEF4444)},
    {"title": "Short Clips", "count": "310", "icon": Icons.movie_rounded, "color": Color(0xFF10B981)},
    {"title": "Dawrah / Nad-wah", "count": "1,291", "icon": Icons.school, "color": Color(0xFF14B8A6)},
    {"title": "Ruduud", "count": "1,122", "icon": Icons.gavel, "color": Color(0xFFEAB308)},
    {"title": "Minaaqashah", "count": "350", "icon": Icons.forum, "color": Color(0xFF6366F1)},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredCategories = mainCategories.where((cat) {
      if (searchQuery.isEmpty) return true;
      final title = cat["title"].toString().toLowerCase();
      final queryWords = searchQuery.toLowerCase().split(' ');
      return queryWords.every((word) => title.contains(word));
    }).toList();

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
            SizedBox(
              height: 130,
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

            TextField(
              onChanged: (val) => setState(() => searchQuery = val.trim()),
              decoration: InputDecoration(
                hintText: "Tafuta Darsa, Somo, au Category...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),

            const Text("Zinazosikilizwa Zaidi", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mostListened.length,
                itemBuilder: (context, index) {
                  final item = mostListened[index];
                  return Container(
                    width: 250,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: theme.colorScheme.primary,
                          child: const Icon(Icons.play_arrow_rounded, color: Colors.black),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(item["title"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                              Text(item["scholar"]!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                              Text(item["plays"]!, style: TextStyle(fontSize: 10, color: theme.colorScheme.primary)),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            const Text("Makundi Makuu (Categories)", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

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

// ==================== MAKALA PAGE ====================
class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  final List<Map<String, String>> articles = const [
    {
      "title": "Fadhila za Kumuomba Mwenyezi Mungu Msamaha (Istighfar)",
      "author": "Sheikh Abuul Fadhl",
      "date": "01 Oktoba 2026",
      "content": "Hakika Istighfar ni katika mambo yenye kufungua milango ya kheri, kuleta amani rohoni na kufuta madhambi. Mtume (S.A.W) alikuwa akiomba msamaha zaidi ya mara mia moja kwa siku..."
    },
    {
      "title": "Adabu za Siku ya Ijumaa",
      "author": "Sheikh Abuul Fadhl",
      "date": "25 Septemba 2026",
      "content": "Katika siku ya Ijumaa kuna adabu na mambo yaliyosisitizwa kufanywa kama vile kukoga, kuvaa nguo safi, kujitia perfume na kusoma Surah Al-Kahf mapema..."
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Makala na Maandishi")),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final item = articles[index];
          return Card(
            color: theme.colorScheme.surface,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item["title"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text("${item['author']} • ${item['date']}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 10),
                  SelectableText(
                    item["content"]!,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: "${item['title']}\n\n${item['content']}"));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Makala imecopyiwa!"), backgroundColor: Colors.green),
                        );
                      },
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      label: const Text("Copy Makala"),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==================== LIVE RADIO ====================
class LiveRadioScreen extends StatelessWidget {
  const LiveRadioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Streams & Radio")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.radio_rounded, size: 80, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            const Text("Radio ya Nuru Dawah ipo Live", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Sikiliza matangazo ya moja kwa moja ya darsa na mawaidha", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ==================== ADMIN LOGIN ====================
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  void _login() {
    if (_emailController.text == "admin@nurudawah.org" && _passwordController.text == "123456") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email au Password si sahihi! (admin@nurudawah.org / 123456)"), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Portal Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_person_rounded, size: 70, color: Colors.amber),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Barua Pepe (Email)", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                labelText: "Neno la Siri (Password)",
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: Icon(_showPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                  onPressed: () => setState(() => _showPassword = !_showPassword),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)),
              onPressed: _login,
              child: const Text("INGIA KAMA ADMIN", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
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
              leading: const Icon(Icons.view_carousel_rounded, color: Colors.orange),
              title: const Text("Dhibiti Matangazo (Banners)"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageBannersScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever_rounded, color: Colors.red),
              title: const Text("Dhibiti / Futa Content (Delete Items)"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DeleteContentScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings, color: Colors.teal),
              title: const Text("Dhibiti Ma-Admin / Ruhusa (Credentials)"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageAdminsScreen())),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== UPLOAD AUDIO ====================
class UploadAudioScreen extends StatefulWidget {
  const UploadAudioScreen({super.key});

  @override
  State<UploadAudioScreen> createState() => _UploadAudioScreenState();
}

class _UploadAudioScreenState extends State<UploadAudioScreen> {
  final _titleController = TextEditingController();
  final _scholarController = TextEditingController();
  final _filePathController = TextEditingController();
  String _selectedCategory = "Darsa";
  String _selectedDarsaSubject = "Fiqh";

  final List<String> _categories = ["Darsa", "Kalima", "Khutbah", "Mihadhara", "Dawrah / Nad-wah", "Ruduud", "Minaaqashah"];
  final List<String> _darsaSubjects = ["Fiqh", "Ahkaam", "Tawhiyd", "Tajweed", "Tafseer", "Hadith", "Seerah", "Manhaj", "Usuul", "Akhlaq", "Adhkaar", "Lugha"];

  void _submitAudio() {
    if (_titleController.text.isEmpty || _filePathController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Jaza Kichwa cha Audio na Path/URL ya Faili!")));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Audio '${_titleController.text}' imepakiwa kikamilifu!"), backgroundColor: Colors.green));
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
                decoration: InputDecoration(labelText: "Somo la Darsa", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                items: _darsaSubjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _selectedDarsaSubject = v!),
              ),
              const SizedBox(height: 14),
            ],

            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Kichwa cha Darsa / Audio *", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _scholarController,
              decoration: InputDecoration(labelText: "Jina la Msomeshaji / Sheikh (Hiari)", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _filePathController,
              decoration: InputDecoration(
                labelText: "Path ya Faili au Link (URL) *",
                hintText: "/Download/audio.mp3 au https://...",
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)),
              onPressed: _submitAudio,
              child: const Text("PAKIA AUDIO MPYA", style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

// ==================== UPLOAD PDF ====================
class UploadPdfScreen extends StatefulWidget {
  const UploadPdfScreen({super.key});

  @override
  State<UploadPdfScreen> createState() => _UploadPdfScreenState();
}

class _UploadPdfScreenState extends State<UploadPdfScreen> {
  final _bookTitleController = TextEditingController();
  final _authorController = TextEditingController();
  final _pdfPathController = TextEditingController();

  void _submitPdf() {
    if (_bookTitleController.text.isEmpty || _pdfPathController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Jaza Jina la Kitabu na Path/URL ya PDF!")));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kitabu '${_bookTitleController.text}' kimepakiwa!"), backgroundColor: Colors.green));
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
              decoration: InputDecoration(labelText: "Jina la Mtunzi (Hiari)", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _pdfPathController,
              decoration: InputDecoration(
                labelText: "Path ya PDF au Link (URL) *",
                hintText: "/Download/kitabu.pdf au https://...",
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: _submitPdf,
              child: const Text("PAKIA KITABU", style: TextStyle(fontWeight: FontWeight.bold)),
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

  void _saveFatwa() {
    if (_questionController.text.isEmpty || _answerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Jaza Swali na Jibu la Fatwa!")));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fatwa imehifadhiwa kikamilifu!"), backgroundColor: Colors.green));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Ongeza Fatwa Mpya")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: "Swali la Fatwa *", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _answerController,
              maxLines: 5,
              decoration: InputDecoration(labelText: "Jibu la Fatwa *", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _scholarController,
              decoration: InputDecoration(labelText: "Sheikh / Mwanachuoni Aliyetoa Fatwa", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)),
              onPressed: _saveFatwa,
              child: const Text("HIFADHI FATWA", style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

// ==================== MANAGE BANNERS SCREEN ====================
class ManageBannersScreen extends StatefulWidget {
  const ManageBannersScreen({super.key});

  @override
  State<ManageBannersScreen> createState() => _ManageBannersScreenState();
}

class _ManageBannersScreenState extends State<ManageBannersScreen> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _imagePathController = TextEditingController();

  void _saveBanner() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Jaza Kichwa cha Tangazo!")));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tangazo limehifadhiwa!"), backgroundColor: Colors.green));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext themeContext) {
    final theme = Theme.of(themeContext);
    return Scaffold(
      appBar: AppBar(title: const Text("Dhibiti Matangazo (Banners)")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Kichwa cha Tangazo *", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _subtitleController,
              decoration: InputDecoration(labelText: "Maelezo Mafupi", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _imagePathController,
              decoration: InputDecoration(labelText: "Path ya Picha au URL ya Tangazo", filled: true, fillColor: theme.colorScheme.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50)),
              onPressed: _saveBanner,
              child: const Text("HIFADHI TANGAZO", style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

// ==================== DELETE CONTENT SCREEN ====================
class DeleteContentScreen extends StatelessWidget {
  const DeleteContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Dhibiti / Futa Content")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: theme.colorScheme.surface,
            child: ListTile(
              title: const Text("Darsa: Manhaj Assalikin - Somo 01"),
              subtitle: const Text("Sheikh Abuul Fadhl"),
              trailing: IconButton(
                icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Somo limefutwa!"), backgroundColor: Colors.redAccent));
                },
              ),
            ),
          ),
          Card(
            color: theme.colorScheme.surface,
            child: ListTile(
              title: const Text("Kitabu: Usul al-Thalatha (PDF)"),
              subtitle: const Text("Kitabu cha Tawheed"),
              trailing: IconButton(
                icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kitabu kimefutwa!"), backgroundColor: Colors.redAccent));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== MANAGE ADMINS SCREEN ====================
class ManageAdminsScreen extends StatefulWidget {
  const ManageAdminsScreen({super.key});

  @override
  State<ManageAdminsScreen> createState() => _ManageAdminsScreenState();
}

class _ManageAdminsScreenState extends State<ManageAdminsScreen> {
  final _emailController = TextEditingController();
  String _selectedLimit = "Limited (Kupakia Tu)";

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
              decoration: InputDecoration(
                labelText: "Email ya Admin Mpya",
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _selectedLimit,
              decoration: InputDecoration(
                labelText: "Kiwango cha Ruhusa (Limit)",
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: const [
                DropdownMenuItem(value: "Limited (Kupakia Tu)", child: Text("Limited (Kupakia Tu)")),
                DropdownMenuItem(value: "Super Admin (Ruhusa Yote)", child: Text("Super Admin (Ruhusa Yote)")),
              ],
              onChanged: (v) => setState(() => _selectedLimit = v!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                if (_emailController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Admin '${_emailController.text}' ameongezwa!"), backgroundColor: Colors.green),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("THIBITISHA ADMIN MPYA", style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

// ==================== DARSA SUBCATEGORIES ====================
class DarsaSubCategoriesScreen extends StatelessWidget {
  const DarsaSubCategoriesScreen({super.key});

  final List<Map<String, dynamic>> darsaSubjects = const [
    {"title": "Fiqh", "desc": "Ahkaam na Hukumu za Dini", "icon": Icons.balance_rounded, "color": Colors.orange},
    {"title": "Ahkaam", "desc": "Sheria na Mambo Yaliyohalalishwa/Yaliyoharamishwa", "icon": Icons.gavel_rounded, "color": Colors.deepOrange},
    {"title": "Tawhiyd", "desc": "Imani na Itikadi Sahihi", "icon": Icons.wb_sunny_rounded, "color": Colors.blue},
    {"title": "Tajweed", "desc": "Kanuni za Usomaji wa Qor'ani", "icon": Icons.record_voice_over_rounded, "color": Colors.cyan},
    {"title": "Tafseer", "desc": "Maana na Maelezo ya Qor'ani", "icon": Icons.menu_book_rounded, "color": Colors.green},
    {"title": "Hadith", "desc": "Maneno na Mwenendo wa Mtume (S.A.W)", "icon": Icons.format_quote_rounded, "color": Colors.purple},
    {"title": "Seerah", "desc": "Taarehe na Mwenendo wa Mtume", "icon": Icons.history_edu_rounded, "color": Colors.teal},
    {"title": "Manhaj", "desc": "Njia na Mfumo Sahihi wa Dini", "icon": Icons.alt_route_rounded, "color": Colors.indigo},
    {"title": "Usuul", "desc": "Misingi ya Elimu ya Dini", "icon": Icons.account_tree_rounded, "color": Colors.brown},
    {"title": "Akhlaq", "desc": "Tabia na Maadili Mema ya Kiislamu", "icon": Icons.favorite_rounded, "color": Colors.pink},
    {"title": "Adhkaar", "desc": "Nyiradi na Dua mbalimbali", "icon": Icons.self_improvement_rounded, "color": Colors.amber},
    {"title": "Lugha", "desc": "Lugha ya Kiarabu na Nahawu", "icon": Icons.translate_rounded, "color": Colors.blueGrey},
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

// ==================== SETTINGS SCREEN ====================
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Mipangilio (Settings)")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.color_lens_rounded),
            title: const Text("Muonekano (Dark / Light Mode)"),
            trailing: Switch(
              value: isDark,
              onChanged: (val) => NuruDawahApp.of(context).toggleTheme(),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text("Kuhusu Nuru Dawah"),
            subtitle: const Text("Toleo la 1.0.1"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings_rounded, color: Colors.amber),
            title: const Text("Ingia Admin Portal"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminLoginScreen())),
          ),
        ],
      ),
    );
  }
}

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

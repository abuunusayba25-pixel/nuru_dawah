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

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

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
    const Center(child: Text("Vitabu / E-Books")),
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
            tooltip: "Badili Mode (Light/Dark)",
            onPressed: () {
              NuruDawahApp.of(context).toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.bookmark, color: theme.colorScheme.primary),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BANNER YA NYUMBANI NA LOGO
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
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

              // SEARCH BAR
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

              // MOST LISTENED SECTION
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

              // CATEGORIES MAIN LIST
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

// ==================== MASWALI NA MAJIBU (Q&A / FATAWA SEARCH) ====================
class QnaSearchScreen extends StatefulWidget {
  const QnaSearchScreen({super.key});

  @override
  State<QnaSearchScreen> createState() => _QnaSearchScreenState();
}

class _QnaSearchScreenState extends State<QnaSearchScreen> {
  String qnaQuery = "";

  final List<Map<String, String>> qnaList = const [
    {
      "question": "Je, ni ipi hukumu ya kusahau Rukuu kwenye Swala?",
      "answer": "Mtu akisahau Rukuu na akakumbuka kabla ya kusimama kwenye rakaa inayofuata, inabidi arudi kufanya Rukuu kisha aendelee na swala yake na mwisho afanye Sujudu al-Sahuw.",
      "scholar": "Sheikh Abuul Fadhl",
      "category": "Swala",
    },
    {
      "question": "Ni ipi hukumu ya kupiga mswaki au dawa ya meno ukiwa umefunga?",
      "answer": "Inajuzu kupiga mswaki au kutumia dawa ya meno ukiwa umefunga ilimradi tu usimeze kitu koo. Ikiwa kitu kitaingia kooni kwa bahati mbaya bila kukusudia, swaumu haiharibiki.",
      "scholar": "Sheikh Abuul Fadhl",
      "category": "Swaumu",
    },
    {
      "question": "Ni zipi sharti za Wudhuu kusihi?",
      "answer": "Sharti za wudhuu ni pamoja na Niyyah, kutumia maji twahara, kuondoa kinachozuia maji kufika kwenye ngozi, na kufuatisha viungo kulingana na muundo uliowekwa.",
      "scholar": "Sheikh Abuul Fadhl",
      "category": "Twahara",
    },
    {
      "question": "Je, inajuzu kutoa Zakat al-Fitr kwa fedha badala ya chakula?",
      "answer": "Sunnah iliyothibiti ni kutoa Zakat al-Fitr ikiwa ni chakula kinacholiwa zaidi katika mji (kama mchele, ngano, au tende). Wanazuoni wengi wamesisitiza kutoa chakula badala ya fedha.",
      "scholar": "Sheikh Abuul Fadhl",
      "category": "Zaka",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredQna = qnaList.where((q) {
      final query = qnaQuery.toLowerCase();
      return q["question"]!.toLowerCase().contains(query) ||
          q["answer"]!.toLowerCase().contains(query) ||
          q["category"]!.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Maswali & Majibu (Fatawa)"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            // SEARCH INPUT FOR HUKUMU
            TextField(
              onChanged: (val) {
                setState(() {
                  qnaQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: "Tafuta hukumu (mf. swala, mswaki, wudhuu, zaka)...",
                prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                suffixIcon: qnaQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            qnaQuery = "";
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // RESULTS LIST
            Expanded(
              child: filteredQna.isEmpty
                  ? const Center(
                      child: Text(
                        "Hakuna hukumu iliyopatikana kulingana na utafutaji wako.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredQna.length,
                      itemBuilder: (context, index) {
                        final item = filteredQna[index];
                        return Card(
                          color: theme.colorScheme.surface,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.15)),
                          ),
                          child: ExpansionTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.help_outline_rounded, color: theme.colorScheme.primary, size: 20),
                            ),
                            title: Text(
                              item["question"]!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                "Kundi: ${item['category']} • Fatwa ya: ${item['scholar']}",
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(),
                                    const SizedBox(height: 6),
                                    const Text(
                                      "Jibu / Hukumu:",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item["answer"]!,
                                      style: const TextStyle(fontSize: 13, height: 1.4),
                                    ),
                                  ],
                                ),
                              )
                            ],
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

// ==================== SETTINGS (MPANGILIO) ====================
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool autoDownload = false;
  String selectedFontSize = "Kawaida (Medium)";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = NuruDawahApp.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mpangilio (Settings)"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // 1. APPEARANCE & THEME
          _buildSectionHeader("Muonekano (Appearance)", Icons.palette_outlined),
          Card(
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_6_rounded),
                  title: const Text("Mandhari (Theme)"),
                  subtitle: Text(
                    appState.themeMode == ThemeMode.dark
                        ? "Dark Mode"
                        : appState.themeMode == ThemeMode.light
                            ? "Light Mode"
                            : "Mfumo wa Simu (System)",
                  ),
                  trailing: DropdownButton<ThemeMode>(
                    value: appState.themeMode,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text("Dark Mode"),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text("Light Mode"),
                      ),
                    ],
                    onChanged: (mode) {
                      if (mode != null) appState.setThemeMode(mode);
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.format_size_rounded),
                  title: const Text("Ukubwa wa Maandishi"),
                  subtitle: Text(selectedFontSize),
                  trailing: DropdownButton<String>(
                    value: selectedFontSize,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: "Ndogo (Small)", child: Text("Ndogo")),
                      DropdownMenuItem(value: "Kawaida (Medium)", child: Text("Kawaida")),
                      DropdownMenuItem(value: "Kubwa (Large)", child: Text("Kubwa")),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => selectedFontSize = val);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. DOWNLOADS & STORAGE
          _buildSectionHeader("Hifadhi na Downloads", Icons.download_outlined),
          Card(
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.downloading_rounded),
                  title: const Text("Auto-Download Darsa Mpya"),
                  subtitle: const Text("Pakua darsa mpya mara tu zinapowekwa"),
                  value: autoDownload,
                  activeColor: theme.colorScheme.primary,
                  onChanged: (val) {
                    setState(() {
                      autoDownload = val;
                    });
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.folder_delete_outlined),
                  title: const Text("Safisha Cache (Clear Cache)"),
                  subtitle: const Text("Ondoa mafayili ya muda yasiyohitajika"),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Cache imesafishwa kikamilifu!"),
                        backgroundColor: theme.colorScheme.primary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. NOTIFICATIONS
          _buildSectionHeader("Taarifa (Notifications)", Icons.notifications_none_rounded),
          Card(
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications_active_outlined),
              title: const Text("Pokea Taarifa"),
              subtitle: const Text("Taarifa za darsa mpya na live streams"),
              value: notificationsEnabled,
              activeColor: theme.colorScheme.primary,
              onChanged: (val) {
                setState(() {
                  notificationsEnabled = val;
                });
              },
            ),
          ),
          const SizedBox(height: 20),

          // 4. ABOUT & SUPPORT
          _buildSectionHeader("Kuhusu & Msaada", Icons.info_outline_rounded),
          Card(
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.favorite_outline_rounded, color: Colors.redAccent),
                  title: const Text("Changia Dawah (Support Us)"),
                  subtitle: const Text("Kusaidia kuendesha na kuendeleza mradi"),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.share_rounded),
                  title: const Text("Share App"),
                  subtitle: const Text("Washirikishe wengine wapate faida"),
                  onTap: () {},
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.vibration_rounded),
                  title: Text("Toleo la App (App Version)"),
                  subtitle: Text("v1.0.2 (Build 18)"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// SUB-CATEGORIES SKRINI
class DarsaSubCategoriesScreen extends StatelessWidget {
  const DarsaSubCategoriesScreen({super.key});

  final List<Map<String, dynamic>> darsaSubjects = const [
    {"title": "Fiqh", "icon": Icons.auto_stories, "color": Color(0xFFFFB300)},
    {"title": "Tawhiyd", "icon": Icons.account_balance, "color": Color(0xFF0284C7)},
    {"title": "Tafseer", "icon": Icons.menu_book, "color": Color(0xFFF97316)},
    {"title": "Hadith", "icon": Icons.record_voice_over, "color": Color(0xFFA855F7)},
    {"title": "Sira", "icon": Icons.history_edu, "color": Color(0xFFEAB308)},
    {"title": "Usuul", "icon": Icons.account_tree, "color": Color(0xFF14B8A6)},
    {"title": "Lugha", "icon": Icons.translate, "color": Color(0xFF06B6D4)},
    {"title": "Ahkaam Tajweed", "icon": Icons.record_voice_over, "color": Color(0xFF84CC16)},
    {"title": "Manhaj", "icon": Icons.explore, "color": Color(0xFFF97316)},
    {"title": "Mustalahul Hadith", "icon": Icons.find_in_page, "color": Color(0xFF6366F1)},
    {"title": "Darsa za Wanawake", "icon": Icons.female, "color": Color(0xFFEC4899)},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            childAspectRatio: 1.25,
          ),
          itemBuilder: (context, index) {
            final cat = darsaSubjects[index];
            return Card(
              color: theme.colorScheme.surface,
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
                    Icon(cat["icon"], size: 32, color: cat["color"]),
                    const SizedBox(height: 8),
                    Text(
                      cat["title"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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

// LIST YA VITABU / CONTENT
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
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(categoryTitle)),
      body: ListView.builder(
        itemCount: sampleItems.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final item = sampleItems[index];
          return Card(
            color: theme.colorScheme.surface,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                child: Icon(Icons.folder, color: theme.colorScheme.primary),
              ),
              title: Text(
                item["book"]!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "Msomeshaji: ${item['scholar']}\n${item['description']}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: theme.colorScheme.primary, size: 16),
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

// LIST YA AUDIO ZA DARSA YENYE KUCHAGUA NYINGI
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

  final Set<String> selectedLessonIds = {};
  bool isMultiSelectMode = false;

  void toggleSelection(String id) {
    setState(() {
      if (selectedLessonIds.contains(id)) {
        selectedLessonIds.remove(id);
        if (selectedLessonIds.isEmpty) {
          isMultiSelectMode = false;
        }
      } else {
        selectedLessonIds.add(id);
      }
    });
  }

  void downloadSelectedAudios() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Inapakua audio ${selectedLessonIds.length} zilizoteuliwa..."),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
    setState(() {
      selectedLessonIds.clear();
      isMultiSelectMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.bookName, style: const TextStyle(fontSize: 16)),
            Text(widget.scholarName, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          if (isMultiSelectMode)
            IconButton(
              icon: const Icon(Icons.download_rounded),
              tooltip: "Pakua Zilizochaguliwa",
              onPressed: downloadSelectedAudios,
            ),
          IconButton(
            icon: Icon(isMultiSelectMode ? Icons.close : Icons.checklist_rtl_rounded),
            tooltip: "Chagua Nyingi (Multi-Select)",
            onPressed: () {
              setState(() {
                isMultiSelectMode = !isMultiSelectMode;
                if (!isMultiSelectMode) selectedLessonIds.clear();
              });
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: lessons.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          final lessonId = lesson["id"]!;
          final isSelected = selectedLessonIds.contains(lessonId);

          return Card(
            color: theme.colorScheme.surface,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: isSelected
                  ? BorderSide(color: theme.colorScheme.primary, width: 2)
                  : BorderSide.none,
            ),
            child: ListTile(
              leading: isMultiSelectMode
                  ? Checkbox(
                      value: isSelected,
                      activeColor: theme.colorScheme.primary,
                      onChanged: (val) => toggleSelection(lessonId),
                    )
                  : CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                      child: Icon(Icons.play_arrow_rounded, color: theme.colorScheme.primary),
                    ),
              title: Text(
                lesson["title"]!,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text("Bonyeza kusikiliza", style: TextStyle(fontSize: 12, color: Colors.grey)),
              onLongPress: () {
                setState(() {
                  isMultiSelectMode = true;
                  toggleSelection(lessonId);
                });
              },
              onTap: () {
                if (isMultiSelectMode) {
                  toggleSelection(lessonId);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AudioPlayerScreen(
                        title: lesson["title"]!,
                        audioUrl: lesson["url"]!,
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
      bottomNavigationBar: isMultiSelectMode && selectedLessonIds.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(14),
              color: theme.colorScheme.surface,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: downloadSelectedAudios,
                icon: const Icon(Icons.download_rounded),
                label: Text("Pakua Audio Zilizoteuliwa (${selectedLessonIds.length})"),
              ),
            )
          : null,
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note_rounded, size: 100, color: theme.colorScheme.primary),
            const SizedBox(height: 20),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              activeColor: theme.colorScheme.primary,
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
                  style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.surface),
                  child: Text("${playbackSpeed}x", style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                ),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: theme.colorScheme.primary,
                  child: IconButton(
                    iconSize: 38,
                    icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                    color: Colors.black,
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
                  icon: const Icon(Icons.bookmark_border_rounded),
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

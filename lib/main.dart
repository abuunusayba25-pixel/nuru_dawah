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
                      Text("Karibu katika Panel ya Usimamizi", style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                    subtitle: "Weka MP3 ya Darsa/Khutbah",
                    icon: Icons.upload_file_rounded,
                    color: Colors.blue,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Hatua inayofuata: Kuweka fomu ya kupakia Audio")),
                      );
                    },
                  ),
                  _buildAdminCard(
                    context,
                    title: "Pakia Kitabu (PDF)",
                    subtitle: "Ongeza E-book mpya",
                    icon: Icons.picture_as_pdf_rounded,
                    color: Colors.redAccent,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Hatua inayofuata: Kuweka fomu ya kupakia PDF")),
                      );
                    },
                  ),
                  _buildAdminCard(
                    context,
                    title: "Ongeza Fatwa",
                    subtitle: "Maswali na Majibu",
                    icon: Icons.quiz_rounded,
                    color: Colors.purple,
                    onTap: () {},
                  ),
                  _buildAdminCard(
                    context,
                    title: "Dhibiti Maudhui",
                    subtitle: "Futa au Badilisha Darsa",
                    icon: Icons.edit_note_rounded,
                    color: Colors.orange,
                    onTap: () {},
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
      appBar: AppBar(title: const Text("Maswali & Majibu (Fatawa)")),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            TextField(
              onChanged: (val) {
                setState(() {
                  qnaQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: "Tafuta hukumu (mf. swala, mswaki)...",
                prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredQna.length,
                itemBuilder: (context, index) {
                  final item = filteredQna[index];
                  return Card(
                    color: theme.colorScheme.surface,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      leading: Icon(Icons.help_outline_rounded, color: theme.colorScheme.primary),
                      title: Text(item["question"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Fatwa ya: ${item['scholar']}", style: const TextStyle(fontSize: 11)),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(item["answer"]!),
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = NuruDawahApp.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Mpangilio (Settings)")),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          ListTile(
            leading: const Icon(Icons.brightness_6_rounded),
            title: const Text("Mandhari (Theme)"),
            subtitle: Text(appState.themeMode == ThemeMode.dark ? "Dark Mode" : "Light Mode"),
            trailing: Switch(
              value: appState.themeMode == ThemeMode.dark,
              onChanged: (val) {
                appState.toggleTheme();
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings_outlined),
            title: const Text("Admin Portal"),
            subtitle: const Text("Ingia kama Admin wa mfumo"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
              );
            },
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
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Makundi ya Darsa")),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: darsaSubjects.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final cat = darsaSubjects[index];
          return Card(
            color: theme.colorScheme.surface,
            child: InkWell(
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
                  Text(cat["title"], style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// LIST YA VITABU / CONTENT
class ContentItemsListScreen extends StatelessWidget {
  final String categoryTitle;

  const ContentItemsListScreen({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(categoryTitle)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            color: theme.colorScheme.surface,
            child: ListTile(
              title: const Text("Manhaj Assalikin", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Sheikh Abuul Fadhl"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AudioLessonsListScreen(
                      bookName: "Manhaj Assalikin",
                      scholarName: "Sheikh Abuul Fadhl",
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

// LIST YA AUDIO
class AudioLessonsListScreen extends StatelessWidget {
  final String bookName;
  final String scholarName;

  const AudioLessonsListScreen({super.key, required this.bookName, required this.scholarName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bookName)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ListTile(
            leading: const Icon(Icons.play_circle_fill),
            title: const Text("Darsa 01 - Utulivu na Niyyah"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AudioPlayerScreen(
                    title: "Darsa 01 - Utulivu na Niyyah",
                    audioUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
                  ),
                ),
              );
            },
          )
        ],
      ),
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
            const SizedBox(height: 20),
            IconButton(
              iconSize: 64,
              icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
              color: theme.colorScheme.primary,
              onPressed: () async {
                if (isPlaying) {
                  await _audioPlayer.pause();
                } else {
                  await _audioPlayer.play(UrlSource(widget.audioUrl));
                }
                setState(() {
                  isPlaying = !isPlaying;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
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
    {"title": "Darsa", "count": 12772, "icon": Icons.folder_outlined},
    {"title": "Kalima", "count": 5219, "icon": Icons.folder_outlined},
    {"title": "Khutbah", "count": 4267, "icon": Icons.folder_outlined},
    {"title": "Mihadhara", "count": 214, "icon": Icons.folder_outlined},
    {"title": "E-books", "count": 92, "icon": Icons.folder_outlined},
    {"title": "Dawrah/Nad-wah", "count": 1291, "icon": Icons.folder_outlined},
    {"title": "Ruduud", "count": 1122, "icon": Icons.folder_outlined},
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
            leading: Icon(item["icon"], color: Colors.grey[400]),
            title: Text(
              item["title"],
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
              if (item["title"] == "Darsa") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DarsaSubCategoriesScreen(),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class DarsaSubCategoriesScreen extends StatelessWidget {
  const DarsaSubCategoriesScreen({super.key});

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
        title: const Text('Darsa Categories'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: darsaTopics.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              darsaTopics[index],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}

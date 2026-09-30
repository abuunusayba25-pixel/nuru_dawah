import 'package:flutter/material.dart';

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
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: darsaTopics.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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

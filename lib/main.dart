import 'package:flutter/material.dart';

import 'screens.dart';
import 'services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.instance.init(); // loads the offline library - no login needed
  runApp(const NuruApp());
}

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: kEmerald,
    brightness: Brightness.light,
  ).copyWith(
    primary: kEmerald,
    onPrimary: Colors.white,
    surface: Colors.white,
    onSurface: kSlate,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: kSlate,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kSlate),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      indicatorColor: kEmeraldSoft,
      height: 68,
      labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
            fontSize: 12.5,
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w800 : FontWeight.w600,
            color: states.contains(WidgetState.selected) ? kEmeraldDark : kSlateSoft,
          )),
      iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? kEmeraldDark : kSlateSoft,
          )),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: kSlate,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
  );
}

class NuruApp extends StatelessWidget {
  const NuruApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Nuru ya Da'wa",
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const Shell(),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps each tab's search text / scroll position.
      body: IndexedStack(
        index: _index,
        children: const [
          DarsaPage(),
          FatawaPage(),
          BooksPage(),
          DownloadsPage(),
        ],
      ),
      // Mini player sits directly above the navigation bar on every tab.
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(),
          NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.headphones_outlined),
                selectedIcon: Icon(Icons.headphones_rounded),
                label: 'Darsa',
              ),
              NavigationDestination(
                icon: Icon(Icons.question_answer_outlined),
                selectedIcon: Icon(Icons.question_answer_rounded),
                label: 'Fatawa',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book_rounded),
                label: 'Vitabu',
              ),
              NavigationDestination(
                icon: Icon(Icons.download_for_offline_outlined),
                selectedIcon: Icon(Icons.download_for_offline_rounded),
                label: 'Downloads',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

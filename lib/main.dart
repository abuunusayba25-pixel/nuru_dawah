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
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuru Dawah'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Karibu kwenye Nuru Dawah App!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

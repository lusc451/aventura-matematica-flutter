import 'package:flutter/material.dart';
import 'presentation/screens/home/home_screen.dart';

void main() {
  runApp(const AventuraMatematicaApp());
}

class AventuraMatematicaApp extends StatelessWidget {
  const AventuraMatematicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aventura Matemática',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const HomeScreen(),
    );
  }
}

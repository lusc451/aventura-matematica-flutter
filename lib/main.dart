import 'package:flutter/material.dart';
import 'package:aventura_matematica/presentation/screens/home/splash_screen.dart';

void main() {
  runApp(const AventuraMatematicaApp());
}

class AventuraMatematicaApp extends StatelessWidget {
  const AventuraMatematicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aventura Matemática',
      theme: ThemeData(
        primaryColor: const Color(0xFF311B92),
        scaffoldBackgroundColor: const Color(0xFF311B92),
        fontFamily: 'MedievalSharp',
      ),
      home: const SplashScreen(), // inicia pela splash
    );
  }
}

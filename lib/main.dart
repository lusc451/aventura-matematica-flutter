import 'package:flutter/material.dart';
import 'presentation/screens/home/splash_screen.dart';

void main() {
  runApp(const AventuraMatematica());
}

class AventuraMatematica extends StatelessWidget {
  const AventuraMatematica({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aventura Matemática',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

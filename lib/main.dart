import 'package:flutter/material.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/game/game_screen.dart';

void main() {
  runApp(const NumerosMagicosApp());
}

class NumerosMagicosApp extends StatelessWidget {
  const NumerosMagicosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Números Mágicos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/game': (context) => const GameScreen(),
      },
    );
  }
}

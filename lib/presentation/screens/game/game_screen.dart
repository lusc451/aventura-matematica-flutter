import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final String realmName;

  const GameScreen({super.key, required this.realmName});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String get operationType {
    switch (widget.realmName) {
      case 'Reino das Chamas':
        return 'Adição';
      case 'Reino das Sombras':
        return 'Subtração';
      case 'Reino do Gelo':
        return 'Multiplicação';
      case 'Reino dos Ventos':
        return 'Misto';
      default:
        return 'Operação Desconhecida';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4527A0),
      appBar: AppBar(
        title: Text(widget.realmName),
        backgroundColor: const Color(0xFF311B92),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              operationType,
              style: const TextStyle(
                fontSize: 26,
                color: Colors.amberAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Em breve, os desafios mágicos deste reino começarão!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

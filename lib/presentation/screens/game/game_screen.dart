import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final String realmName;

  const GameScreen({super.key, required this.realmName});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int a;
  late int b;
  late int result;
  late int answer;
  List<int> options = [];
  String feedbackMessage = '';

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    final rand = Random();
    a = rand.nextInt(9) + 1;
    b = rand.nextInt(9) + 1;
    result = a + b;

    answer = result;
    options = [answer];
    while (options.length < 3) {
      int opt = rand.nextInt(18) + 2;
      if (!options.contains(opt)) options.add(opt);
    }
    options.shuffle();

    feedbackMessage = '';
  }

  void _checkAnswer(int selected) {
    setState(() {
      if (selected == result) {
        feedbackMessage = '✨ Acertou!';
      } else {
        feedbackMessage = '❌ Tente novamente!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF311B92),
      appBar: AppBar(
        title: Text(widget.realmName),
        backgroundColor: const Color(0xFF4527A0),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$a + $b = ?',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 12,
              children: options
                  .map(
                    (opt) => ElevatedButton(
                      onPressed: () => _checkAnswer(opt),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                      child: Text(
                        opt.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 30),
            Text(
              feedbackMessage,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

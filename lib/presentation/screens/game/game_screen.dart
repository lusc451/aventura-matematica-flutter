import 'dart:math';
import 'package:flutter/material.dart';
import 'package:aventura_matematica/presentation/screens/game/SpellAnimation.dart';

import 'package:aventura_matematica/presentation/screens/game/wizard_idle_animation.dart';
import 'package:aventura_matematica/presentation/screens/game/wizard_attack_animation.dart';
import 'package:aventura_matematica/presentation/screens/game/wizard_hit_animation.dart';

enum WizardState { idle, attack, hit }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int a;
  late int result;
  late int answer;
  List<int> options = [];
  String feedbackMessage = '';
  WizardState wizardState = WizardState.idle;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    final rand = Random();
    a = rand.nextInt(9) + 1;
    answer = rand.nextInt(9) + 1;
    result = a + answer;

    options = [answer];
    while (options.length < 3) {
      int opt = rand.nextInt(9) + 1;
      if (!options.contains(opt)) options.add(opt);
    }
    options.shuffle();

    feedbackMessage = '';
  }

  void _checkAnswer(int selected) {
    setState(() {
      if (selected == answer) {
        feedbackMessage = '✨ Acertou! ✨';
        wizardState = WizardState.attack;
      } else {
        feedbackMessage = '💥 Errou! 💥';
        wizardState = WizardState.hit;
      }

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          wizardState = WizardState.idle;
          _generateQuestion();
        });
      });
    });
  }

  Widget _buildWizard() {
    switch (wizardState) {
      case WizardState.attack:
        return WizardAttackAnimation(
          size: 180,
          onComplete: () {
            setState(() => wizardState = WizardState.idle);
          },
        );

      case WizardState.hit:
        return WizardHitAnimation(
          size: 180,
          onComplete: () {
            setState(() => wizardState = WizardState.idle);
          },
        );

      default:
        return WizardIdleAnimation(size: 180);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/reino-fogo.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.35),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20),

                Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.redAccent,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.8),
                            blurRadius: 25,
                            spreadRadius: 5,
                          )
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Colors.red[900]!,
                            Colors.red[700]!,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '$a + ? = $result',
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                            blurRadius: 12,
                            color: Colors.black,
                          )
                        ],
                      ),
                    )
                  ],
                ),

                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: feedbackMessage.isEmpty ? 0 : 1,
                  child: Text(
                    feedbackMessage,
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: options.map((opt) {
                    return GestureDetector(
                      onTap: () => _checkAnswer(opt),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SpellAnimation(size: 110),
                          Text(
                            '$opt',
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildWizard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

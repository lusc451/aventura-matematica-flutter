import 'dart:math';
import 'package:flutter/material.dart';
import 'package:aventura_matematica/presentation/screens/home/realms_screen.dart';

import 'package:aventura_matematica/presentation/screens/game/SpellAnimation.dart';
import 'package:aventura_matematica/presentation/screens/game/wizard_idle_animation.dart';
import 'package:aventura_matematica/presentation/screens/game/wizard_attack_animation.dart';
import 'package:aventura_matematica/presentation/screens/game/wizard_hit_animation.dart';

enum WizardState { idle, attack, hit }

class GameScreen extends StatefulWidget {
  final Realm realm;

  const GameScreen({super.key, required this.realm});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // ➤ Vida
  int playerHp = 100;
  int enemyHp = 100;

  final int playerMaxHp = 100;
  final int enemyMaxHp = 100;

  // ➤ Matemática
  late int a;
  late int result;
  late int answer;
  List<int> options = [];
  String symbol = "+";

  // ➤ Estado do mago
  WizardState wizardState = WizardState.idle;
  String feedbackMessage = "";

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  // Escolhe símbolo com base no reino
  String _getOperationSymbol(MathOperation op) {
    switch (op) {
      case MathOperation.addition:
        return "+";
      case MathOperation.subtraction:
        return "-";
      case MathOperation.multiplication:
        return "×";
      case MathOperation.mix:
        return ["+", "-", "×"][Random().nextInt(3)];
    }
  }

  // Gera a pergunta
  void _generateQuestion() {
    final rand = Random();

    a = rand.nextInt(9) + 1;
    answer = rand.nextInt(9) + 1;

    symbol = _getOperationSymbol(widget.realm.operation);

    switch (symbol) {
      case "+":
        result = a + answer;
        break;
      case "-":
        result = a - answer;
        break;
      case "×":
        result = a * answer;
        break;
    }

    options = [answer];
    while (options.length < 3) {
      int opt = rand.nextInt(9) + 1;
      if (!options.contains(opt)) options.add(opt);
    }
    options.shuffle();

    feedbackMessage = "";
  }

  // ➤ Barras de vida
  Widget _buildHpBar(int current, int max, Color color) {
    double pct = current / max;

    return Container(
      width: 180,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 180 * pct,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Center(
            child: Text(
              "$current / $max",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  // ➤ Dano
  void _dealDamageToEnemy(int dmg) {
    setState(() {
      enemyHp -= dmg;
      if (enemyHp < 0) enemyHp = 0;
    });
  }

  void _dealDamageToPlayer(int dmg) {
    setState(() {
      playerHp -= dmg;
      if (playerHp < 0) playerHp = 0;
    });
  }

  // ➤ Checar resposta
  void _checkAnswer(int selected) {
    final acerto = selected == answer;

    setState(() {
      if (acerto) {
        feedbackMessage = "✨ Acertou! ✨";
        wizardState = WizardState.attack;
        _dealDamageToEnemy(25);
      } else {
        feedbackMessage = "💥 Errou! 💥";
        wizardState = WizardState.hit;
        _dealDamageToPlayer(20);
      }
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      if (playerHp == 0 || enemyHp == 0) {
        _showEndDialog();
        return;
      }

      setState(() {
        wizardState = WizardState.idle;
        _generateQuestion();
      });
    });
  }

  // ➤ Diálogo final
  void _showEndDialog() {
    bool venceu = enemyHp == 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        title: Text(
          venceu ? "🏆 Vitória!" : "💀 Derrota!",
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          venceu
              ? "Você derrotou o inimigo!"
              : "O mago ficou sem energia!",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                playerHp = playerMaxHp;
                enemyHp = enemyMaxHp;
                wizardState = WizardState.idle;
                _generateQuestion();
              });
            },
            child: const Text("Jogar de novo", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ➤ Escolher animação
  Widget _buildWizard() {
    switch (wizardState) {
      case WizardState.attack:
        return const WizardAttackAnimation(size: 180);
      case WizardState.hit:
        return const WizardHitAnimation(size: 180);
      default:
        return const WizardIdleAnimation(size: 180);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Derrote seu inimigo!"),
        backgroundColor: const Color(0xFF4527A0),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 🔥 Fundo dinâmico
          Positioned.fill(
            child: Image.asset(
              widget.realm.image,
              fit: BoxFit.cover,
            ),
          ),

          // Escurecer fundo
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.35)),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20),

                // 🟥 INIMIGO + HP
                Column(
                  children: [
                    _buildHpBar(enemyHp, enemyMaxHp, Colors.redAccent),
                    const SizedBox(height: 12),

                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: widget.realm.color,
                          width: 4,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            widget.realm.color.withOpacity(0.8),
                            widget.realm.color.withOpacity(0.6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.realm.color.withOpacity(0.8),
                            blurRadius: 25,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Text(
                      "$a $symbol ? = $result",
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),

                // ✨ FEEDBACK
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

                // 🟢 FEITIÇOS
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
                            "$opt",
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

                // ❤️ HP DO MAGO + SPRITE
                Column(
                  children: [
                    _buildHpBar(playerHp, playerMaxHp, Colors.greenAccent),
                    const SizedBox(height: 12),
                    _buildWizard(),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

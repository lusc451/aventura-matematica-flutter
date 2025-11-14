import 'dart:math';
import 'package:flutter/material.dart';

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
      feedbackMessage =
          selected == answer ? '✨ Acertou! ✨' : '💥 Errou! 💥';

      Future.delayed(const Duration(seconds: 1), () {
        setState(() => _generateQuestion());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔥  Fundo mágico (imagem reino de fogo)
          Positioned.fill(
            child: Image.asset(
              'assets/images/reino-fogo.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Camada escura para legibilidade
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

                // 🟥 VILÃO – Quadrado mágico estilizado
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

                // ✨ FEEDBACK ANIMADO
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: feedbackMessage.isEmpty ? 0 : 1,
                  child: Text(
                    feedbackMessage,
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 15,
                          color: Colors.orange,
                        )
                      ],
                    ),
                  ),
                ),

                // 🟢 FEITIÇOS (Gifs animados com números)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: options.map((opt) {
                    return GestureDetector(
                      onTap: () => _checkAnswer(opt),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 🔮 GIF do Feitiço
                          Image.asset(
                            'assets/images/fireball.png',
                            height: 110,
                          ),
                          // Número acima da energia
                          Text(
                            '$opt',
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 20,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                // 🧙‍♂️ MAGO HEROI
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/mago.jpg',
                      height: 150,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

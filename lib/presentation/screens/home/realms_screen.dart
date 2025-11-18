import 'package:flutter/material.dart';
import '../game/game_screen.dart';

enum MathOperation { addition, subtraction, multiplication, mix }

class Realm {
  final String name;
  final String image;
  final String description;
  final Color color;
  final MathOperation operation;

  Realm(this.name, this.image, this.description, this.color, this.operation);
}

class RealmsScreen extends StatelessWidget {
  const RealmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final realms = [
      Realm(
        "Reino das Chamas",
        "assets/images/fire-realm.png",
        "Desafios de adição com lava e brasas!",
        Colors.deepOrange,
        MathOperation.addition,
      ),
      Realm(
        "Reino das Sombras",
        "assets/images/shadow-realm.png",
        "Subtrações misteriosas na floresta escura.",
        Colors.indigo,
        MathOperation.subtraction,
      ),
      Realm(
        "Reino do Gelo",
        "assets/images/ice-realm.png",
        "Domine multiplicações entre cristais gelados!",
        Colors.lightBlue,
        MathOperation.multiplication,
      ),
      Realm(
        "Reino dos Ventos",
        "assets/images/wind-realm.png",
        "Misture operações em meio a nuvens e trovões!",
        Colors.teal,
        MathOperation.mix,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF311B92),
      appBar: AppBar(
        title: const Text(
          'Escolha seu Reino',
          style: TextStyle(
            fontFamily: 'MedievalSharp',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white, // título branco
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // ícone branco
        backgroundColor: const Color(0xFF4527A0),
        elevation: 4,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const MagicParticles(),
          GridView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: realms.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final realm = realms[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => GameScreen(realm: realm)),
                  );
                },

                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: realm.color.withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        realm.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.error, color: Colors.white),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              realm.color.withOpacity(0.7),
                              Colors.black.withOpacity(0.3),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              realm.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(color: Colors.black54, blurRadius: 8),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                realm.description,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

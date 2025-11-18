import 'package:flutter/material.dart';
import '../game/game_screen.dart';
import '../../widgets/magic_particles.dart'; // ✅ Import corrigido

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
        iconTheme: const IconThemeData(color: Colors.white), // seta branca
        backgroundColor: const Color(0xFF4527A0),
        elevation: 4,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const MagicParticles(count: 25), // ✨ fundo mágico
          Padding(
            padding: const EdgeInsets.all(18),
            child: GridView.builder(
              itemCount: realms.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68, // 🔹 cards maiores
                crossAxisSpacing: 18,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                final realm = realms[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 900),
                        pageBuilder: (_, __, ___) => GameScreen(realm: realm),
                        transitionsBuilder: (_, animation, __, child) {
                          final fade = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          );
                          return FadeTransition(opacity: fade, child: child);
                        },
                      ),
                    );
                  },
                  child: RealmCard(realm: realm),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RealmCard extends StatelessWidget {
  final Realm realm;
  const RealmCard({super.key, required this.realm});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: realm.color.withOpacity(0.5),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 🔹 Imagem de fundo do reino
          Image.asset(
            realm.image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.error, color: Colors.white),
              );
            },
          ),

          // 🔹 Gradiente de sobreposição
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  realm.color.withOpacity(0.25),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // 🔹 Conteúdo textual do card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  realm.name,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontFamily: 'MedievalSharp',
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black87, blurRadius: 6)],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  realm.description,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.5,
                    color: Colors.white70,
                    height: 1.3,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 3)],
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

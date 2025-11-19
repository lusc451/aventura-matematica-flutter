import 'dart:math';
import 'package:flutter/material.dart';
import 'package:aventura_matematica/presentation/screens/home/realm_stages_screen.dart';
import 'package:aventura_matematica/presentation/widgets/magic_particles.dart';

enum MathOperation { addition, subtraction, multiplication, mix }

class Realm {
  final String name;
  final String image;
  final String description;
  final Color color;
  final MathOperation operation;

  Realm(this.name, this.image, this.description, this.color, this.operation);
}

class RealmsScreen extends StatefulWidget {
  const RealmsScreen({super.key});

  @override
  State<RealmsScreen> createState() => _RealmsScreenState();
}

class _RealmsScreenState extends State<RealmsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF4527A0),
        elevation: 4,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const MagicParticles(),
          FadeTransition(
            opacity: _fadeAnim,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: GridView.builder(
                itemCount: realms.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  final realm = realms[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RealmStagesScreen(realm: realm),
                        ),
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
                          Image.asset(realm.image, fit: BoxFit.cover),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.55),
                                  realm.color.withOpacity(0.3),
                                  Colors.amber.withOpacity(0.25),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
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
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'MedievalSharp',
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(1, 1),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  realm.description,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                    fontFamily: 'Poppins',
                                    height: 1.4,
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
            ),
          ),
        ],
      ),
    );
  }
}

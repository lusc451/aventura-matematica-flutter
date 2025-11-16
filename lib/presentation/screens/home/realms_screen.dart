import 'dart:math';
import 'package:flutter/material.dart';
import '../game/game_screen.dart';

class Realm {
  final String name;
  final String image;
  final String description;
  final Color color;

  Realm(this.name, this.image, this.description, this.color);
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
      ),
      Realm(
        "Reino das Sombras",
        "assets/images/shadow-realm.png",
        "Subtrações misteriosas na floresta escura.",
        Colors.indigo,
      ),
      Realm(
        "Reino do Gelo",
        "assets/images/ice-realm.png",
        "Domine as multiplicações entre cristais gelados!",
        Colors.lightBlue,
      ),
      Realm(
        "Reino dos Ventos",
        "assets/images/wind-realm.png",
        "Misture operações em meio a nuvens e trovões!",
        Colors.teal,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF311B92),
      appBar: AppBar(
        title: const Text("Escolha seu Reino"),
        backgroundColor: const Color(0xFF4527A0),
        foregroundColor: Colors.white,
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
                    MaterialPageRoute(
                      builder: (_) => GameScreen(realmName: realm.name),
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

// Efeito de partículas mágicas
class MagicParticles extends StatefulWidget {
  const MagicParticles({super.key});

  @override
  State<MagicParticles> createState() => _MagicParticlesState();
}

class _MagicParticlesState extends State<MagicParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Offset> _particles = List.generate(
    15,
    (_) => Offset(Random().nextDouble(), Random().nextDouble()),
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          painter: _MagicPainter(_particles, _controller.value),
          child: Container(),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _MagicPainter extends CustomPainter {
  final List<Offset> particles;
  final double progress;

  _MagicPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.6);
    for (var p in particles) {
      final dx = (p.dx * size.width + sin(progress * 2 * pi) * 10);
      final dy = (p.dy * size.height + cos(progress * 2 * pi) * 10);
      canvas.drawCircle(Offset(dx, dy), 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MagicPainter oldDelegate) => true;
}

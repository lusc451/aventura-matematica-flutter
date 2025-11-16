import 'package:flutter/material.dart';
import 'package:aventura_matematica/presentation/screens/game/game_screen.dart';
import 'package:aventura_matematica/presentation/widgets/magic_particles.dart';

class RealmsScreen extends StatelessWidget {
  const RealmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final realms = [
      {
        'name': 'Reino das Chamas',
        'description': 'Desafios de adição com lava e brasas!',
        'image': 'assets/images/fire-realm.png',
      },
      {
        'name': 'Reino das Sombras',
        'description': 'Subtrações misteriosas na floresta escura.',
        'image': 'assets/images/shadow-realm.png',
      },
      {
        'name': 'Reino do Gelo',
        'description': 'Domine as multiplicações entre cristais gelados!',
        'image': 'assets/images/ice-realm.png',
      },
      {
        'name': 'Reino dos Ventos',
        'description': 'Misture operações em meio a nuvens e trovões!',
        'image': 'assets/images/wind-realm.png',
      },
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
          const MagicParticles(count: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 16,
                childAspectRatio: 0.68, // 🔹 torna os cards mais altos e amplos
              ),
              itemCount: realms.length,
              itemBuilder: (context, index) {
                final realm = realms[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 800),
                        pageBuilder: (_, __, ___) =>
                            GameScreen(realmName: realm['name']!),
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
                  child: RealmCard(
                    name: realm['name']!,
                    description: realm['description']!,
                    imagePath: realm['image']!,
                  ),
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
  final String name;
  final String description;
  final String imagePath;

  const RealmCard({
    super.key,
    required this.name,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.35),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 12,
            offset: const Offset(3, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'MedievalSharp',
                  fontSize: 22, // 🔹 aumentou
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                description,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15, // 🔹 mais legível
                  color: Colors.white70,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(0.5, 0.5),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

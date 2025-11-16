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
        "assets/images/fire.png",
        "Desafios de adição!",
        Colors.deepOrange,
      ),
      Realm(
        "Reino das Sombras",
        "assets/images/shadow.png",
        "Desafios de subtração!",
        Colors.indigo,
      ),
      Realm(
        "Reino do Gelo",
        "assets/images/ice.png",
        "Multiplicações geladas!",
        Colors.lightBlue,
      ),
      Realm(
        "Reino dos Ventos",
        "assets/images/wind.png",
        "Operações misturadas!",
        Colors.teal,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF311B92),
      appBar: AppBar(
        title: const Text('Escolha seu Reino'),
        backgroundColor: const Color(0xFF4527A0),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: realms.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
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
                color: realm.color.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(realm.image, height: 70),
                  const SizedBox(height: 8),
                  Text(
                    realm.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
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
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:aventura_matematica/presentation/screens/home/realms_screen.dart';
import 'package:aventura_matematica/presentation/widgets/magic_particles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _buttonController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  void _navigateToRealms() {
    Navigator.push(context, _createSmoothTransition(const RealmsScreen()));
  }

  Route _createSmoothTransition(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 900),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF311B92),
      body: Stack(
        children: [
          const MagicParticles(count: 25),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/mago_icon_pixel.png', width: 200),
                const SizedBox(height: 30),
                const Text(
                  'Aventura Matemática',
                  style: TextStyle(
                    fontFamily: 'MedievalSharp',
                    fontSize: 26,
                    color: Colors.amberAccent,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(2, 2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ScaleTransition(
                  scale: _scaleAnim,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadowColor: Colors.pinkAccent.withOpacity(0.7),
                      elevation: 10,
                    ),
                    onPressed: _navigateToRealms,
                    child: const Text(
                      'Jogar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
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

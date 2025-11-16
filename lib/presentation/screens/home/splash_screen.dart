import 'package:flutter/material.dart';
import 'package:aventura_matematica/presentation/screens/home/home_screen.dart';
import 'package:aventura_matematica/presentation/widgets/magic_particles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.05).animate(_fadeAnim);

    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        _createMagicTransition(const HomeScreen()),
      );
    });
  }

  Route _createMagicTransition(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(seconds: 2),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return Stack(
          children: [
            FadeTransition(opacity: animation, child: child),
            Positioned.fill(
              child: IgnorePointer(child: MagicParticles(count: 30)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF311B92),
      body: Stack(
        children: [
          const MagicParticles(count: 25),
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/mago_icon_pixel.png',
                      width: 180,
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      '',
                      style: TextStyle(
                        fontFamily: 'MedievalSharp',
                        fontSize: 28,
                        color: Colors.amberAccent,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

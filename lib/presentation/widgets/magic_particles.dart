import 'dart:math';
import 'package:flutter/material.dart';

class MagicParticles extends StatefulWidget {
  final int count;
  const MagicParticles({super.key, this.count = 20});

  @override
  State<MagicParticles> createState() => _MagicParticlesState();
}

class _MagicParticlesState extends State<MagicParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random random = Random();
  final List<Offset> positions = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.count; i++) {
      positions.add(Offset(random.nextDouble(), random.nextDouble()));
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => CustomPaint(
        painter: _MagicPainter(positions, _controller.value),
        child: Container(),
      ),
    );
  }
}

class _MagicPainter extends CustomPainter {
  final List<Offset> positions;
  final double t;
  final Random random = Random();

  _MagicPainter(this.positions, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amberAccent.withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    for (final p in positions) {
      final dx = p.dx * size.width;
      final dy = (p.dy * size.height + t * 1000) % size.height;
      canvas.drawCircle(Offset(dx, dy), 2 + random.nextDouble() * 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MagicPainter oldDelegate) => true;
}

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

class SpellAnimation extends StatefulWidget {
  final double size;

  const SpellAnimation({super.key, this.size = 120});

  @override
  State<SpellAnimation> createState() => _SpellAnimationState();
}

class _SpellAnimationState extends State<SpellAnimation> {
  SpriteAnimation? animation;
  SpriteAnimationTicker? ticker;

  @override
  void initState() {
    super.initState();
    _loadAnimation();
  }

  Future<void> _loadAnimation() async {
    final image = await Flame.images.load('FireCast_96x96.png');

    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 28,
        textureSize: Vector2(96, 96),
        stepTime: 0.05,
        loop: true,
      ),
    );

    ticker = animation!.createTicker();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (animation == null || ticker == null) {
      return const SizedBox();
    }

    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: SpriteAnimationWidget(
        animation: animation!,
        animationTicker: ticker!,
      ),
    );
  }

  @override
  void dispose() {
    // Na versão atual do Flame, não existe dispose no ticker.
    // ticker?.stop(); // opcional
    super.dispose();
  }
}

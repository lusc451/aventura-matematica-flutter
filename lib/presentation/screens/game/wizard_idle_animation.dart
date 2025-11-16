import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

class WizardIdleAnimation extends StatefulWidget {
  final double size;

  const WizardIdleAnimation({super.key, this.size = 140});

  @override
  State<WizardIdleAnimation> createState() => _WizardIdleAnimationState();
}

class _WizardIdleAnimationState extends State<WizardIdleAnimation> {
  SpriteAnimation? _animation;
  SpriteAnimationTicker? _ticker;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final image = await Flame.images.load('fireWizard/idle.png');

    _animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 8,                      // número de frames
        textureSize: Vector2(96, 96),   // tamanho DO FRAME
        stepTime: 0.1,                  // velocidade do idle
        loop: true,
      ),
    );

    _ticker = _animation!.createTicker();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_animation == null || _ticker == null) {
      return const SizedBox();
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: SpriteAnimationWidget(
        animation: _animation!,
        animationTicker: _ticker!,
      ),
    );
  }

  @override
  void dispose() {
    // 🔥 Nada para limpar nessa versão
    super.dispose();
  }
}

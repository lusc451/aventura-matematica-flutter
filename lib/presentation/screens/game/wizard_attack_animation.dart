import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class WizardAttackAnimation extends StatefulWidget {
  final double size;
  final VoidCallback? onComplete;

  const WizardAttackAnimation({
    super.key,
    this.size = 180,
    this.onComplete,
  });

  @override
  State<WizardAttackAnimation> createState() => _WizardAttackAnimationState();
}

class _WizardAttackAnimationState extends State<WizardAttackAnimation>
    with SingleTickerProviderStateMixin {

  SpriteAnimation? _animation;
  SpriteAnimationTicker? _ticker;
  Ticker? _frameTicker;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final image = await Flame.images.load('fireWizard/attack.png');

    _animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(192, 192), // tamanho REAL
        stepTime: 0.07,
        loop: false,
      ),
    );

    _ticker = _animation!.createTicker();

    _frameTicker = createTicker((Duration dt) {
      if (_ticker == null) return;

      // 🔥 Converte Duration → double (segundos)
      final seconds = dt.inMicroseconds / 1e6;

      _ticker!.update(seconds);

      if (_ticker!.done()) {
        _frameTicker?.stop();

        if (widget.onComplete != null) {
          widget.onComplete!();
        }
      }
    });

    _frameTicker!.start();

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
    _frameTicker?.dispose();
    super.dispose();
  }
}

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GoldNote extends CircleComponent {
  GoldNote({
    super.position,
    this.lifespan = 0.8,
    this.floatSpeed = 28,
    double radius = 8,
  }) : super(
          radius: radius,
          anchor: Anchor.center,
          paint: Paint()..color = _baseColor,
        );

  static const Color _baseColor = Color(0xFFF5C542);
  final double lifespan;
  final double floatSpeed;
  double _elapsed = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    position.y -= floatSpeed * dt;

    final remaining = (1 - (_elapsed / lifespan)).clamp(0.0, 1.0);
    paint.color = _baseColor.withOpacity(0.2 + remaining * 0.8);

    if (_elapsed >= lifespan) {
      removeFromParent();
    }
  }
}

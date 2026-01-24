import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Monster extends CircleComponent with CollisionCallbacks {
  Monster({
    required this.targetProvider,
    this.speed = 90,
    double radius = 14,
  }) : super(
          radius: radius,
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFF8A3B3B),
        );

  final Vector2 Function() targetProvider;
  final double speed;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final target = targetProvider();
    final toTarget = target - position;
    if (toTarget.length2 <= 1) {
      return;
    }
    toTarget.normalize();
    position.add(toTarget * speed * dt);
  }
}

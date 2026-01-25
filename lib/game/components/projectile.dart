import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Projectile extends CircleComponent with CollisionCallbacks {
  Projectile({
    required this.velocity,
    required Vector2 origin,
    double radius = 6,
  }) : super(
          radius: radius,
          position: origin,
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFFB23A3A),
        );

  final Vector2 velocity;
  bool _canDamage = true;

  bool get canDamage => _canDamage;

  void disableDamage() {
    _canDamage = false;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      CircleHitbox()
        ..collisionType = CollisionType.active
        ..isSolid = true,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.add(velocity * dt);
  }
}

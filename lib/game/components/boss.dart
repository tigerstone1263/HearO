import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../audio/note_audio.dart';
import 'projectile.dart';

class Boss extends CircleComponent with CollisionCallbacks {
  Boss({
    required this.note,
    required this.onProjectileSpawn,
    this.hitPoints = 10,
    double radius = 26,
  }) : super(
          radius: radius,
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFF6A2C2C),
        );

  Note note;
  int hitPoints;
  final void Function(Projectile projectile) onProjectileSpawn;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox()..collisionType = CollisionType.passive);
  }

  void spawnProjectile(Vector2 target) {
    final direction = target - position;
    if (direction.length2 == 0) {
      return;
    }
    direction.normalize();
    final projectile = Projectile(
      velocity: direction * 180,
      origin: position.clone(),
    );
    onProjectileSpawn(projectile);
  }

  void setEnraged(bool enraged) {
    paint = Paint()
      ..color = enraged ? const Color(0xFF8F1F1F) : const Color(0xFF6A2C2C);
  }
}

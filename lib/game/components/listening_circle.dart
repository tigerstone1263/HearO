import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ListeningCircle extends PositionComponent with CollisionCallbacks {
  ListeningCircle({
    required this.radius,
    this.onEnter,
    this.onExit,
  }) : super(
          anchor: Anchor.center,
          size: Vector2.all(radius * 2),
        );

  final double radius;
  final void Function(PositionComponent other)? onEnter;
  final void Function(PositionComponent other)? onExit;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      CircleComponent(
        radius: radius,
        anchor: Anchor.center,
        position: size / 2,
        paint: Paint()..color = const Color(0xFF5A6F8A).withOpacity(0.18),
      ),
    );

    final hitbox = CircleHitbox(radius: radius)
      ..collisionType = CollisionType.active;
    add(hitbox);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    onEnter?.call(other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    onExit?.call(other);
  }
}

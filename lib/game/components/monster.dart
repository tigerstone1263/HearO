import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../audio/note_audio.dart';

enum MonsterState { calm, enraged }

class Monster extends CircleComponent with CollisionCallbacks {
  Monster({
    required this.targetProvider,
    required this.note,
    this.baseSpeed = 90,
    double radius = 14,
  }) : super(
          radius: radius,
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFF8A3B3B),
        );

  final Vector2 Function() targetProvider;
  final Note note;
  final double baseSpeed;
  MonsterState _state = MonsterState.calm;
  bool _canDamage = true;

  bool get canDamage => _canDamage;

  void disableDamage() {
    _canDamage = false;
  }

  bool get isEnraged => _state == MonsterState.enraged;

  void setEnraged(bool value) {
    final nextState = value ? MonsterState.enraged : MonsterState.calm;
    if (nextState == _state) {
      return;
    }
    _state = nextState;
    paint = Paint()
      ..color = value ? const Color(0xFFD84A4A) : const Color(0xFF8A3B3B);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      CircleHitbox()
        ..collisionType = CollisionType.passive
        ..isSolid = true,
    );

    add(
      CircleComponent(
        radius: radius * 1.8,
        paint: Paint()..color = const Color(0x22000000),
        priority: -2,
      )
        ..anchor = Anchor.center
        ..position = Vector2(0, radius * 0.85)
        ..scale = Vector2(1.5, 0.45),
    );

    // Outline for visibility on light backgrounds.
    add(
      CircleComponent(
        radius: radius,
        paint: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.black.withOpacity(0.35),
        priority: 1,
      )..anchor = Anchor.center,
    );
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
    final speedMultiplier = isEnraged ? 2.0 : 1.0;
    position.add(toTarget * baseSpeed * speedMultiplier * dt);
  }
}

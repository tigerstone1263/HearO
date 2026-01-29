import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'player.dart';

class ForestMap extends PositionComponent {
  ForestMap({
    required this.mapIndex,
    required this.mapSize,
    required this.onExitReached,
  });

  final int mapIndex;
  final Vector2 mapSize;
  final VoidCallback onExitReached;

  Vector2 get entryPoint => Vector2(140, mapSize.y / 2);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = mapSize;
    anchor = Anchor.topLeft;
    priority = -20;

    add(
      RectangleComponent(
        size: mapSize,
        paint: Paint()..color = const Color(0xFF1D3B2E),
      ),
    );

    add(
      RectangleComponent(
        size: mapSize,
        paint: Paint()..color = const Color(0xFF2A4B3B).withOpacity(0.35),
      )..priority = -19,
    );

    _populateTrees();

    final gateSize = Vector2(96, 144);
    final gatePosition = Vector2(
      mapSize.x - gateSize.x - 32,
      mapSize.y / 2 - gateSize.y / 2,
    );
    add(
      ExitGate(
        size: gateSize,
        onExitReached: onExitReached,
      )..position = gatePosition,
    );
  }

  void _populateTrees() {
    final random = Random(mapIndex + 7);
    final treeCount = max(16, (mapSize.x * mapSize.y / 35000).floor());
    for (var i = 0; i < treeCount; i++) {
      final treeSize = 52 + random.nextDouble() * 56;
      final tree = TreeCluster(
        size: treeSize,
        hueShift: random.nextDouble(),
      )
        ..position = Vector2(
          80 + random.nextDouble() * (mapSize.x - 160),
          80 + random.nextDouble() * (mapSize.y - 160),
        )
        ..priority = -5;
      add(tree);
    }
  }
}

class TreeCluster extends PositionComponent {
  TreeCluster({
    required double size,
    required double hueShift,
  }) : super(
          size: Vector2.all(size),
          anchor: Anchor.center,
        ) {
    final foliagePaint = Paint()
      ..color = HSVColor.fromAHSV(1, 110 + hueShift * 25, 0.45, 0.55).toColor();
    final highlightPaint = Paint()
      ..color = HSVColor.fromAHSV(1, 120 + hueShift * 20, 0.35, 0.7).toColor();
    final trunkPaint = Paint()..color = const Color(0xFF5B3A1F);

    add(
      CircleComponent(
        radius: size * 0.36,
        paint: foliagePaint,
      )..position = Vector2(size * 0.5, size * 0.35),
    );
    add(
      CircleComponent(
        radius: size * 0.28,
        paint: highlightPaint,
      )..position = Vector2(size * 0.32, size * 0.3),
    );
    add(
      CircleComponent(
        radius: size * 0.22,
        paint: foliagePaint,
      )..position = Vector2(size * 0.68, size * 0.42),
    );
    add(
      RectangleComponent(
        size: Vector2(size * 0.18, size * 0.32),
        paint: trunkPaint,
      )
        ..anchor = Anchor.topCenter
        ..position = Vector2(size * 0.5, size * 0.52),
    );
  }
}

class ExitGate extends PositionComponent with CollisionCallbacks {
  ExitGate({
    required super.size,
    required this.onExitReached,
  }) : super(anchor: Anchor.topLeft);

  final VoidCallback onExitReached;
  bool _triggered = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = const Color(0xFF8B5E3C),
      )..priority = 1,
    );
    add(
      RectangleComponent(
        size: size - Vector2.all(12),
        paint: Paint()..color = const Color(0xFF3F5E3E),
      )
        ..position = Vector2.all(6)
        ..priority = 2,
    );
    add(
      TextComponent(
        text: 'EXIT',
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFE8F2E8),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      )
        ..position = size / 2
        ..priority = 3,
    );
    add(
      RectangleHitbox()
        ..collisionType = CollisionType.passive,
    );
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (_triggered || other is! Player) {
      return;
    }
    _triggered = true;
    onExitReached();
  }
}

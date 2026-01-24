import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HealthDisplay extends PositionComponent {
  HealthDisplay({
    required this.maxHearts,
    required this.currentHearts,
  }) : super(anchor: Anchor.topCenter);

  final int maxHearts;
  int currentHearts;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    const heartSize = 16.0;
    const spacing = 8.0;
    final totalWidth = maxHearts * heartSize + (maxHearts - 1) * spacing;
    final startX = -totalWidth / 2;

    for (var i = 0; i < maxHearts; i++) {
      final filled = i < currentHearts;
      final color = filled
          ? const Color(0xFFE05858)
          : const Color(0xFF5A5F66);
      final rect = Rect.fromLTWH(
        startX + i * (heartSize + spacing),
        0,
        heartSize,
        heartSize,
      );
      final paint = Paint()..color = color.withOpacity(0.9);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        paint,
      );
    }
  }
}

import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum PlayerState { idle, walk }

class Player extends SpriteAnimationComponent {
  Player({super.position})
      : super(
          anchor: Anchor.center,
          size: Vector2.all(96),
        );

  static final Vector2 _frameSize = Vector2.all(32);

  late final Map<PlayerState, SpriteAnimation> _animations;
  PlayerState _state = PlayerState.idle;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _animations = {
      PlayerState.idle: await _buildPlaceholderAnimation(
        frames: 4,
        stepTime: 0.2,
        baseColor: const Color(0xFF3C5A7A),
        accentColor: const Color(0xFFE1E6ED),
      ),
      PlayerState.walk: await _buildPlaceholderAnimation(
        frames: 6,
        stepTime: 0.12,
        baseColor: const Color(0xFF6B8F4E),
        accentColor: const Color(0xFFF2E8C9),
      ),
    };

    animation = _animations[_state];
  }

  void setMoving(bool isMoving) {
    final nextState = isMoving ? PlayerState.walk : PlayerState.idle;
    if (nextState == _state) {
      return;
    }

    _state = nextState;
    animation = _animations[_state];
  }

  Future<SpriteAnimation> _buildPlaceholderAnimation({
    required int frames,
    required double stepTime,
    required Color baseColor,
    required Color accentColor,
  }) async {
    final image = await _buildPlaceholderSheet(
      frames: frames,
      baseColor: baseColor,
      accentColor: accentColor,
    );

    return SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: frames,
        stepTime: stepTime,
        textureSize: _frameSize,
      ),
    );
  }

  Future<ui.Image> _buildPlaceholderSheet({
    required int frames,
    required Color baseColor,
    required Color accentColor,
  }) async {
    // Placeholder sprite sheet for animation wiring before real art arrives.
    final width = (_frameSize.x * frames).toInt();
    final height = _frameSize.y.toInt();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    );

    for (var index = 0; index < frames; index++) {
      final frameLeft = _frameSize.x * index;
      final frameRect = Rect.fromLTWH(
        frameLeft,
        0,
        _frameSize.x,
        _frameSize.y,
      );

      final framePaint = Paint()..color = baseColor.withOpacity(0.7 + index * 0.04);
      canvas.drawRect(frameRect, framePaint);

      final pulse = 0.18 + (index / frames) * 0.3;
      final center = Offset(
        frameLeft + _frameSize.x * 0.5,
        _frameSize.y * 0.55,
      );
      final accentPaint = Paint()..color = accentColor;
      canvas.drawCircle(center, _frameSize.x * pulse, accentPaint);
    }

    final picture = recorder.endRecording();
    return picture.toImage(width, height);
  }
}

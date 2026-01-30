import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'listening_circle.dart';
import 'monster.dart';
import 'projectile.dart';

enum PlayerFacing { back, front }

class Player extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<FlameGame> {
  Player({
    super.position,
    this.baseSpeed = 180,
    this.onListeningEnter,
    this.onListeningExit,
    this.onHit,
  })
      : super(
          anchor: Anchor.center,
          size: Vector2.all(_frameSide * _spriteScale),
        );

  // Use paths relative to Flame's default `assets/images/` prefix.
  // This avoids issues like `assets/assets/images/...` when loading on web.
  // Use the knight sheet for both idle (static first frame) and walk (4-frame loop).
  static const String _backSpritePath = 'Main Characters/player1/back.webp';
  static const String _frontSpritePath = 'Main Characters/player1/front.webp';
  static const double _frameSide = 1024;
  static const double _spriteScale = 0.16;
  static final Vector2 _backFrameSize = Vector2(_frameSide, _frameSide);
  static final Vector2 _frontFrameSize = Vector2(_frameSide, _frameSide);
  static const int _backFrameCount = 1;
  static const int _frontFrameCount = 1;
  final double baseSpeed;
  final void Function(PositionComponent other)? onListeningEnter;
  final void Function(PositionComponent other)? onListeningExit;
  final void Function(PositionComponent other)? onHit;
  late final double listeningRadius;
  Vector2 _moveDirection = Vector2.zero();

  final Map<PlayerFacing, SpriteAnimation> _animations = {};
  bool _animationsReady = false;
  PlayerFacing _facing = PlayerFacing.front;
  bool _facingLeft = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    listeningRadius = size.x * 1.5;
    _animations[PlayerFacing.back] = await _buildAnimation(
      spritePath: _backSpritePath,
      frameSize: _backFrameSize,
      frameCount: _backFrameCount,
      stepTime: 0.18,
    );
    _animations[PlayerFacing.front] = await _buildAnimation(
      spritePath: _frontSpritePath,
      frameSize: _frontFrameSize,
      frameCount: _frontFrameCount,
      stepTime: 0.12,
    );
    _animationsReady = true;
    animation = _animations[_facing];

    add(
      ListeningCircle(
        radius: listeningRadius,
        onEnter: onListeningEnter,
        onExit: onListeningExit,
      )
        ..position = size / 2
        ..priority = -1,
    );

    add(
      CircleHitbox()
        ..collisionType = CollisionType.active
        ..isSolid = true,
    );

    add(
      CircleComponent(
        radius: 17,
        paint: Paint()..color = Colors.black.withOpacity(0.18),
        priority: -2,
      )
        ..anchor = Anchor.center
        ..position = Vector2(0, size.y / 2 - 6)
        ..scale = Vector2(1.6, 0.36),
    );
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Monster && other.canDamage) {
      onHit?.call(other);
    }
    if (other is Projectile && other.canDamage) {
      onHit?.call(other);
      other.disableDamage();
      other.removeFromParent();
    }
  }

  void setMoveDirection(Vector2 direction) {
    if (direction.length2 == 0) {
      _moveDirection = Vector2.zero();
      return;
    }

    _moveDirection = direction.normalized();
    if (direction.y < 0) {
      _setFacing(PlayerFacing.back);
    } else if (direction.y > 0) {
      _setFacing(PlayerFacing.front);
    }
    if (direction.x != 0) {
      _facingLeft = direction.x < 0;
      _updateFacing();
    }
  }

  void _setFacing(PlayerFacing facing) {
    if (facing == _facing) {
      return;
    }
    _facing = facing;
    if (!_animationsReady) {
      return;
    }
    animation = _animations[_facing];
  }

  void _updateFacing() {
    final baseScaleX = scale.x.abs();
    scale.x = _facingLeft ? -baseScaleX : baseScaleX;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_moveDirection.length2 == 0) {
      return;
    }
    position.add(_moveDirection * baseSpeed * dt);
    if (_moveDirection.y != 0) {
      _setFacing(_moveDirection.y < 0 ? PlayerFacing.back : PlayerFacing.front);
    }
    if (_moveDirection.x != 0) {
      final shouldFaceLeft = _moveDirection.x < 0;
      if (shouldFaceLeft != _facingLeft) {
        _facingLeft = shouldFaceLeft;
        _updateFacing();
      }
    }
  }

  Future<SpriteAnimation> _buildAnimation({
    required String spritePath,
    required Vector2 frameSize,
    required int frameCount,
    required double stepTime,
  }) async {
    final image = await gameRef.images.load(spritePath);
    return SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: frameCount,
        stepTime: stepTime,
        textureSize: frameSize,
      ),
    );
  }
}

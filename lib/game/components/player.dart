import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'listening_circle.dart';
import 'monster.dart';
import 'projectile.dart';

enum PlayerState { idle, walk }

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
          size: Vector2(48, 69),
        );

  // Use paths relative to Flame's default `assets/images/` prefix.
  // This avoids issues like `assets/assets/images/...` when loading on web.
  // Use the knight sheet for both idle (static first frame) and walk (4-frame loop).
  static const String _idleSpritePath = 'player1/walk.png';
  static const String _walkSpritePath = 'player1/walk.png';
  // walk.png is 864x241 => 4x1 grid => 216x241, 4 frames.
  static final Vector2 _walkFrameSize = Vector2(216, 241);
  static final Vector2 _idleFrameSize = _walkFrameSize;
  static const int _idleFrameCount = 1;
  static const int _walkFrameCount = 4;
  final double baseSpeed;
  final void Function(PositionComponent other)? onListeningEnter;
  final void Function(PositionComponent other)? onListeningExit;
  final void Function(PositionComponent other)? onHit;
  late final double listeningRadius;
  Vector2 _moveDirection = Vector2.zero();

  final Map<PlayerState, SpriteAnimation> _animations = {};
  bool _animationsReady = false;
  PlayerState _state = PlayerState.idle;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    listeningRadius = size.x * 1.5;
    _animations[PlayerState.idle] = await _buildAnimation(
      spritePath: _idleSpritePath,
      frameSize: _idleFrameSize,
      frameCount: _idleFrameCount,
      stepTime: 0.18,
    );
    _animations[PlayerState.walk] = await _buildAnimation(
      spritePath: _walkSpritePath,
      frameSize: _walkFrameSize,
      frameCount: _walkFrameCount,
      stepTime: 0.12,
    );
    _animationsReady = true;
    _state = _moveDirection.length2 > 0 ? PlayerState.walk : PlayerState.idle;
    animation = _animations[_state];

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

  void setMoving(bool isMoving) {
    final nextState = isMoving ? PlayerState.walk : PlayerState.idle;
    if (nextState == _state) {
      return;
    }

    _state = nextState;
    if (!_animationsReady) {
      return;
    }
    animation = _animations[_state];
  }

  void setMoveDirection(Vector2 direction) {
    if (direction.length2 == 0) {
      _moveDirection = Vector2.zero();
      setMoving(false);
      return;
    }

    _moveDirection = direction.normalized();
    setMoving(true);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_moveDirection.length2 == 0) {
      return;
    }
    position.add(_moveDirection * baseSpeed * dt);
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

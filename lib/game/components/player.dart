import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/cache.dart';

import 'listening_circle.dart';
import 'monster.dart';
import 'projectile.dart';

enum PlayerState { idle, walk }

class Player extends SpriteAnimationComponent with CollisionCallbacks {
  Player({
    super.position,
    this.baseSpeed = 180,
    this.onListeningEnter,
    this.onListeningExit,
    this.onHit,
  })
      : super(
          anchor: Anchor.center,
          size: Vector2(96, 138),
        );

  static const String _idleSpritePath = 'assets/images/player1/idle.png';
  static const String _walkSpritePath = 'assets/images/player1/walk.png';
  static final Images _imageCache = Images(prefix: '');
  static final Vector2 _frameSize = Vector2(864, 241);
  static const int _framesPerRow = 4;
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
      _idleSpritePath,
      stepTime: 0.18,
    );
    _animations[PlayerState.walk] = await _buildAnimation(
      _walkSpritePath,
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

  Future<SpriteAnimation> _buildAnimation(
    String spritePath, {
    required double stepTime,
  }) async {
    final image = await _imageCache.load(spritePath);
    return SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: _framesPerRow,
        stepTime: stepTime,
        textureSize: _frameSize,
      ),
    );
  }
}

import 'package:flame/components.dart';
import 'package:hear_o/domain/characters/players/player_config.dart';

class GhostKnightConfig implements PlayerConfig {
  GhostKnightConfig({
    required this.backSpritePath,
    required this.frontSpritePath,
    required this.frameSide,
    required this.spriteScale,
    required this.baseSpeed,
    required this.maxHealth,
  });

  final String backSpritePath;
  final String frontSpritePath;
  final double frameSide;
  final double spriteScale;
  final double baseSpeed;
  final int maxHealth;

  Vector2 get frameSize => Vector2(frameSide, frameSide);

  Vector2 get renderSize => Vector2.all(frameSide * spriteScale);

  static final GhostKnightConfig defaultConfig = GhostKnightConfig(
    backSpritePath: 'characters/ghost_knight/back.webp',
    frontSpritePath: 'characters/ghost_knight/front.webp',
    frameSide: 1024,
    spriteScale: 0.16,
    baseSpeed: 180,
    maxHealth: 12,
  );

  @override
  int currentHealth = 3;
}

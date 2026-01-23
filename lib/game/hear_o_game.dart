import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/player.dart';

class HearOGame extends FlameGame with KeyboardEvents {
  Player? _player;

  @override
  Color backgroundColor() => const Color(0xFF0B0C10);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _player = Player(position: size / 2);
    add(_player!);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    final player = _player;
    if (player != null) {
      player.position = canvasSize / 2;
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final player = _player;
    if (player == null) {
      return KeyEventResult.ignored;
    }

    final isMoving = keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown);
    player.setMoving(isMoving);
    return KeyEventResult.handled;
  }
}

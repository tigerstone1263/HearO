import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/player.dart';

class HearOGame extends FlameGame with KeyboardEvents {
  late final JoystickComponent _joystick;
  Player? _player;
  Vector2 _keyboardDirection = Vector2.zero();

  @override
  Color backgroundColor() => const Color(0xFF0B0C10);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _player = Player(position: size / 2);
    add(_player!);

    _joystick = JoystickComponent(
      knob: CircleComponent(
        radius: 28,
        paint: Paint()..color = const Color(0xFFE1E6ED).withOpacity(0.8),
      ),
      background: CircleComponent(
        radius: 56,
        paint: Paint()..color = const Color(0xFF3C5A7A).withOpacity(0.5),
      ),
      margin: const EdgeInsets.only(left: 24, bottom: 24),
    );
    add(_joystick);
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

    _keyboardDirection = _directionFromKeys(keysPressed);
    return KeyEventResult.handled;
  }

  @override
  void update(double dt) {
    super.update(dt);
    final player = _player;
    if (player == null) {
      return;
    }

    final joystickDirection = _joystick.direction;
    if (joystickDirection != JoystickDirection.idle) {
      player.setMoveDirection(_directionFromJoystick(joystickDirection));
    } else if (_keyboardDirection.length2 > 0) {
      player.setMoveDirection(_keyboardDirection);
    } else {
      player.setMoveDirection(Vector2.zero());
    }
  }

  Vector2 _directionFromKeys(Set<LogicalKeyboardKey> keysPressed) {
    var x = 0.0;
    var y = 0.0;
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      x -= 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      x += 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      y -= 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      y += 1;
    }
    return Vector2(x, y);
  }

  Vector2 _directionFromJoystick(JoystickDirection direction) {
    switch (direction) {
      case JoystickDirection.up:
        return Vector2(0, -1);
      case JoystickDirection.upRight:
        return Vector2(1, -1);
      case JoystickDirection.right:
        return Vector2(1, 0);
      case JoystickDirection.downRight:
        return Vector2(1, 1);
      case JoystickDirection.down:
        return Vector2(0, 1);
      case JoystickDirection.downLeft:
        return Vector2(-1, 1);
      case JoystickDirection.left:
        return Vector2(-1, 0);
      case JoystickDirection.upLeft:
        return Vector2(-1, -1);
      case JoystickDirection.idle:
        return Vector2.zero();
    }
  }
}

import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'audio/note_audio.dart';
import 'components/monster.dart';
import 'components/player.dart';

class HearOGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  static const String audioOverlayId = 'audioPrompt';

  late final JoystickComponent _joystick;
  final NoteAudio _noteAudio = NoteAudio();
  Player? _player;
  Vector2 _keyboardDirection = Vector2.zero();
  bool _audioUnlocked = false;
  final Random _random = Random();
  late final TimerComponent _spawnTimer;

  @override
  Color backgroundColor() => const Color(0xFF0B0C10);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _player = Player(
      position: size / 2,
      onListeningEnter: _handleListeningEnter,
    );
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

    _spawnTimer = TimerComponent(
      period: 1.8,
      repeat: true,
      onTick: _spawnMonster,
    );
    add(_spawnTimer);
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

    if (event is KeyDownEvent && _audioUnlocked) {
      final note = _noteFromKey(event.logicalKey);
      if (note != null) {
        unawaited(_noteAudio.play(note));
      }
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

  Note? _noteFromKey(LogicalKeyboardKey key) {
    switch (key) {
      case LogicalKeyboardKey.keyA:
        return Note.c;
      case LogicalKeyboardKey.keyS:
        return Note.d;
      case LogicalKeyboardKey.keyD:
        return Note.e;
      case LogicalKeyboardKey.keyF:
        return Note.f;
      case LogicalKeyboardKey.keyG:
        return Note.g;
      case LogicalKeyboardKey.keyH:
        return Note.a;
      case LogicalKeyboardKey.keyJ:
        return Note.b;
    }
    return null;
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

  Future<void> unlockAudio() async {
    if (_audioUnlocked) {
      return;
    }
    _audioUnlocked = true;
    overlays.remove(audioOverlayId);
    await _noteAudio.play(Note.c);
  }

  void _spawnMonster() {
    final player = _player;
    if (player == null || size.x == 0 || size.y == 0) {
      return;
    }

    const spawnMargin = 48.0;
    final edge = _random.nextInt(4);
    final width = size.x;
    final height = size.y;
    final position = switch (edge) {
      0 => Vector2(_random.nextDouble() * width, -spawnMargin),
      1 => Vector2(width + spawnMargin, _random.nextDouble() * height),
      2 => Vector2(_random.nextDouble() * width, height + spawnMargin),
      _ => Vector2(-spawnMargin, _random.nextDouble() * height),
    };

    final speed = 70 + _random.nextDouble() * 50;
    final note = _randomNote();
    final monster = Monster(
      targetProvider: () => player.position.clone(),
      note: note,
      speed: speed,
    )..position = position;

    add(monster);
  }

  void _handleListeningEnter(PositionComponent other) {
    if (!_audioUnlocked) {
      return;
    }
    if (other is Monster) {
      unawaited(_noteAudio.play(other.note));
    }
  }

  Note _randomNote() {
    final values = Note.values;
    return values[_random.nextInt(values.length)];
  }
}

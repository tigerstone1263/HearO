import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'audio/note_audio.dart';
import 'components/gold_note.dart';
import 'components/health_display.dart';
import 'components/boss.dart';
import 'components/monster.dart';
import 'components/piano_keys.dart';
import 'components/player.dart';
import 'components/projectile.dart';
import 'stage_manager.dart';

class HearOGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  static const String audioOverlayId = 'audioPrompt';
  static const String gameOverOverlayId = 'gameOver';
  static const String clearOverlayId = 'clear';
  static const String homeOverlayId = 'home';
  static const String splashOverlayId = 'splash';

  late final JoystickComponent _joystick;
  final NoteAudio _noteAudio = NoteAudio();
  Player? _player;
  Vector2 _keyboardDirection = Vector2.zero();
  bool _audioUnlocked = false;
  final Random _random = Random();
  late final TimerComponent _spawnTimer;
  final Set<Monster> _monsters = {};
  final Set<Monster> _listeningMonsters = {};
  PianoKeys? _pianoKeys;
  TextComponent? _scoreText;
  int _score = 0;
  static const int _scorePerNote = 10;
  static const double _monsterSpeedScale = 0.5;
  static const int _maxHearts = 12;
  int _currentHearts = _maxHearts;
  HealthDisplay? _healthDisplay;
  TextComponent? _stageText;
  late final StageManager _stageManager;
  bool _isInvincible = false;
  double _invincibleTimer = 0;
  static const double _invincibleDuration = 1.2;
  Boss? _boss;
  late final TimerComponent _bossFireTimer;
  bool _isGameOver = false;
  bool _isClear = false;
  bool _gameStarted = false;

  int get score => _score;

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _player = Player(
      position: size / 2,
      onListeningEnter: _handleListeningEnter,
      onListeningExit: _handleListeningExit,
      onHit: _handlePlayerHit,
    );
    world.add(_player!);
    camera.viewfinder.anchor = Anchor.center;
    camera.follow(_player!, snap: true);

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
    camera.viewport.add(_joystick);

    _pianoKeys = PianoKeys(
      noteAudio: _noteAudio,
      onNoteSelected: (note) => _handlePlayerNoteInput(note, playAudio: true),
    )
      ..position = Vector2(size.x - 24, size.y - 24)
      ..priority = 10;
    camera.viewport.add(_pianoKeys!);

    _scoreText = TextComponent(
      text: 'Score 0',
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 12),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFE1E6ED),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    )..priority = 20;
    camera.viewport.add(_scoreText!);

    _healthDisplay = HealthDisplay(
      maxHearts: _maxHearts,
      currentHearts: _currentHearts,
    )
      ..position = Vector2(size.x / 2, 36)
      ..priority = 20;
    camera.viewport.add(_healthDisplay!);

    _stageText = TextComponent(
      text: 'Stage 1',
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 58),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFB7C2CF),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    )..priority = 20;
    camera.viewport.add(_stageText!);

    _spawnTimer = TimerComponent(
      period: 1.8,
      repeat: true,
      onTick: _spawnMonster,
    );
    add(_spawnTimer);
    _spawnTimer.timer.stop();

    _bossFireTimer = TimerComponent(
      period: 2.2,
      repeat: true,
      onTick: _fireBossProjectile,
    );
    add(_bossFireTimer);
    _bossFireTimer.timer.stop();

    _stageManager = StageManager(onStageChanged: _onStageChanged);

    if (kDebugMode) {
      debugMode = true;
    }
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    final player = _player;
    if (player != null) {
      player.position = canvasSize / 2;
    }
    _pianoKeys?.position = Vector2(canvasSize.x - 24, canvasSize.y - 24);
    _scoreText?.position = Vector2(canvasSize.x / 2, 12);
    _healthDisplay?.position = Vector2(canvasSize.x / 2, 36);
    _stageText?.position = Vector2(canvasSize.x / 2, 58);
  }

  @override
  void onRemove() {
    for (final monster in _monsters) {
      monster.removeFromParent();
    }
    _monsters.clear();
    _listeningMonsters.clear();
    _boss?.removeFromParent();
    _stageManager.dispose();
    super.onRemove();
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

    if (event is KeyDownEvent) {
      final note = _noteFromKey(event.logicalKey);
      if (note != null) {
        _handlePlayerNoteInput(note, playAudio: true);
      }
    }
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyX) {
        _enrageMonsters();
      } else if (event.logicalKey == LogicalKeyboardKey.keyC) {
        _calmMonsters();
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

    if (_isInvincible) {
      _invincibleTimer -= dt;
      if (_invincibleTimer <= 0) {
        _isInvincible = false;
      }
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
    // Always allow dismissing the overlay, even if audio was already unlocked.
    overlays.remove(audioOverlayId);
    if (_audioUnlocked) {
      return;
    }
    _audioUnlocked = true;
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
    final center = camera.viewfinder.position;
    final halfWidth = width / 2;
    final halfHeight = height / 2;
    final left = center.x - halfWidth;
    final right = center.x + halfWidth;
    final top = center.y - halfHeight;
    final bottom = center.y + halfHeight;
    final position = switch (edge) {
      0 => Vector2(left + _random.nextDouble() * width, top - spawnMargin),
      1 => Vector2(right + spawnMargin, top + _random.nextDouble() * height),
      2 => Vector2(left + _random.nextDouble() * width, bottom + spawnMargin),
      _ => Vector2(left - spawnMargin, top + _random.nextDouble() * height),
    };

    final speedBase = 70 + _random.nextDouble() * 50;
    final speed =
        speedBase * _monsterSpeedScale * speedMultiplierFor(_stageManager.phase);
    final note = _randomNote();
    final monster = Monster(
      targetProvider: () => player.position.clone(),
      note: note,
      baseSpeed: speed,
    )..position = position;

    _monsters.add(monster);
    world.add(monster);
    monster.removed.then((_) {
      _monsters.remove(monster);
      _listeningMonsters.remove(monster);
    });
  }

  void _handleListeningEnter(PositionComponent other) {
    if (other is Monster) {
      _listeningMonsters.add(other);
      if (_audioUnlocked) {
        unawaited(_noteAudio.play(other.note));
      }
    }
  }

  void _handleListeningExit(PositionComponent other) {
    if (other is Monster) {
      _listeningMonsters.remove(other);
    }
  }

  void _handlePlayerNoteInput(Note note, {required bool playAudio}) {
    if (!_audioUnlocked) {
      return;
    }
    if (playAudio) {
      unawaited(_noteAudio.play(note));
    }
    final candidates = _listeningCandidates().toList();
    if (candidates.isEmpty) {
      return;
    }
    final matchingTarget = _closestListeningMonster(
      candidates,
      filter: (monster) => monster.note == note,
    );
    if (matchingTarget != null) {
      final dropPosition = matchingTarget.position.clone();
      matchingTarget.removeFromParent();
      _listeningMonsters.remove(matchingTarget);
      _spawnGoldNote(dropPosition);
      _registerScore(_scorePerNote);
      return;
    }

    final boss = _boss;
    if (boss != null && _stageManager.phase == StagePhase.stage4) {
      if (boss.note == note) {
        _handleBossHit();
        return;
      }
    }

    final closest = _closestListeningMonster(candidates);
    if (closest != null) {
      closest.setEnraged(true);
    }
  }

  Monster? _closestListeningMonster(
    Iterable<Monster> monsters, {
    bool Function(Monster monster)? filter,
  }) {
    Monster? closest;
    var closestDistance2 = double.infinity;
    for (final monster in monsters) {
      if (filter != null && !filter(monster)) {
        continue;
      }
      final distance2 = (monster.position - (_player?.position ?? Vector2.zero()))
          .length2;
      if (distance2 < closestDistance2) {
        closestDistance2 = distance2;
        closest = monster;
      }
    }
    return closest;
  }

  Iterable<Monster> _listeningCandidates() sync* {
    if (_listeningMonsters.isNotEmpty) {
      yield* _listeningMonsters;
      return;
    }

    final player = _player;
    if (player == null) {
      return;
    }
    final radius2 = player.listeningRadius * player.listeningRadius;
    for (final monster in _monsters) {
      final distance2 = (monster.position - player.position).length2;
      if (distance2 <= radius2) {
        yield monster;
      }
    }
  }

  void _spawnGoldNote(Vector2 position) {
    world.add(GoldNote(position: position)..priority = 5);
  }

  void _registerScore(int points) {
    _score += points;
    _scoreText?.text = 'Score $_score';
  }

  void _handlePlayerHit(PositionComponent other) {
    if (_isInvincible) {
      return;
    }
    if (other is Monster) {
      other.disableDamage();
    }
    _currentHearts = (_currentHearts - 1).clamp(0, _maxHearts);
    _healthDisplay?.currentHearts = _currentHearts;
    _isInvincible = true;
    _invincibleTimer = _invincibleDuration;
    if (_currentHearts <= 0) {
      _triggerGameOver();
    }
  }

  void _onStageChanged(StagePhase phase) {
    _stageText?.text = _stageManager.label();
    if (phase == StagePhase.stage4) {
      _spawnBoss();
    }
  }

  void _spawnBoss() {
    if (_boss != null) {
      return;
    }
    final bossNote = _randomNote();
    _boss = Boss(
      note: bossNote,
      onProjectileSpawn: _addProjectile,
    )..position = camera.viewfinder.position.clone();
    world.add(_boss!);
  }

  void _handleBossHit() {
    final boss = _boss;
    if (boss == null) {
      return;
    }
    boss.hitPoints -= 1;
    boss.setEnraged(true);
    if (boss.hitPoints <= 0) {
      final dropPosition = boss.position.clone();
      boss.removeFromParent();
      _boss = null;
      _spawnGoldNote(dropPosition);
      _registerScore(_scorePerNote * 5);
      _triggerClear();
      return;
    }
    boss.note = _randomNote();
  }

  void _triggerGameOver() {
    if (_isGameOver || _isClear) {
      return;
    }
    _isGameOver = true;
    pauseEngine();
    _spawnTimer.timer.stop();
    _bossFireTimer.timer.stop();
    overlays.add(gameOverOverlayId);
  }

  void _triggerClear() {
    if (_isGameOver || _isClear) {
      return;
    }
    _isClear = true;
    pauseEngine();
    _spawnTimer.timer.stop();
    _bossFireTimer.timer.stop();
    overlays.add(clearOverlayId);
  }

  void restart() {
    overlays.remove(gameOverOverlayId);
    overlays.remove(clearOverlayId);
    _isGameOver = false;
    _isClear = false;
    _score = 0;
    _scoreText?.text = 'Score 0';
    _currentHearts = _maxHearts;
    _healthDisplay?.currentHearts = _currentHearts;
    _isInvincible = false;
    _invincibleTimer = 0;
    _boss?.removeFromParent();
    _boss = null;
    for (final monster in _monsters.toList()) {
      monster.removeFromParent();
    }
    _monsters.clear();
    _listeningMonsters.clear();
    _spawnTimer.timer.start();
    _bossFireTimer.timer.start();
    resumeEngine();
    _stageManager.start();
  }

  void startGame() {
    _gameStarted = true;
    restart();
    _spawnMonsterNearPlayer();
    overlays.remove(homeOverlayId);
    overlays.remove(splashOverlayId);
    overlays.add(audioOverlayId);
  }

  void showHomeOverlay() {
    overlays.remove(splashOverlayId);
    overlays.add(homeOverlayId);
  }

  void _spawnMonsterNearPlayer() {
    final player = _player;
    if (player == null) {
      return;
    }
    // Spawn one monster close to the player so visibility/spawn issues are obvious.
    final angle = _random.nextDouble() * pi * 2;
    final offset = Vector2(cos(angle), sin(angle)) * 220;
    final speedBase = 70 + _random.nextDouble() * 50;
    StagePhase phase;
    try {
      phase = _stageManager.phase;
    } catch (_) {
      phase = StagePhase.stage1;
    }
    final speed =
        speedBase * _monsterSpeedScale * speedMultiplierFor(phase);
    final monster = Monster(
      targetProvider: () => player.position.clone(),
      note: _randomNote(),
      baseSpeed: speed,
    )..position = player.position + offset;
    _monsters.add(monster);
    world.add(monster);
    monster.removed.then((_) {
      _monsters.remove(monster);
      _listeningMonsters.remove(monster);
    });
  }

  void _fireBossProjectile() {
    final boss = _boss;
    final player = _player;
    if (boss == null || player == null) {
      return;
    }
    if (_stageManager.phase != StagePhase.stage4) {
      return;
    }
    boss.spawnProjectile(player.position.clone());
  }

  void _addProjectile(Projectile projectile) {
    world.add(projectile);
  }

  Note _randomNote() {
    StagePhase phase;
    try {
      phase = _stageManager.phase;
    } catch (_) {
      phase = StagePhase.stage1;
    }
    final pool = notePoolFor(phase);
    final values = Note.values;
    final index = pool[_random.nextInt(pool.length)];
    return values[index];
  }

  void _enrageMonsters() {
    for (final monster in _monsters) {
      monster.setEnraged(true);
    }
  }

  void _calmMonsters() {
    for (final monster in _monsters) {
      monster.setEnraged(false);
    }
  }
}

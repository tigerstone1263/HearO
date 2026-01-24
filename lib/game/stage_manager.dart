import 'dart:async';

enum StagePhase { stage1, stage2, stage3, stage4 }

class StageManager {
  StageManager({
    this.stageDuration = const Duration(seconds: 30),
    void Function(StagePhase phase)? onStageChanged,
  }) : _onStageChanged = onStageChanged;

  final Duration stageDuration;
  final void Function(StagePhase phase)? _onStageChanged;

  StagePhase _phase = StagePhase.stage1;
  Timer? _timer;
  int _elapsedSeconds = 0;

  StagePhase get phase => _phase;
  int get elapsedSeconds => _elapsedSeconds;

  void start() {
    _timer?.cancel();
    _elapsedSeconds = 0;
    _phase = StagePhase.stage1;
    _onStageChanged?.call(_phase);
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    stop();
  }

  void _onTick(Timer timer) {
    _elapsedSeconds += 1;
    final nextPhase = _phaseForElapsed(_elapsedSeconds);
    if (nextPhase != _phase) {
      _phase = nextPhase;
      _onStageChanged?.call(_phase);
    }
  }

  StagePhase _phaseForElapsed(int seconds) {
    if (seconds >= stageDuration.inSeconds * 3) {
      return StagePhase.stage4;
    }
    if (seconds >= stageDuration.inSeconds * 2) {
      return StagePhase.stage3;
    }
    if (seconds >= stageDuration.inSeconds) {
      return StagePhase.stage2;
    }
    return StagePhase.stage1;
  }

  String label() {
    switch (_phase) {
      case StagePhase.stage1:
        return 'Stage 1';
      case StagePhase.stage2:
        return 'Stage 2';
      case StagePhase.stage3:
        return 'Stage 3';
      case StagePhase.stage4:
        return 'Stage 4';
    }
  }
}

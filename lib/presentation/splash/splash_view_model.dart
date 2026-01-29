import 'dart:async';

import 'package:flutter/foundation.dart';

import 'splash_intent.dart';
import 'splash_state.dart';

class SplashViewModel {
  SplashViewModel({
    required this.onComplete,
    this.duration = const Duration(milliseconds: 1500),
  }) {
    state = Stream.multi((controller) {
      controller.add(_state);
      final sub = _stateController.stream.listen(
        controller.add,
        onError: controller.addError,
        onDone: controller.close,
      );
      controller.onCancel = sub.cancel;
    });
    _intentController.stream.listen(_handleIntent);
  }

  final VoidCallback onComplete;
  final Duration duration;
  final _stateController = StreamController<SplashState>.broadcast();
  final _intentController = StreamController<SplashIntent>();
  SplashState _state = const SplashState();
  Timer? _timer;
  bool _started = false;
  late final Stream<SplashState> state;

  SplashState get currentState => _state;
  void dispatch(SplashIntent intent) => _intentController.add(intent);

  void start() {
    if (_started) {
      return;
    }
    _started = true;
    dispatch(StartSplashIntent());
  }

  void _handleIntent(SplashIntent intent) {
    if (intent is StartSplashIntent) {
      _emit(const SplashState(progress: 0));
      const totalTicks = 30;
      final interval = Duration(milliseconds: (duration.inMilliseconds / totalTicks).round());
      final step = 1.0 / totalTicks;
      _timer = Timer.periodic(
        interval,
        (timer) {
          final next = (_state.progress + step).clamp(0, 1).toDouble();
          final isComplete = next >= 1;
          _emit(SplashState(progress: next, isComplete: isComplete));
          if (isComplete) {
            timer.cancel();
            onComplete();
          }
        },
      );
    }
  }

  void _emit(SplashState next) {
    _state = next;
    _stateController.add(next);
  }

  void dispose() {
    _timer?.cancel();
    _intentController.close();
    _stateController.close();
  }
}

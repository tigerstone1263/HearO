import 'dart:async';

import 'package:flutter/material.dart';

import 'home_intent.dart';
import 'home_state.dart';

class HomeViewModel {
  HomeViewModel({required this.onStart})
      : _state = HomeState(
          saves: _defaultSaves,
          selectedSaveId: _defaultSaves.first.id,
        ) {
    // StreamBuilder shouldn't miss the initial state even with broadcast streams.
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

  static const List<SaveSlot> _defaultSaves = [
    SaveSlot(
      id: 'slot-01',
      label: 'Slot 01 · Midnight Run',
      detail: '2026.01.24 · Stage 02 · 42%',
      completion: 0.42,
    ),
    SaveSlot(
      id: 'slot-02',
      label: 'Slot 02 · Echo Plains',
      detail: '2025.12.18 · Stage 03 · 61%',
      completion: 0.61,
    ),
    SaveSlot(
      id: 'slot-03',
      label: 'Slot 03 · Iron Gate',
      detail: '2025.11.02 · Stage 01 · 18%',
      completion: 0.18,
    ),
  ];

  final VoidCallback onStart;
  final _stateController = StreamController<HomeState>.broadcast();
  final _intentController = StreamController<HomeIntent>();
  HomeState _state;
  late final Stream<HomeState> state;

  HomeState get currentState => _state;
  void dispatch(HomeIntent intent) => _intentController.add(intent);

  void _handleIntent(HomeIntent intent) {
    if (intent is SelectSaveIntent) {
      if (_state.selectedSaveId == intent.slotId) {
        return;
      }
      _emit(_state.copyWith(selectedSaveId: intent.slotId));
      return;
    }
    if (intent is StartGameIntent && !_state.isStarting) {
      _emit(_state.copyWith(isStarting: true));
      onStart();
    }
  }

  void _emit(HomeState next) {
    _state = next;
    _stateController.add(next);
  }

  void dispose() {
    _intentController.close();
    _stateController.close();
  }
}

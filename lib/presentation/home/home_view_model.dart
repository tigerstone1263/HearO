import 'dart:async';

import 'package:flutter/material.dart';

import 'home_intent.dart';
import 'home_state.dart';

class HomeViewModel {
  HomeViewModel({required this.onStart}) {
    _stateController.add(const HomeState());
    _intentController.stream.listen(_handleIntent);
  }

  final VoidCallback onStart;
  final _stateController = StreamController<HomeState>.broadcast();
  final _intentController = StreamController<HomeIntent>();
  HomeState _state = const HomeState();

  Stream<HomeState> get state => _stateController.stream;
  void dispatch(HomeIntent intent) => _intentController.add(intent);

  void _handleIntent(HomeIntent intent) {
    if (intent is StartGameIntent && !_state.isStarting) {
      _emit(const HomeState(isStarting: true));
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

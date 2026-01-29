import 'package:flutter/material.dart';

import 'home_intent.dart';
import 'home_state.dart';
import 'home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<HomeState>(
      stream: viewModel.state,
      initialData: viewModel.currentState,
      builder: (context, snapshot) {
        final state = snapshot.data ?? viewModel.currentState;
        final buttonLabel = state.isStarting ? 'Starting...' : 'Start Adventure';
        final saves = state.saves;
        final selectedSaveId =
            state.selectedSaveId ?? (saves.isNotEmpty ? saves.first.id : null);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: state.isStarting || selectedSaveId == null
                    ? null
                    : () => viewModel.dispatch(StartGameIntent()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE05858),
                  foregroundColor: const Color(0xFF0B0C10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Text(buttonLabel),
              ),
            ],
          ),
        );
      },
    );
  }
}

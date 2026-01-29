import 'package:flutter/material.dart';

import 'splash_state.dart';
import 'splash_view_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, required this.viewModel});

  final SplashViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final headline = Theme.of(context).textTheme.headlineLarge?.copyWith(
          color: const Color(0xFFE1E6ED),
          fontWeight: FontWeight.w600,
        );

    return StreamBuilder<SplashState>(
      stream: viewModel.state,
      initialData: viewModel.currentState,
      builder: (context, snapshot) {
        final state = snapshot.data ?? viewModel.currentState;
        return Container(
          color: const Color(0xFF0B0C10),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('HearO', style: headline),
              const SizedBox(height: 8),
              const Text(
                'Sound survival · Auto leveling',
                style: TextStyle(color: Color(0xFFB7C2CF)),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  color: const Color(0xFFE1E6ED),
                  backgroundColor: const Color(0xFF1A1D24),
                  value: state.progress,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                state.isComplete
                    ? 'Preparing...'
                    : 'Loading ${(state.progress * 100).toInt()}%',
                style: const TextStyle(color: Color(0xFFB7C2CF)),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import 'home_intent.dart';
import 'home_state.dart';
import 'home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final headline = Theme.of(context).textTheme.headlineLarge?.copyWith(
          color: const Color(0xFFE1E6ED),
          fontWeight: FontWeight.w700,
        );

    final bodyStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xFFB7C2CF),
        );

    return StreamBuilder<HomeState>(
      stream: viewModel.state,
      initialData: const HomeState(),
      builder: (context, snapshot) {
        final state = snapshot.data ?? const HomeState();
        final buttonLabel = state.isStarting ? 'Starting...' : 'Start Adventure';

        return Container(
          color: const Color(0xFF0B0C10),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('HearO', style: headline),
                const SizedBox(height: 12),
                Text(
                  '음감을 기르는 서바이벌 리듬 게임\n몬스터의 노트를 캐치하고 하트를 지켜라.',
                  style: bodyStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: state.isStarting
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
                const SizedBox(height: 16),
                Text(
                  '공격은 동일한 음표를 입력하고\n오답은 알림 후 몬스터가 분노합니다.',
                  style: bodyStyle?.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

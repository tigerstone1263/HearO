import 'package:flutter/material.dart';

class EndOverlay extends StatelessWidget {
  const EndOverlay({
    super.key,
    required this.title,
    required this.score,
    required this.onRestart,
  });

  final String title;
  final int score;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B0C10).withOpacity(0.8),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFE1E6ED),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Score $score',
            style: const TextStyle(
              color: Color(0xFFB7C2CF),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRestart,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2F3D4E),
              foregroundColor: const Color(0xFFE1E6ED),
            ),
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}

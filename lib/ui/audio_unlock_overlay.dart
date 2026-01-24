import 'package:flutter/material.dart';

import '../game/hear_o_game.dart';

class AudioUnlockOverlay extends StatelessWidget {
  const AudioUnlockOverlay({super.key, required this.game});

  final HearOGame game;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        game.unlockAudio();
      },
      child: Container(
        color: const Color(0xFF0B0C10).withOpacity(0.75),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Tap to enable audio',
              style: TextStyle(
                color: Color(0xFFE1E6ED),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Then press A/S/D/F/G/H/J to play notes.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFB7C2CF),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

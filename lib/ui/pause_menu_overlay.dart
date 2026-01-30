import 'package:flutter/material.dart';

class PauseMenuOverlay extends StatelessWidget {
  const PauseMenuOverlay({
    super.key,
    required this.onResume,
    required this.onHome,
    required this.onSettings,
  });

  final VoidCallback onResume;
  final VoidCallback onHome;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.65),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Card(
          color: const Color(0xFF111E14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Game Paused',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                _actionButton(
                  context,
                  label: '계속하기',
                  icon: Icons.play_arrow_rounded,
                  onTap: onResume,
                ),
                const SizedBox(height: 12),
                _actionButton(
                  context,
                  label: '홈으로 나가기',
                  icon: Icons.home_rounded,
                  onTap: onHome,
                ),
                const SizedBox(height: 12),
                _actionButton(
                  context,
                  label: '설정',
                  icon: Icons.settings_rounded,
                  onTap: onSettings,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white70),
        label: Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white24),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

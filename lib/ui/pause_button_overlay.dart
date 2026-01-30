import 'package:flutter/material.dart';

class PauseButtonOverlay extends StatelessWidget {
  const PauseButtonOverlay({super.key, required this.onPause});

  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 16, top: 16),
          child: ElevatedButton(
            onPressed: onPause,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Colors.black54,
              minimumSize: const Size(48, 48),
              padding: const EdgeInsets.all(0),
            ),
            child: const Icon(
              Icons.pause_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

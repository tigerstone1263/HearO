import 'package:flutter/material.dart';

class ForestBackground extends StatelessWidget {
  const ForestBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1E4726),
                Color(0xFF112215),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0.28,
            child: Image.asset(
              'assets/images/tigerstone4_A.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.05),
                  Colors.black.withOpacity(0.55),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

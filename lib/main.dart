import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/hear_o_game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const HearOApp());
}

class HearOApp extends StatelessWidget {
  const HearOApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HearO',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF0B0C10),
        body: SafeArea(
          child: Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: GameWidget(game: HearOGame()),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/hear_o_game.dart';
import 'ui/audio_unlock_overlay.dart';
import 'ui/end_overlay.dart';
import 'ui/home_overlay.dart';
import 'ui/splash_overlay.dart';

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
    final game = HearOGame();

    return MaterialApp(
      title: 'HearO',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF0B0C10),
        body: SafeArea(
          child: Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: GameWidget<HearOGame>(
                game: game,
                overlayBuilderMap: {
                  HearOGame.splashOverlayId: (context, game) => SplashOverlay(
                        onComplete: () => (game as HearOGame).showHomeOverlay(),
                      ),
                  HearOGame.homeOverlayId: (context, game) => HomeOverlay(
                        onStart: () => (game as HearOGame).startGame(),
                      ),
                  HearOGame.audioOverlayId: (context, game) => AudioUnlockOverlay(
                        game: game,
                      ),
                  HearOGame.gameOverOverlayId: (context, game) => EndOverlay(
                        title: 'Game Over',
                        score: game.score,
                        onRestart: game.restart,
                      ),
                  HearOGame.clearOverlayId: (context, game) => EndOverlay(
                        title: 'Clear!',
                        score: game.score,
                        onRestart: game.restart,
                      ),
                },
                initialActiveOverlays: const [HearOGame.splashOverlayId],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

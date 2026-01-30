import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hear_o/core/di/di_setup.dart';
import 'package:hear_o/core/router/route_names.dart';
import 'package:hear_o/core/router/router.dart';
import 'package:hear_o/env.dart';
import 'package:hear_o/presentation/main/main_view.dart';

import 'game/hear_o_game.dart';
import 'ui/end_overlay.dart';
import 'ui/forest_background.dart';
import 'ui/pause_button_overlay.dart';
import 'ui/pause_menu_overlay.dart';
import 'ui/splash_overlay.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      // SystemUiMode.edgeToEdge,
      overlays:[]
  );

  await EnvConstants.initialize(Environment.dev);
  await diSetUp();

  runApp(const MainView());
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ForestBackground(),
                GameWidget<HearOGame>(
                  game: game,
                  overlayBuilderMap: {
                    HearOGame.splashOverlayId: (context, game) => SplashOverlay(
                          onComplete: () => (game as HearOGame).startGame(),
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
                    HearOGame.pauseButtonOverlayId: (context, game) =>
                        PauseButtonOverlay(
                          onPause: () => (game as HearOGame).pauseGame(),
                        ),
                    HearOGame.pauseMenuOverlayId: (context, game) =>
                        PauseMenuOverlay(
                          onResume: () => (game as HearOGame).resumeGame(),
                          onHome: () {
                            (game as HearOGame).returnToHomeFromPause();
                            getIt<AppRouterService>()
                                .router
                                .go(RouteNames.root);
                          },
                          onSettings: () {
                            final gameRef = game as HearOGame;
                            showDialog<void>(
                              context: context,
                              builder: (context) {
                                var volume = gameRef.volume;
                                return StatefulBuilder(
                                  builder: (context, setState) => AlertDialog(
                                    title: const Text('설정'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('효과음 볼륨'),
                                        Slider(
                                          value: volume,
                                          onChanged: (value) {
                                            setState(() => volume = value);
                                            gameRef.setVolume(value);
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('닫기'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                  },
                  initialActiveOverlays: const [HearOGame.splashOverlayId],
                ),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }
}

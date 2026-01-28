import 'package:flutter/material.dart';

import '../presentation/splash/splash_screen.dart';
import '../presentation/splash/splash_view_model.dart';

class SplashOverlay extends StatefulWidget {
  const SplashOverlay({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<SplashOverlay> createState() => _SplashOverlayState();
}

class _SplashOverlayState extends State<SplashOverlay> {
  late final SplashViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SplashViewModel(onComplete: widget.onComplete);
    _viewModel.start();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(viewModel: _viewModel);
  }
}

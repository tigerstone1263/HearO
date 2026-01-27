import 'package:flutter/material.dart';

import '../presentation/home/home_screen.dart';
import '../presentation/home/home_view_model.dart';

class HomeOverlay extends StatefulWidget {
  const HomeOverlay({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  State<HomeOverlay> createState() => _HomeOverlayState();
}

class _HomeOverlayState extends State<HomeOverlay> {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel(onStart: widget.onStart);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen(viewModel: _viewModel);
  }
}

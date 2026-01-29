

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hear_o/core/di/di_setup.dart';
import 'package:hear_o/core/router/route_names.dart';
import 'package:hear_o/core/router/router.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouterService>();
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            context.go(RouteNames.game);
          }, child: const Text('test'))
        ],
      ),
    );
  }
}



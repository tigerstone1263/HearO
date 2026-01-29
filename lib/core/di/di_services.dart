


import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hear_o/core/analytics/amplitude_analytics_helper.dart';
import 'package:hear_o/core/di/di_setup.dart';
import 'package:hear_o/env.dart';
import 'package:hear_o/core/router/router.dart';

Future<void> diServiceSetUp()async {
  getIt.registerSingleton<AppRouterService>(AppRouterService());

  getIt.registerSingleton<Amplitude>(Amplitude(Configuration(
      apiKey: EnvConstants.amplitudeApiKey
  ))
  );
  getIt.registerSingleton<FirebaseAnalytics>(FirebaseAnalytics.instance);
}
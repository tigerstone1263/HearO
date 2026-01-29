import 'package:flutter/material.dart';
import 'package:hear_o/core/analytics/analytics_event_names.dart';
import 'package:hear_o/core/analytics/unified_analytics_helper.dart';
import 'package:hear_o/core/di/di_setup.dart';
import 'package:hear_o/core/router/router.dart';
import 'package:hear_o/core/ui/app_bar_theme.dart';
import 'package:hear_o/core/ui/colors.dart';
import 'package:hear_o/core/ui/scroll_behavior.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    UnifiedAnalyticsHelper.logEvent(
      name: AnalyticsEventNames.appOpen,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    UnifiedAnalyticsHelper.logEvent(
      name: AnalyticsEventNames.appTerminate,
    );
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        UnifiedAnalyticsHelper.logEvent(
          name: AnalyticsEventNames.appForeground,
        );
        break;
      case AppLifecycleState.paused:
        UnifiedAnalyticsHelper.logEvent(
          name: AnalyticsEventNames.appBackground,
        );
        break;
      default:
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(listenable: getIt<AppRouterService>(), builder: (_, __){
      return MaterialApp.router(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling,),
            child: child!,
          );
        },
        routerConfig: getIt<AppRouterService>().router,
        debugShowCheckedModeBanner: false,
        title: 'HearO',
        scrollBehavior: MyBehavior(),
        theme: ThemeData(
          fontFamily: 'pretendard',
          // primarySwatch: Colors.blue,
          // brightness: Brightness.light,
          // cardColor: Colors.white,
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
            primary: AppColors.primary,
          ),
          scaffoldBackgroundColor: AppColors.white,
          appBarTheme: MyAppBarTheme(),
          cardTheme: CardThemeData(color: Colors.white),
          tabBarTheme: TabBarThemeData(
            dividerColor: Colors.transparent,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        // themeMode: ThemeMode.system,
      );
    });
  }
}
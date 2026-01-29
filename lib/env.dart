import 'package:flutter_dotenv/flutter_dotenv.dart';


abstract class EnvConstants {
  static late final Map<String, String> _config;

  static Future<void> initialize(Environment env) async {
    await dotenv.load(fileName: ".env");
    switch (env) {

      case Environment.dev:
        _config = {
          _ConfigKeys.api: dotenv.get('DEV'),
          _ConfigKeys.amplitudeApiKey: dotenv.get('AMPLITUDE_API_KEY_DEV', fallback: 'dev-key-not-set'),
          _ConfigKeys.clarityApiKey: dotenv.get('CLARITY_API_KEY_DEV', fallback: 'dev-key-not-set'),
          _ConfigKeys.kakaoNativeAppKey: dotenv.get('KAKAO_NATIVE_APP_KEY'),
        };
        break;
      case Environment.prod:
        _config = {
          _ConfigKeys.api: dotenv.get('PROD'),
          _ConfigKeys.amplitudeApiKey: dotenv.get('AMPLITUDE_API_KEY'),
          _ConfigKeys.kakaoNativeAppKey: dotenv.get('KAKAO_NATIVE_APP_KEY'),
          _ConfigKeys.clarityApiKey: dotenv.get('CLARITY_API_KEY'),
        };
        break;
    }
  }

  static String get api => _config[_ConfigKeys.api]!;
  static String get amplitudeApiKey => _config[_ConfigKeys.amplitudeApiKey]!;
  static String get clarityApiKey => _config[_ConfigKeys.clarityApiKey]!;
  static String get kakaoNativeAppKey => _config[_ConfigKeys.kakaoNativeAppKey]!;
}

abstract class _ConfigKeys {
  static const api = "API";
  static const amplitudeApiKey = "AMPLITUDE_API_KEY";
  static const kakaoNativeAppKey = "KAKAO_NATIVE_APP_KEY";
  static const clarityApiKey = "CLARITY_API_KEY";
}

enum Environment { dev, prod }
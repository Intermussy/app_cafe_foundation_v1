import 'dart:developer' as dev;
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AppEnv { dev, staging, prod }

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  AppConfig._internal();
  factory AppConfig() => _instance;

  static AppEnv _currentEnv = AppEnv.dev;
  static Future<void> init({AppEnv? env}) async {
    _currentEnv = env ?? AppEnv.dev;

    final fileName = _envFileNameFor(_currentEnv);
    dev.log('Loading environment from $fileName');
    await dotenv.load(fileName: fileName);
  }

  AppEnv get environment => _currentEnv;

  //TODO:Common configuration getters
  String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://default.api.local';
  bool get enableLogging =>
      dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true';

  //TODO: Helper
  static String _envFileNameFor(AppEnv env) {
    switch (env) {
      case AppEnv.dev:
        return '.env.dev';
      case AppEnv.staging:
        return '.env.staging';
      case AppEnv.prod:
        return '.env.staging';
    }
  }

  //TODO: Quick Checkers
  bool get isDev => _currentEnv == AppEnv.dev;
  bool get isStaging => _currentEnv == AppEnv.staging;
  bool get isProd => _currentEnv == AppEnv.prod;
}

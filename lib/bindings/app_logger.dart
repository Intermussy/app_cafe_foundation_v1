import 'dart:developer' as dev;

import 'package:app_foundation/bindings/app_config.dart';

enum LogLevel { debug, info, warning, error }

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();

  AppLogger._internal();
  factory AppLogger() => _instance;

  LogLevel minLevel = LogLevel.debug;

  final config = AppConfig();
  void log(String message, {LogLevel level = LogLevel.debug, Object? error}) {
    if (config.isProd || !config.enableLogging) return;

    if (level.index >= minLevel.index) {
      final prefix = '[${level.name.toUpperCase()}]';
      dev.log('$prefix $message', error: error);
    }
  }

  void debug(String msg) => log(msg, level: LogLevel.debug);
  void info(String msg) => log(msg, level: LogLevel.info);
  void warn(String msg) => log(msg, level: LogLevel.warning);
  void error(String msg, [Object? e]) =>
      log(msg, level: LogLevel.error, error: e);
}

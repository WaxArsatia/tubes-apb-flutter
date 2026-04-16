import 'package:flutter/foundation.dart';

enum AppEnvironment { dev, staging, prod }

final class AppEnv {
  AppEnv._();

  static final AppEnvironment environment = _resolveEnvironment();

  static final String baseUrl = _resolveBaseUrl();

  static AppEnvironment _resolveEnvironment() {
    const rawEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

    return switch (rawEnv) {
      'prod' => AppEnvironment.prod,
      'staging' => AppEnvironment.staging,
      _ => AppEnvironment.dev,
    };
  }

  static String _resolveBaseUrl() {
    const overridden = String.fromEnvironment('API_BASE_URL');
    if (overridden.isNotEmpty) {
      return overridden;
    }

    return switch (environment) {
      AppEnvironment.dev => _resolveDevBaseUrl(),
      AppEnvironment.staging => 'https://staging.example.com',
      AppEnvironment.prod => 'https://api.example.com',
    };
  }

  static String _resolveDevBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'http://10.0.2.2:3000',
      TargetPlatform.iOS => 'http://127.0.0.1:3000',
      TargetPlatform.macOS ||
      TargetPlatform.windows ||
      TargetPlatform.linux ||
      TargetPlatform.fuchsia => 'http://localhost:3000',
    };
  }
}

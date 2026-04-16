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
    return switch (environment) {
      AppEnvironment.dev => _resolveDevBaseUrl(),
      AppEnvironment.staging => _resolveEnvBaseUrl(AppEnvironment.staging),
      AppEnvironment.prod => _resolveEnvBaseUrl(AppEnvironment.prod),
    };
  }

  static String _resolveEnvBaseUrl(AppEnvironment environment) {
    const configuredBaseUrl = String.fromEnvironment('API_BASE_URL');
    if (configuredBaseUrl.isNotEmpty) {
      return configuredBaseUrl;
    }

    throw StateError(
      'Missing API_BASE_URL for ${environment.name}. '
      'Set --dart-define=API_BASE_URL=<your_api_base_url>.',
    );
  }

  static String _resolveDevBaseUrl() {
    const configuredBaseUrl = String.fromEnvironment('API_BASE_URL');
    if (configuredBaseUrl.isNotEmpty) {
      return configuredBaseUrl;
    }

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

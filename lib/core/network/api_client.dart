import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_apb_flutter/core/config/app_env.dart';
import 'package:tubes_apb_flutter/core/session/token_storage.dart';

final apiClientProvider = Provider<Dio>((ref) {
  final accessTokenStore = ref.watch(accessTokenStoreProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: AppEnv.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: const {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final skipAuth = options.extra['skipAuth'] == true;
        final accessToken = accessTokenStore.accessToken;

        if (!skipAuth && accessToken != null && accessToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }

        handler.next(options);
      },
    ),
  );

  return dio;
});

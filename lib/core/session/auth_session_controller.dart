import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_apb_flutter/core/error/api_exception.dart';
import 'package:tubes_apb_flutter/core/session/auth_session_state.dart';
import 'package:tubes_apb_flutter/core/session/token_storage.dart';
import 'package:tubes_apb_flutter/features/auth/data/models/auth_models.dart';
import 'package:tubes_apb_flutter/features/auth/data/repositories/auth_repository.dart';

final authSessionControllerProvider =
    NotifierProvider<AuthSessionController, AuthSessionState>(
      AuthSessionController.new,
    );

class AuthSessionController extends Notifier<AuthSessionState> {
  late final AuthRepository _authRepository;
  late final TokenStorage _tokenStorage;
  late final AccessTokenStore _accessTokenStore;

  @override
  AuthSessionState build() {
    _authRepository = ref.read(authRepositoryProvider);
    _tokenStorage = ref.read(tokenStorageProvider);
    _accessTokenStore = ref.read(accessTokenStoreProvider);

    return const AuthSessionState.checking();
  }

  Future<void> restoreSession() async {
    state = const AuthSessionState.checking();

    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _setUnauthenticated();
      return;
    }

    try {
      final tokenBundle = await _authRepository.refreshToken(refreshToken);
      await _applyTokenBundle(tokenBundle, fetchProfile: true);
    } catch (_) {
      await _setUnauthenticated(clearRefreshToken: true);
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    final tokenBundle = await _authRepository.login(
      AuthLoginRequest(email: email, password: password),
    );

    await _applyTokenBundle(tokenBundle, fetchProfile: true);
  }

  Future<bool> refreshAccessToken() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _setUnauthenticated(clearRefreshToken: true);
      return false;
    }

    try {
      final tokenBundle = await _authRepository.refreshToken(refreshToken);
      _accessTokenStore.setAccessToken(tokenBundle.accessToken);
      await _tokenStorage.writeRefreshToken(tokenBundle.refreshToken);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        accessToken: tokenBundle.accessToken,
      );

      return true;
    } catch (_) {
      await _setUnauthenticated(clearRefreshToken: true);
      return false;
    }
  }

  Future<T> withRefreshRetry<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on ApiException catch (error) {
      if (error.statusCode != 401) {
        rethrow;
      }

      final refreshed = await refreshAccessToken();
      if (!refreshed) {
        rethrow;
      }

      return action();
    }
  }

  Future<void> refreshProfile() async {
    final user = await withRefreshRetry(_authRepository.me);

    state = state.copyWith(user: user, status: AuthStatus.authenticated);
  }

  Future<void> logout({bool callRemote = true}) async {
    final refreshToken = await _tokenStorage.readRefreshToken();

    if (callRemote && refreshToken != null && refreshToken.isNotEmpty) {
      try {
        await _authRepository.logout(refreshToken);
      } catch (_) {
        // Ignore remote logout failure. Local invalidation still runs.
      }
    }

    await _setUnauthenticated(clearRefreshToken: true);
  }

  Future<void> _applyTokenBundle(
    TokenBundle tokenBundle, {
    required bool fetchProfile,
  }) async {
    _accessTokenStore.setAccessToken(tokenBundle.accessToken);
    await _tokenStorage.writeRefreshToken(tokenBundle.refreshToken);

    AuthMeData? profile;
    if (fetchProfile) {
      try {
        profile = await _authRepository.me();
      } on ApiException {
        profile = null;
      }
    }

    state = AuthSessionState.authenticated(
      user: profile,
      accessToken: tokenBundle.accessToken,
    );
  }

  Future<void> _setUnauthenticated({bool clearRefreshToken = false}) async {
    _accessTokenStore.clear();

    if (clearRefreshToken) {
      await _tokenStorage.clearRefreshToken();
    }

    state = const AuthSessionState.unauthenticated();
  }
}

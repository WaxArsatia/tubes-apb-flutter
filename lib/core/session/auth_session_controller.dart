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
  Future<bool>? _refreshFuture;

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
    } catch (error) {
      final clearRefreshToken = _shouldClearRefreshToken(error);
      await _setUnauthenticated(clearRefreshToken: clearRefreshToken);

      if (!clearRefreshToken) {
        rethrow;
      }
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    final tokenBundle = await _authRepository.login(
      AuthLoginRequest(email: email, password: password),
    );

    await _applyTokenBundle(tokenBundle, fetchProfile: true);
  }

  Future<bool> refreshAccessToken() {
    return _runSharedRefresh();
  }

  Future<void> markUnauthenticated({bool clearRefreshToken = false}) {
    return _setUnauthenticated(clearRefreshToken: clearRefreshToken);
  }

  Future<bool> _doRefresh() async {
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
    } catch (error) {
      final clearRefreshToken = _shouldClearRefreshToken(error);
      await _setUnauthenticated(clearRefreshToken: clearRefreshToken);

      if (!clearRefreshToken) {
        rethrow;
      }

      return false;
    }
  }

  Future<bool> _runSharedRefresh() {
    final inFlightRefresh = _refreshFuture;
    if (inFlightRefresh != null) {
      return inFlightRefresh;
    }

    final refreshFuture = _doRefresh();
    _refreshFuture = refreshFuture;

    return refreshFuture.whenComplete(() {
      if (identical(_refreshFuture, refreshFuture)) {
        _refreshFuture = null;
      }
    });
  }

  Future<T> withRefreshRetry<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on ApiException catch (error) {
      if (error.statusCode != 401) {
        rethrow;
      }

      final refreshed = await _runSharedRefresh();
      if (!refreshed) {
        rethrow;
      }

      return await action();
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
    if (!fetchProfile) {
      final currentUser = state.user;
      if (currentUser == null) {
        throw StateError('Cannot authenticate session without a user profile.');
      }

      _accessTokenStore.setAccessToken(tokenBundle.accessToken);
      await _tokenStorage.writeRefreshToken(tokenBundle.refreshToken);

      state = AuthSessionState.authenticated(
        user: currentUser,
        accessToken: tokenBundle.accessToken,
      );
      return;
    }

    _accessTokenStore.setAccessToken(tokenBundle.accessToken);

    try {
      final profile = await _authRepository.me();

      await _tokenStorage.writeRefreshToken(tokenBundle.refreshToken);

      state = AuthSessionState.authenticated(
        user: profile,
        accessToken: tokenBundle.accessToken,
      );
    } on ApiException catch (error) {
      _accessTokenStore.clear();

      if (error.statusCode == 401) {
        await _setUnauthenticated(clearRefreshToken: true);
      }

      rethrow;
    } catch (_) {
      _accessTokenStore.clear();
      rethrow;
    }
  }

  bool _shouldClearRefreshToken(Object error) {
    if (error is! ApiException) {
      return false;
    }

    final statusCode = error.statusCode;
    if (statusCode == 400 || statusCode == 401) {
      return true;
    }

    final message = error.message.toLowerCase();
    return message.contains('invalid_grant') ||
        message.contains('invalid refresh token') ||
        (message.contains('refresh token') && message.contains('expired'));
  }

  Future<void> _setUnauthenticated({bool clearRefreshToken = false}) async {
    _accessTokenStore.clear();

    if (clearRefreshToken) {
      await _tokenStorage.clearRefreshToken();
    }

    state = const AuthSessionState.unauthenticated();
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tubes_apb_flutter/core/session/auth_session_controller.dart';
import 'package:tubes_apb_flutter/core/session/auth_session_state.dart';
import 'package:tubes_apb_flutter/core/session/token_storage.dart';
import 'package:tubes_apb_flutter/features/auth/data/models/auth_models.dart';
import 'package:tubes_apb_flutter/features/auth/data/repositories/auth_repository.dart';

void main() {
  test(
    'restoreSession returns unauthenticated when refresh token missing',
    () async {
      final tokenStorage = _FakeTokenStorage();
      final repository = _FakeAuthRepository();

      final container = ProviderContainer(
        overrides: [
          tokenStorageProvider.overrideWithValue(tokenStorage),
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(authSessionControllerProvider.notifier)
          .restoreSession();

      final state = container.read(authSessionControllerProvider);
      expect(state.status, AuthStatus.unauthenticated);
    },
  );

  test('restoreSession refreshes token and loads current user', () async {
    final tokenStorage = _FakeTokenStorage(initialRefreshToken: 'refresh-1');
    final repository = _FakeAuthRepository(
      refreshResponse: const TokenBundle(
        accessToken: 'access-new',
        refreshToken: 'refresh-new',
        tokenType: 'Bearer',
        expiresIn: 3600,
      ),
      meResponse: const AuthMeData(
        id: 'a0f72af4-396f-4e30-8f65-2e3b2f4f1111',
        firstName: 'Larasati',
        lastName: 'Puan',
        email: 'larasati@mail.com',
        profilePicture: null,
      ),
    );

    final container = ProviderContainer(
      overrides: [
        tokenStorageProvider.overrideWithValue(tokenStorage),
        authRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(authSessionControllerProvider.notifier)
        .restoreSession();

    final state = container.read(authSessionControllerProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.user?.email, 'larasati@mail.com');
    expect(state.accessToken, 'access-new');
    expect(tokenStorage.refreshToken, 'refresh-new');
    expect(container.read(accessTokenStoreProvider).accessToken, 'access-new');
  });
}

class _FakeTokenStorage implements TokenStorage {
  _FakeTokenStorage({String? initialRefreshToken})
    : refreshToken = initialRefreshToken;

  String? refreshToken;

  @override
  Future<void> clearRefreshToken() async {
    refreshToken = null;
  }

  @override
  Future<String?> readRefreshToken() async => refreshToken;

  @override
  Future<void> writeRefreshToken(String token) async {
    refreshToken = token;
  }
}

class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository({TokenBundle? refreshResponse, AuthMeData? meResponse})
    : _refreshResponse =
          refreshResponse ??
          const TokenBundle(
            accessToken: 'access-default',
            refreshToken: 'refresh-default',
            tokenType: 'Bearer',
            expiresIn: 3600,
          ),
      _meResponse =
          meResponse ??
          const AuthMeData(
            id: 'f92cd7a5-70cf-42ec-b44f-50315c011111',
            firstName: 'Default',
            lastName: 'User',
            email: 'default@mail.com',
            profilePicture: null,
          ),
      super(_MockDio());

  final TokenBundle _refreshResponse;
  final AuthMeData _meResponse;

  @override
  Future<TokenBundle> refreshToken(String refreshToken) async =>
      _refreshResponse;

  @override
  Future<AuthMeData> me() async => _meResponse;
}

class _MockDio extends Mock implements Dio {}

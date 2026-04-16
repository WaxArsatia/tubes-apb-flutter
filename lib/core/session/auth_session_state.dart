import 'package:tubes_apb_flutter/features/auth/data/models/auth_models.dart';

enum AuthStatus { checking, authenticated, unauthenticated }

class AuthSessionState {
  const AuthSessionState({required this.status, this.user, this.accessToken});

  const AuthSessionState.checking()
    : status = AuthStatus.checking,
      user = null,
      accessToken = null;

  const AuthSessionState.unauthenticated()
    : status = AuthStatus.unauthenticated,
      user = null,
      accessToken = null;

  const AuthSessionState.authenticated({
    required this.user,
    required this.accessToken,
  }) : status = AuthStatus.authenticated;

  final AuthStatus status;
  final AuthMeData? user;
  final String? accessToken;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isChecking => status == AuthStatus.checking;

  AuthSessionState copyWith({
    AuthStatus? status,
    AuthMeData? user,
    bool clearUser = false,
    String? accessToken,
    bool clearAccessToken = false,
  }) {
    return AuthSessionState(
      status: status ?? this.status,
      user: clearUser ? null : user ?? this.user,
      accessToken: clearAccessToken ? null : accessToken ?? this.accessToken,
    );
  }
}

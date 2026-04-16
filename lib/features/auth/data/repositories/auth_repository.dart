import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_apb_flutter/core/error/api_exception.dart';
import 'package:tubes_apb_flutter/core/network/api_client.dart';
import 'package:tubes_apb_flutter/core/network/api_exception_parser.dart';
import 'package:tubes_apb_flutter/features/auth/data/models/auth_models.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(apiClientProvider)),
);

class AuthRepository {
  AuthRepository(this._dio);

  final Dio _dio;

  Future<AuthRegisterData> register(AuthRegisterRequest request) async {
    try {
      final response = await _dio.post<dynamic>(
        '/auth/register',
        data: request.toJson(),
        options: Options(extra: const {'skipAuth': true}),
      );

      return AuthRegisterSuccess.fromJson(_asMap(response.data)).data;
    } on DioException catch (error) {
      throw parseDioException(error);
    }
  }

  Future<TokenBundle> login(AuthLoginRequest request) async {
    try {
      final response = await _dio.post<dynamic>(
        '/auth/login',
        data: request.toJson(),
        options: Options(extra: const {'skipAuth': true}),
      );

      return AuthLoginSuccess.fromJson(_asMap(response.data)).data;
    } on DioException catch (error) {
      throw parseDioException(error);
    }
  }

  Future<TokenBundle> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post<dynamic>(
        '/auth/refresh-token',
        data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
        options: Options(extra: const {'skipAuth': true}),
      );

      return AuthLoginSuccess.fromJson(_asMap(response.data)).data;
    } on DioException catch (error) {
      throw parseDioException(error);
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post<dynamic>(
        '/auth/logout',
        data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
        options: Options(extra: const {'skipAuth': true}),
      );
    } on DioException catch (error) {
      throw parseDioException(error);
    }
  }

  Future<AuthMeData> me() async {
    try {
      final response = await _dio.get<dynamic>('/auth/me');
      return AuthMeSuccess.fromJson(_asMap(response.data)).data;
    } on DioException catch (error) {
      throw parseDioException(error);
    }
  }

  Future<ForgotPasswordData> forgotPassword(String email) async {
    try {
      final response = await _dio.post<dynamic>(
        '/auth/forgot-password',
        data: ForgotPasswordRequest(email: email).toJson(),
        options: Options(extra: const {'skipAuth': true}),
      );

      return ForgotPasswordSuccess.fromJson(_asMap(response.data)).data;
    } on DioException catch (error) {
      throw parseDioException(error);
    }
  }

  Future<VerifyOtpData> verifyOtp({
    required String email,
    required int otp,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/auth/verify-otp',
        data: VerifyOtpRequest(email: email, otp: otp).toJson(),
        options: Options(extra: const {'skipAuth': true}),
      );

      return VerifyOtpSuccess.fromJson(_asMap(response.data)).data;
    } on DioException catch (error) {
      throw parseDioException(error);
    }
  }

  Future<ChangePasswordData> changePassword(
    ChangePasswordRequest request,
  ) async {
    try {
      final response = await _dio.post<dynamic>(
        '/auth/change-password',
        data: request.toJson(),
        options: Options(extra: const {'skipAuth': true}),
      );

      return ChangePasswordSuccess.fromJson(_asMap(response.data)).data;
    } on DioException catch (error) {
      throw parseDioException(error);
    }
  }

  Future<ChangePasswordData> changePasswordAuthenticated(
    AuthenticatedChangePasswordRequest request,
  ) async {
    try {
      final response = await _dio.patch<dynamic>(
        '/auth/change-password',
        data: request.toJson(),
      );

      return ChangePasswordSuccess.fromJson(_asMap(response.data)).data;
    } on DioException catch (error) {
      throw parseDioException(error);
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    throw const ApiException(message: 'Invalid response payload from server.');
  }
}

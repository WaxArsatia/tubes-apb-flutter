import 'package:dio/dio.dart';
import 'package:tubes_apb_flutter/core/error/api_exception.dart';

ApiException parseDioException(DioException error) {
  final response = error.response;
  final statusCode = response?.statusCode;
  final data = _asNormalizedMap(response?.data);

  if (data != null) {
    final rawMessage = data['message'];
    final message = rawMessage is String
        ? rawMessage
        : rawMessage?.toString() ?? _fallbackMessage(error);

    final parsedFieldErrors = <String, List<String>>{};
    final rawErrors = data['errors'];

    if (rawErrors is Map) {
      for (final entry in rawErrors.entries) {
        final key = entry.key.toString();
        final value = entry.value;
        if (value is List) {
          parsedFieldErrors[key] = value.map((e) => e.toString()).toList();
        }
      }
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      fieldErrors: parsedFieldErrors,
    );
  }

  return ApiException(message: _fallbackMessage(error), statusCode: statusCode);
}

Map<String, dynamic>? _asNormalizedMap(dynamic data) {
  if (data is Map<String, dynamic>) {
    return data;
  }

  if (data is Map) {
    return data.map((key, value) => MapEntry(key.toString(), value));
  }

  return null;
}

String _fallbackMessage(DioException error) {
  return switch (error.type) {
    DioExceptionType.connectionTimeout =>
      'Connection timeout. Please try again.',
    DioExceptionType.sendTimeout => 'Request timeout. Please try again.',
    DioExceptionType.receiveTimeout => 'Server timeout. Please try again.',
    DioExceptionType.connectionError =>
      'Unable to reach server. Check your connection.',
    DioExceptionType.cancel => 'Request cancelled.',
    _ => 'Something went wrong. Please try again.',
  };
}

import 'package:dio/dio.dart';
import 'package:tubes_apb_flutter/core/error/api_exception.dart';

ApiException parseDioException(DioException error) {
  final response = error.response;
  final statusCode = response?.statusCode;

  if (response?.data is Map<String, dynamic>) {
    final data = response!.data as Map<String, dynamic>;
    final message = (data['message'] as String?) ?? _fallbackMessage(error);

    final parsedFieldErrors = <String, List<String>>{};
    final rawErrors = data['errors'];

    if (rawErrors is Map<String, dynamic>) {
      for (final entry in rawErrors.entries) {
        final value = entry.value;
        if (value is List) {
          parsedFieldErrors[entry.key] = value
              .map((e) => e.toString())
              .toList();
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

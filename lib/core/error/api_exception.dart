class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.fieldErrors = const {},
  });

  final String message;
  final int? statusCode;
  final Map<String, List<String>> fieldErrors;

  bool get hasFieldErrors => fieldErrors.isNotEmpty;

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, message: $message, fieldErrors: $fieldErrors)';
  }
}

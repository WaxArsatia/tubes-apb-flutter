import 'package:flutter/material.dart';
import 'package:tubes_apb_flutter/core/error/api_exception.dart';

void showErrorSnackBar(BuildContext context, Object error) {
  final message = error is ApiException
      ? error.message
      : 'Something went wrong. Please try again.';

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

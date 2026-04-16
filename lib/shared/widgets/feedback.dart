import 'package:flutter/material.dart';
import 'package:tubes_apb_flutter/core/error/api_exception.dart';

void _showSnackBar(BuildContext context, Widget content) {
  if (!context.mounted) {
    return;
  }

  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) {
    return;
  }

  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(SnackBar(content: content));
}

void showErrorSnackBar(BuildContext context, Object error) {
  final message = error is ApiException
      ? error.message
      : 'Something went wrong. Please try again.';

  _showSnackBar(context, Text(message));
}

void showSuccessSnackBar(BuildContext context, String message) {
  _showSnackBar(context, Text(message));
}

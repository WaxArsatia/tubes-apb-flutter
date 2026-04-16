final class Validators {
  Validators._();

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? requiredField(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }

    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredField(value, fieldName: 'Email');
    if (requiredError != null) {
      return requiredError;
    }

    if (!_emailRegex.hasMatch(value!.trim())) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  static String? password(String? value) {
    final requiredError = requiredField(value, fieldName: 'Password');
    if (requiredError != null) {
      return requiredError;
    }

    if (value!.length < 8) {
      return 'Password must be at least 8 characters.';
    }

    return null;
  }

  static String? confirmPassword(
    String? value, {
    required String against,
    String fieldName = 'Confirmation password',
  }) {
    final requiredError = requiredField(value, fieldName: fieldName);
    if (requiredError != null) {
      return requiredError;
    }

    if (value != against) {
      return 'Passwords do not match.';
    }

    return null;
  }
}

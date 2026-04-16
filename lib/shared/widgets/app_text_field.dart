import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    super.key,
    this.controller,
    this.keyboardType,
    this.validator,
    this.textInputAction,
    this.obscureText = false,
    this.onChanged,
    this.readOnly = false,
    this.suffix,
    this.onTap,
    this.errorText,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.inputFormatters,
    this.onFieldSubmitted,
  });

  final String label;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final Widget? suffix;
  final VoidCallback? onTap;
  final String? errorText;
  final int? maxLength;
  final TextAlign textAlign;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      validator: validator,
      textInputAction: textInputAction,
      obscureText: obscureText,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnly,
      onTap: onTap,
      maxLength: maxLength,
      textAlign: textAlign,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffix,
        errorText: errorText,
        counterText: '',
      ),
    );
  }
}

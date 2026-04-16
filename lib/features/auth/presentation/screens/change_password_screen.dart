import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tubes_apb_flutter/app/router/route_paths.dart';
import 'package:tubes_apb_flutter/core/error/api_exception.dart';
import 'package:tubes_apb_flutter/core/utils/validators.dart';
import 'package:tubes_apb_flutter/features/auth/data/models/auth_models.dart';
import 'package:tubes_apb_flutter/features/auth/data/repositories/auth_repository.dart';
import 'package:tubes_apb_flutter/features/auth/presentation/widgets/auth_header.dart';
import 'package:tubes_apb_flutter/shared/widgets/app_primary_button.dart';
import 'package:tubes_apb_flutter/shared/widgets/app_text_field.dart';
import 'package:tubes_apb_flutter/shared/widgets/feedback.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({
    required this.email,
    required this.otp,
    super.key,
  });

  final String email;
  final String otp;

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  Map<String, String> _fieldErrors = const {};

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final otpInt = int.tryParse(widget.otp);
    if (otpInt == null) {
      showErrorSnackBar(
        context,
        const FormatException('OTP is invalid. Please request a new code.'),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _fieldErrors = const {};
    });

    final repository = ref.read(authRepositoryProvider);

    try {
      await repository.changePassword(
        ChangePasswordRequest(
          email: widget.email,
          otp: otpInt,
          newPassword: _newPasswordController.text,
          confirmationPassword: _confirmPasswordController.text,
        ),
      );

      if (!mounted) {
        return;
      }

      context.go(RoutePaths.changePasswordSuccess);
    } catch (error) {
      if (error is ApiException) {
        final mappedErrors = <String, String>{};
        for (final entry in error.fieldErrors.entries) {
          if (entry.value.isNotEmpty) {
            mappedErrors[entry.key] = entry.value.first;
          }
        }

        setState(() {
          _fieldErrors = mappedErrors;
        });
      }

      if (mounted) {
        showErrorSnackBar(context, error);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 18, 32, 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const AuthHeader(
                  title: 'Create New Password',
                  subtitle: 'Replace the password with a new one.',
                ),
                const SizedBox(height: 36),
                AppTextField(
                  label: 'New Password',
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  validator: Validators.password,
                  errorText: _fieldErrors['newPassword'],
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                    icon: Icon(
                      _obscureNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  validator: (value) => Validators.confirmPassword(
                    value,
                    against: _newPasswordController.text,
                    fieldName: 'Confirmation password',
                  ),
                  errorText: _fieldErrors['confirmationPassword'],
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AppPrimaryButton(
                  label: 'Create Password',
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_apb_flutter/core/error/api_exception.dart';
import 'package:tubes_apb_flutter/core/session/auth_session_controller.dart';
import 'package:tubes_apb_flutter/core/utils/validators.dart';
import 'package:tubes_apb_flutter/features/auth/data/models/auth_models.dart';
import 'package:tubes_apb_flutter/features/auth/data/repositories/auth_repository.dart';
import 'package:tubes_apb_flutter/shared/widgets/app_primary_button.dart';
import 'package:tubes_apb_flutter/shared/widgets/app_text_field.dart';
import 'package:tubes_apb_flutter/shared/widgets/feedback.dart';

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  Map<String, String> _fieldErrors = const {};

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
      _fieldErrors = const {};
    });

    final repository = ref.read(authRepositoryProvider);
    final sessionController = ref.read(authSessionControllerProvider.notifier);

    try {
      await sessionController.withRefreshRetry(
        () => repository.changePasswordAuthenticated(
          AuthenticatedChangePasswordRequest(
            oldPassword: _oldPasswordController.text,
            newPassword: _newPasswordController.text,
            confirmationPassword: _confirmPasswordController.text,
          ),
        ),
      );

      if (!mounted) {
        return;
      }

      showSuccessSnackBar(context, 'Password updated successfully.');
      Navigator.of(context).pop();
    } catch (error) {
      if (error is ApiException) {
        final mappedErrors = <String, String>{};
        for (final entry in error.fieldErrors.entries) {
          if (entry.value.isNotEmpty) {
            mappedErrors[entry.key] = entry.value.first;
          }
        }

        if (!mounted) {
          return;
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
      appBar: AppBar(title: const Text('Security')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  label: 'Current Password',
                  controller: _oldPasswordController,
                  obscureText: _obscureOld,
                  validator: (value) => Validators.requiredField(
                    value,
                    fieldName: 'Current password',
                  ),
                  errorText: _fieldErrors['oldPassword'],
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureOld = !_obscureOld;
                      });
                    },
                    icon: Icon(
                      _obscureOld ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'New Password',
                  controller: _newPasswordController,
                  obscureText: _obscureNew,
                  validator: Validators.password,
                  errorText: _fieldErrors['newPassword'],
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureNew = !_obscureNew;
                      });
                    },
                    icon: Icon(
                      _obscureNew ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  validator: (value) => Validators.confirmPassword(
                    value,
                    against: _newPasswordController.text,
                    fieldName: 'Confirmation password',
                  ),
                  errorText: _fieldErrors['confirmationPassword'],
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    },
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AppPrimaryButton(
                  label: 'Change Password',
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

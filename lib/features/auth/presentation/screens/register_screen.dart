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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  Map<String, String> _fieldErrors = const {};

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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

    try {
      await repository.register(
        AuthRegisterRequest(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          confirmationPassword: _confirmPasswordController.text,
        ),
      );

      if (!mounted) {
        return;
      }

      showSuccessSnackBar(
        context,
        'Account created successfully. Please log in.',
      );
      context.go(RoutePaths.login);
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 36, 32, 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const AuthHeader(
                  title: 'Create Account',
                  subtitle: 'Let us help you set up your account in seconds.',
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'First Name',
                        controller: _firstNameController,
                        textInputAction: TextInputAction.next,
                        validator: (value) => Validators.requiredField(
                          value,
                          fieldName: 'First name',
                        ),
                        errorText: _fieldErrors['firstName'],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppTextField(
                        label: 'Last Name',
                        controller: _lastNameController,
                        textInputAction: TextInputAction.next,
                        validator: (value) => Validators.requiredField(
                          value,
                          fieldName: 'Last name',
                        ),
                        errorText: _fieldErrors['lastName'],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                  errorText: _fieldErrors['email'],
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Password',
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  obscureText: _obscurePassword,
                  validator: Validators.password,
                  errorText: _fieldErrors['password'],
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Re-type Password',
                  controller: _confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  obscureText: _obscureConfirmPassword,
                  validator: (value) => Validators.confirmPassword(
                    value,
                    against: _passwordController.text,
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
                  label: 'Create Account',
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => context.go(RoutePaths.login),
                      child: Text(
                        'Login',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

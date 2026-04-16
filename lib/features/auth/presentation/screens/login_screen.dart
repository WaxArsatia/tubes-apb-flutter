import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tubes_apb_flutter/app/router/route_paths.dart';
import 'package:tubes_apb_flutter/core/error/api_exception.dart';
import 'package:tubes_apb_flutter/core/session/auth_session_controller.dart';
import 'package:tubes_apb_flutter/core/utils/validators.dart';
import 'package:tubes_apb_flutter/features/auth/presentation/widgets/auth_header.dart';
import 'package:tubes_apb_flutter/shared/widgets/app_primary_button.dart';
import 'package:tubes_apb_flutter/shared/widgets/app_text_field.dart';
import 'package:tubes_apb_flutter/shared/widgets/feedback.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  Map<String, String> _fieldErrors = const {};

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

    final sessionController = ref.read(authSessionControllerProvider.notifier);

    try {
      await sessionController.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) {
        return;
      }

      showSuccessSnackBar(context, 'Welcome back!');
      context.go(RoutePaths.home);
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
                  title: 'Welcome Back',
                  subtitle: 'Log in to continue managing your finance.',
                ),
                const SizedBox(height: 38),
                AppTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                  errorText: _fieldErrors['email'],
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (value) =>
                      Validators.requiredField(value, fieldName: 'Password'),
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
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.go(RoutePaths.forgotPassword),
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 10),
                AppPrimaryButton(
                  label: 'Log In',
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => context.go(RoutePaths.register),
                      child: Text(
                        'Register',
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tubes_apb_flutter/app/router/route_paths.dart';
import 'package:tubes_apb_flutter/features/auth/data/repositories/auth_repository.dart';
import 'package:tubes_apb_flutter/features/auth/presentation/widgets/auth_header.dart';
import 'package:tubes_apb_flutter/shared/widgets/app_primary_button.dart';
import 'package:tubes_apb_flutter/shared/widgets/app_text_field.dart';
import 'package:tubes_apb_flutter/shared/widgets/feedback.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({
    required this.email,
    required this.expiresInMinutes,
    super.key,
  });

  final String email;
  final int expiresInMinutes;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  late int _remainingSeconds;
  Timer? _timer;

  bool _isSubmitting = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (_) => TextEditingController());
    _focusNodes = List.generate(4, (_) => FocusNode());
    _remainingSeconds = widget.expiresInMinutes * 60;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_remainingSeconds <= 0) {
        timer.cancel();
        return;
      }

      setState(() {
        _remainingSeconds--;
      });
    });
  }

  String get _otpCode {
    return _controllers.map((controller) => controller.text).join();
  }

  String get _formattedRemaining {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _submit() async {
    if (_otpCode.length != 4 || int.tryParse(_otpCode) == null) {
      showErrorSnackBar(
        context,
        const FormatException('Please enter a valid 4-digit OTP code.'),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final repository = ref.read(authRepositoryProvider);

    try {
      await repository.verifyOtp(email: widget.email, otp: int.parse(_otpCode));

      if (!mounted) {
        return;
      }

      final encodedEmail = Uri.encodeComponent(widget.email);
      context.go(
        '${RoutePaths.changePassword}?email=$encodedEmail&otp=$_otpCode',
      );
    } catch (error) {
      if (mounted) {
        showErrorSnackBar(context, error);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _resendCode() async {
    setState(() {
      _isResending = true;
    });

    final repository = ref.read(authRepositoryProvider);

    try {
      final response = await repository.forgotPassword(widget.email);
      if (!mounted) {
        return;
      }

      for (final controller in _controllers) {
        controller.clear();
      }

      setState(() {
        _remainingSeconds = response.otpExpiresInMinutes * 60;
      });

      _startTimer();
      showSuccessSnackBar(context, 'A new OTP code has been sent.');
      _focusNodes.first.requestFocus();
    } catch (error) {
      if (mounted) {
        showErrorSnackBar(context, error);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 16, 30, 24),
          child: Column(
            children: [
              const AuthHeader(
                title: 'Verification Code',
                subtitle: 'Enter the 4-digit code we sent to your email.',
              ),
              const SizedBox(height: 32),
              Row(
                children: List.generate(4, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: index == 3 ? 0 : 12),
                      child: AppTextField(
                        label: '',
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.length == 1 && index < 3) {
                            _focusNodes[index + 1].requestFocus();
                          }
                        },
                        onFieldSubmitted: (_) {
                          if (index == 3) {
                            _submit();
                          }
                        },
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 14),
              Text(
                'Code expires in: $_formattedRemaining',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: _isResending ? null : _resendCode,
                child: _isResending
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Didn\'t receive code? Resend Code'),
              ),
              const Spacer(),
              AppPrimaryButton(
                label: 'Verify Code',
                isLoading: _isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

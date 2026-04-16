import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tubes_apb_flutter/app/router/route_paths.dart';
import 'package:tubes_apb_flutter/core/session/auth_session_controller.dart';
import 'package:tubes_apb_flutter/shared/theme/app_colors.dart';
import 'package:tubes_apb_flutter/shared/widgets/app_primary_button.dart';

class SuccessChangePasswordScreen extends ConsumerWidget {
  const SuccessChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authSessionControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 56, 30, 30),
          child: Column(
            children: [
              Text(
                'Password Changed Successfully',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'You can now log in again and start exploring.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 42),
              Container(
                height: 192,
                width: 192,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(48),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 88,
                ),
              ),
              const Spacer(),
              AppPrimaryButton(
                label: 'Continue',
                onPressed: () {
                  if (authState.isAuthenticated) {
                    context.go(RoutePaths.home);
                    return;
                  }

                  context.go(RoutePaths.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

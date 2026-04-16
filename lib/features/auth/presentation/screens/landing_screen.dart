import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tubes_apb_flutter/app/router/route_paths.dart';
import 'package:tubes_apb_flutter/shared/theme/app_colors.dart';
import 'package:tubes_apb_flutter/shared/widgets/app_primary_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 31),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                height: 192,
                width: 192,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(48),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 88,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 46),
              Text(
                'Take Control of Your Money',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Track spending, manage your budget, and grow your savings.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              AppPrimaryButton(
                label: 'Create Account',
                onPressed: () => context.go(RoutePaths.register),
              ),
              const SizedBox(height: 16),
              AppPrimaryButton(
                label: 'Log In',
                outlined: true,
                onPressed: () => context.go(RoutePaths.login),
              ),
              const SizedBox(height: 56),
            ],
          ),
        ),
      ),
    );
  }
}

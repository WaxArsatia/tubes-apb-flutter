import 'package:flutter/material.dart';
import 'package:tubes_apb_flutter/shared/theme/app_colors.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.outlined = false,
    this.height = 55,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool outlined;
  final double height;

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
      height: height,
      width: double.infinity,
      child: outlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _ButtonContent(
                label: label,
                isLoading: isLoading,
                outlined: true,
              ),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _ButtonContent(
                label: label,
                isLoading: isLoading,
                outlined: false,
              ),
            ),
    );

    return child;
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.isLoading,
    required this.outlined,
  });

  final String label;
  final bool isLoading;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          color: outlined ? AppColors.primary : AppColors.surface,
        ),
      );
    }

    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: outlined ? AppColors.primary : AppColors.surface,
      ),
    );
  }
}

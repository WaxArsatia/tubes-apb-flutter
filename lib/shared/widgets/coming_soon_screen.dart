import 'package:flutter/material.dart';
import 'package:tubes_apb_flutter/shared/theme/app_colors.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    required this.title,
    required this.description,
    super.key,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 72,
                width: 72,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_empty_rounded,
                  color: AppColors.primary,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Coming Soon',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

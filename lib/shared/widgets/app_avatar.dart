import 'package:flutter/material.dart';
import 'package:tubes_apb_flutter/shared/theme/app_colors.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.radius = 24,
    this.fallbackIcon = Icons.person,
  });

  final String? imageUrl;
  final double radius;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final finalImageUrl = imageUrl?.trim();
    final hasNetworkImage = finalImageUrl != null && finalImageUrl.isNotEmpty;

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.secondary,
      backgroundImage: hasNetworkImage ? NetworkImage(finalImageUrl) : null,
      child: hasNetworkImage
          ? null
          : Icon(fallbackIcon, color: AppColors.primary, size: radius),
    );
  }
}

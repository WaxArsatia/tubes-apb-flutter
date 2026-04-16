import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes_apb_flutter/shared/theme/app_colors.dart';

ThemeData buildAppTheme() {
  final textTheme = GoogleFonts.plusJakartaSansTextTheme().copyWith(
    headlineLarge: GoogleFonts.plusJakartaSans(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      height: 1.2,
    ),
    headlineMedium: GoogleFonts.plusJakartaSans(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      height: 1.2,
    ),
    titleLarge: GoogleFonts.plusJakartaSans(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      height: 1.3,
    ),
    bodyLarge: GoogleFonts.plusJakartaSans(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
      height: 1.4,
    ),
    bodyMedium: GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondary,
      height: 1.4,
    ),
    labelLarge: GoogleFonts.plusJakartaSans(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: AppColors.surface,
      height: 1.2,
    ),
  );

  return ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.surface,
    ),
    textTheme: textTheme,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error, width: 1.6),
      ),
      labelStyle: textTheme.bodyMedium,
      floatingLabelStyle: textTheme.bodyMedium?.copyWith(
        color: AppColors.primary,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.primaryDark,
      contentTextStyle: textTheme.bodyLarge?.copyWith(color: AppColors.surface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    useMaterial3: true,
  );
}

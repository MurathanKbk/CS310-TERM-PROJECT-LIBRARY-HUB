import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._(); // This is not a object it is theme so we use this constructor it prevents the construction of an object
  static ThemeData get light =>ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      outline: AppColors.divider,
      onSurfaceVariant: AppColors.textSecondary,
      tertiary: AppColors.available,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: AppColorsDark.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColorsDark.primary,
      onPrimary: AppColorsDark.onPrimary,
      secondary: AppColorsDark.accent,
      surface: AppColorsDark.surface,
      onSurface: AppColorsDark.textPrimary,
      error: AppColorsDark.error,
      outline: AppColorsDark.divider,
      onSurfaceVariant: AppColorsDark.textSecondary,
      tertiary: AppColorsDark.available,
    ),
  );
}


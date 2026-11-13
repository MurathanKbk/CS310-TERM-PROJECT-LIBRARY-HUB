import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // It prevents the construction of an object since this is a color class

  static const primary = Color(0xFF7CFC00);
  static const onPrimary = Color(0xFF1B2430);
  static const primaryLight = Color(0xFFE4FBC8);
  static const accent = Color(0xFF2E7D00);
  static const background = Color(0xFFF6F8FB);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1B2430);
  static const textSecondary = Color(0xFF6B7685);
  static const divider = Color(0xFFE1E6EE);
  static const error = Color(0xFFD64545);
  static const warning = Color(0xFFE5A100);
  static const available = Color(0xFF008B8B);
}
//Dark mode colors
class AppColorsDark {
  AppColorsDark._();

  static const primary = Color(0xFF006400);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryLight = Color(0xFF12301A);
  static const accent = Color(0xFF90EE90);
  static const background = Color(0xFF121512);
  static const surface = Color(0xFF1D221E);
  static const textPrimary = Color(0xFFEDF2EE);
  static const textSecondary = Color(0xFFA3AEA5);
  static const divider = Color(0xFF2C332E);
  static const error = Color(0xFFFF7A7A);
  static const warning = Color(0xFFFFC83D);
  static const available = Color(0xFF4FD1C5);
}
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  fontFamily: 'Inter',

  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.darkBg,

  colorScheme: ColorScheme.dark(
    primary: AppColors.accent,
    secondary: AppColors.secondary,
    surface: AppColors.darkSurface,
    error: AppColors.error,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkSurface,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),

  cardTheme: CardThemeData(
    color: AppColors.darkSurface,
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
  ),
);

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: 'Inter',

  // Core
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.lightBg,

  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.accent,
    surface: AppColors.lightSurface,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black87,
  ),

  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary, // #00357A
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),

  // Cards
  // cardTheme: CardTheme(
  //   color: AppColors.lightSurface,
  //   elevation: 2,
  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  // ),

  // Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(vertical: 14),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),

  // Inputs (recommended addition)
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightSurface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
  ),
);

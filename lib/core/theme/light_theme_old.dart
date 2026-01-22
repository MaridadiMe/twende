import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors_old.dart';

final ThemeData lightThemeOld = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: 'Inter',

  primaryColor: AppColorsOld.primary,
  scaffoldBackgroundColor: AppColorsOld.lightBg,

  colorScheme: ColorScheme.light(
    primary: AppColorsOld.primary,
    secondary: AppColorsOld.accent,
    surface: AppColorsOld.lightSurface,
    error: AppColorsOld.error,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColorsOld.lightSurface,
    foregroundColor: AppColorsOld.primary,
    elevation: 0,
    centerTitle: true,
  ),

  cardTheme: CardThemeData(
    color: AppColorsOld.lightSurface,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColorsOld.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
  ),
);

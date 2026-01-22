import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors_old.dart';

final ThemeData darkThemeOld = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  fontFamily: 'Inter',

  primaryColor: AppColorsOld.primary,
  scaffoldBackgroundColor: AppColorsOld.darkBg,

  colorScheme: ColorScheme.dark(
    primary: AppColorsOld.accent,
    secondary: AppColorsOld.secondary,
    surface: AppColorsOld.darkSurface,
    error: AppColorsOld.error,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColorsOld.darkSurface,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),

  cardTheme: CardThemeData(
    color: AppColorsOld.darkSurface,
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColorsOld.accent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
  ),
);

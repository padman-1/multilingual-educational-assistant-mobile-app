// theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme(
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryContainer,
    secondary: AppColors.secondary,
    secondaryContainer: AppColors.secondaryContainer,
    background: AppColors.background,
    surface: AppColors.surface,
    error: AppColors.error,
    onPrimary: AppColors.onPrimary,
    onSecondary: AppColors.onSecondary,
    onBackground: AppColors.onBackground,
    onSurface: AppColors.onSurface,
    onError: AppColors.onError,
    brightness: Brightness.light,
  ),
  appBarTheme: AppBarTheme(backgroundColor: AppColors.background),
  textTheme: GoogleFonts.anekBanglaTextTheme(
    ThemeData.light().textTheme.apply(bodyColor: Colors.black),
  ),
  useMaterial3: true,
);

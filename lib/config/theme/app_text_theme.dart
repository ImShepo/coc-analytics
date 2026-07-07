import 'package:coc/config/theme/app_fonts.dart';
import 'package:flutter/material.dart';

abstract final class AppTextTheme {
  static const Color _textColor = Color(0xFF3B3B3B);

  static TextTheme light(ColorScheme colorScheme) {
    return Typography.material2021().black.apply(
          fontFamily: AppFonts.primary,
          bodyColor: _textColor,
          displayColor: _textColor,
        );
  }

  static InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      hintStyle: TextStyle(
        fontFamily: AppFonts.primary,
        color: Colors.grey.shade600,
        fontSize: 13,
      ),
      labelStyle: const TextStyle(
        fontFamily: AppFonts.primary,
        fontSize: 13,
      ),
    );
  }

  static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontFamily: AppFonts.primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static TextButtonThemeData textButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: TextStyle(
          fontFamily: AppFonts.primary,
          fontSize: 11,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}

import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/config/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Colors.green;
  static const Color onPrimaryColor = Color.fromARGB(255, 46, 105, 48);
  static const Color secondaryColor = Color.fromARGB(255, 174, 247, 177);
  static const Color surfaceColor = Color(0xFFE7F0DC);
  static const Color backgroundColor = Color(0xFFF1F1F1);

  ThemeData getTheme() {
    const colorScheme = ColorScheme(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      error: Colors.red,
      onPrimary: onPrimaryColor,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    );

    final textTheme = AppTextTheme.light(colorScheme);

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.primary,
      colorScheme: colorScheme,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: AppTextTheme.inputDecorationTheme(colorScheme),
      elevatedButtonTheme: AppTextTheme.elevatedButtonTheme(colorScheme),
      textButtonTheme: AppTextTheme.textButtonTheme(colorScheme),
      searchBarTheme: SearchBarThemeData(
        textStyle: WidgetStatePropertyAll(
          textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            fontFamily: AppFonts.light,
            fontWeight: FontWeight.w400,
          ),
        ),
        hintStyle: WidgetStatePropertyAll(
          textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontFamily: AppFonts.light,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

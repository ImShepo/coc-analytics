import 'package:flutter/material.dart';

abstract final class AppFonts {
  static const String primary = 'YouBlockhead';
  static const String light = 'YouBlockheadOpen';

  /// Subtle shadow for white text on dark/image backgrounds.
  static const List<Shadow> onDarkSurfaceOutline = [
    Shadow(color: Color(0xCC000000), blurRadius: 6, offset: Offset(0, 1)),
  ];

  /// Section headers on the mint-green background (natural font outline).
  static TextStyle sectionTitle({double fontSize = 12}) {
    return TextStyle(
      fontFamily: primary,
      color: const Color(0xFF3B3B3B),
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
    );
  }

  /// Labels inside white cards — solid color, no outline/shadow stacking.
  static TextStyle cardLabel({
    double fontSize = 11,
    double? height,
  }) {
    return TextStyle(
      fontFamily: light,
      color: const Color(0xFF5C5C5C),
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w400,
    );
  }

  /// Body copy placed directly on the painted screen scrim (not inside a card).
  static TextStyle scrimBody({
    double fontSize = 12,
    double? height,
    TextAlign? textAlign,
  }) {
    return TextStyle(
      fontFamily: light,
      color: const Color(0xFF3B3B3B),
      fontSize: fontSize,
      height: height ?? 1.35,
      fontWeight: FontWeight.w400,
    );
  }

  /// Secondary / hint copy on the painted screen scrim.
  static TextStyle scrimCaption({
    double fontSize = 10,
    double? height,
  }) {
    return TextStyle(
      fontFamily: light,
      color: const Color(0xFF5C5C5C),
      fontSize: fontSize,
      height: height ?? 1.35,
      fontWeight: FontWeight.w400,
    );
  }
}

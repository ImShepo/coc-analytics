import 'package:flutter/material.dart';

/// Visual identity layer for screen backgrounds — all share the home palette.
enum AppScreenBackgroundVariant {
  /// Player hub — full constellation, shield and base grid.
  home,

  /// Player stats — chart lines and trophy glow.
  stats,

  /// Head-to-head compare — dual rival glows and VS motif.
  compare,

  /// Clan overview — rolling hills and banner path.
  clan,

  /// Clan member profile — hero spotlight and soft hills.
  member,

  /// Unit / troop detail — focused center glow and tactical grid.
  unit,
}

abstract final class AppScreenBackgroundColors {
  static const base = Color(0xFFEDE8EB);
}

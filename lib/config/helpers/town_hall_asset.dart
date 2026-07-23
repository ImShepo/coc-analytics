/// Local town-hall art under [assets/images/townhall/].
///
/// Some halls only ship weaponized variants (e.g. TH12 → TownHall12-1.png).
String townHallAssetPath(int level) {
  final clamped = level.clamp(1, 16);
  const overrides = <int, String>{
    12: 'TownHall12-1.png',
    13: 'TownHall13-3.png',
  };
  final file = overrides[clamped] ?? 'TownHall$clamped.png';
  return 'assets/images/townhall/$file';
}

import 'package:coc/config/helpers/building_catalog.dart';
import 'package:coc/config/helpers/troop_catalog.dart';

enum UnitCategory { troop, hero, spell, equipment, building }

enum CocImageSource {
  troop,
  pet,
  superTroopPic,
  siegePic,
  troopPic,
  homeBuilding,
  builderBuilding,
  trap,
  guardian,
  heroPic,
  spellPic,
  equipmentPic,
  townHallPic,
}

/// Resolves Clash of Clans unit art from the ClashKing CDN
/// (`https://assets.clashk.ing`). Path rules follow their published naming:
/// cleaned lower-case names with spaces → `_`, dots stripped.
class CocUnitImage {
  static const _cdn = 'https://assets.clashk.ing';

  /// Exceptions where ClashKing folder names diverge from cleaned API names.
  static const _slugOverrides = {
    'P.E.K.K.A': 'pekka',
    'L.A.S.S.I': 'lassi',
    'Snow Flake': 'frost_flake',
    "Builder's Hut": "builder's_hut",
    'Town Hall Weapon': 'multi-gear_tower',
    'Multi Cannon': 'giant_cannon',
    'Long Shot': 'longshot',
  };

  static String cleanedName(String name) {
    final override = _slugOverrides[name];
    if (override != null) return override;

    return name
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('.', '')
        .replaceAll('?', '')
        .replaceAll(r'\q', '')
        .replaceAll("'", '')
        .replaceAll('’', '')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  /// Legacy hyphen slug (kept for any callers / old path fallbacks).
  static String slugFor(String name) {
    if (_slugOverrides.containsKey(name)) {
      final o = _slugOverrides[name]!;
      return o.replaceAll('_', '-').replaceAll("'", '');
    }

    return name
        .toLowerCase()
        .replaceAll("'s ", '-')
        .replaceAll("'s", 's')
        .replaceAll('.', '')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  static String troopSlugFor(String name) => cleanedName(name);

  static List<String> urlsFor({
    required String name,
    required UnitCategory category,
    String? imageName,
    int level = 1,
    int maxLevel = 1,
    String village = 'home',
    TroopGroup? troopGroup,
    BuildingGroup? buildingGroup,
  }) {
    final displayName = imageName ?? name;

    return switch (category) {
      UnitCategory.hero => _heroUrls(name),
      UnitCategory.spell => _spellUrls(name),
      UnitCategory.equipment => _equipmentUrls(name),
      UnitCategory.building => _buildingUrls(
          name: displayName,
          level: level,
          village: village,
          buildingGroup: buildingGroup,
        ),
      UnitCategory.troop => _troopUrls(
          name: name,
          village: village,
          troopGroup: troopGroup,
        ),
    };
  }

  static List<String> _heroUrls(String name) {
    final slug = cleanedName(name);
    return ['$_cdn/heroes/$slug/icon.webp'];
  }

  static List<String> _spellUrls(String name) {
    final slug = cleanedName(name);
    return ['$_cdn/spells/$slug.webp'];
  }

  static List<String> _equipmentUrls(String name) {
    final slug = cleanedName(name);
    return ['$_cdn/equipment/$slug.webp'];
  }

  static List<String> _troopUrls({
    required String name,
    required String village,
    TroopGroup? troopGroup,
  }) {
    if (troopGroup == TroopGroup.pet) {
      final slug = cleanedName(name);
      return [
        '$_cdn/pets/$slug/icon.webp',
      ];
    }

    final slug = cleanedName(name);
    return [
      '$_cdn/troops/$slug/icon.webp',
    ];
  }

  static List<String> _buildingUrls({
    required String name,
    required int level,
    required String village,
    BuildingGroup? buildingGroup,
  }) {
    final lvl = level < 1 ? 1 : level;
    final slug = cleanedName(name);

    if (buildingGroup == BuildingGroup.traps || _isTrapName(name)) {
      final base = village == 'builderBase' ? 'builder-base' : 'home-village';
      return [
        '$_cdn/traps/$base/$slug/level_$lvl.webp',
        '$_cdn/traps/$base/$slug/level_1.webp',
      ];
    }

    if (name == 'Long Shot' || slug == 'longshot') {
      return ['$_cdn/guardians/longshot/icon.webp'];
    }

    if (village == 'builderBase') {
      return [
        '$_cdn/buildings/builder-base/$slug/level_$lvl.webp',
        '$_cdn/buildings/builder-base/$slug/level_1.webp',
      ];
    }

    return [
      '$_cdn/buildings/home-village/$slug/level_$lvl.webp',
      '$_cdn/buildings/home-village/$slug/level_1.webp',
    ];
  }

  static bool _isTrapName(String name) {
    const traps = {
      'Bomb',
      'Spring Trap',
      'Air Bomb',
      'Giant Bomb',
      'Seeking Air Mine',
      'Skeleton Trap',
      'Tornado Trap',
    };
    return traps.contains(name);
  }
}

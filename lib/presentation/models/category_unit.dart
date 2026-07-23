import 'package:coc/config/helpers/building_catalog.dart';
import 'package:coc/config/helpers/coc_unit_image.dart';
import 'package:coc/config/helpers/town_hall_asset.dart';
import 'package:coc/config/helpers/troop_catalog.dart';
import 'package:coc/config/helpers/unit_static_repository.dart';
import 'package:coc/domain/entities/player.dart';

class CategoryUnit {
  final String name;
  final int level;
  final int maxLevel;
  final String village;
  final UnitCategory category;
  final String? localAssetPath;
  final TroopGroup? troopGroup;
  final SpellGroup? spellGroup;
  final BuildingGroup? buildingGroup;
  final int? unlockTownHall;
  final bool hasExactLevel;
  final String? imageName;
  final bool superTroopIsActive;

  const CategoryUnit({
    required this.name,
    required this.level,
    required this.maxLevel,
    required this.village,
    required this.category,
    this.localAssetPath,
    this.troopGroup,
    this.spellGroup,
    this.buildingGroup,
    this.unlockTownHall,
    this.hasExactLevel = true,
    this.imageName,
    this.superTroopIsActive = false,
  });

  String get displayImageName => imageName ?? name;

  String get heroTag => 'unit-${category.name}-$village-$name';

  bool get isUnlocked => level > 0;

  bool get isMaxed => hasExactLevel && maxLevel > 0 && level >= maxLevel;

  double get progress =>
      maxLevel == 0 ? 0 : (level / maxLevel).clamp(0.0, 1.0);

  int displayImageLevel(Player player) {
    if (hasExactLevel && level > 0) return level;

    if (category == UnitCategory.building && isUnlocked) {
      final staticItem = UnitStaticRepository.instance.findFor(this);
      if (staticItem != null) {
        final hall = village == 'builderBase'
            ? player.builderHallLevel
            : player.townHallLevel;
        return UnitStaticRepository.instance.maxLevelAtTownHall(staticItem, hall);
      }
    }

    return level.clamp(1, 99);
  }

  bool get showLevelBadge =>
      hasExactLevel ? level > 0 : category == UnitCategory.building && isUnlocked;

  int levelBadgeValue(Player player) =>
      hasExactLevel ? level : displayImageLevel(player);

  static List<CategoryUnit> _fromTroops(Player player) {
    return player.troops
        .where((t) => t.maxLevel > 0)
        .map(
          (t) => CategoryUnit(
            name: t.name,
            level: t.level,
            maxLevel: t.maxLevel,
            village: t.village,
            category: UnitCategory.troop,
            troopGroup: TroopCatalog.troopGroupFor(t.name, t.village),
            superTroopIsActive: t.superTroopIsActive,
          ),
        )
        .toList();
  }

  static Map<TroopGroup, List<CategoryUnit>> troopsGrouped(Player player) {
    final map = <TroopGroup, List<CategoryUnit>>{};
    for (final troop in _fromTroops(player)) {
      map.putIfAbsent(troop.troopGroup!, () => []).add(troop);
    }
    for (final list in map.values) {
      list.sort((a, b) {
        if (a.superTroopIsActive != b.superTroopIsActive) {
          return a.superTroopIsActive ? -1 : 1;
        }
        if (a.isUnlocked != b.isUnlocked) {
          return a.isUnlocked ? -1 : 1;
        }
        return b.level.compareTo(a.level);
      });
    }
    return map;
  }

  static List<CategoryUnit> troopsFrom(Player player) {
    return _fromTroops(player)
      ..sort((a, b) {
        final ga = a.troopGroup ?? TroopGroup.other;
        final gb = b.troopGroup ?? TroopGroup.other;
        final orderA = TroopCatalog.troopDisplayOrder.indexOf(ga);
        final orderB = TroopCatalog.troopDisplayOrder.indexOf(gb);
        if (orderA != orderB) return orderA.compareTo(orderB);
        if (a.isUnlocked != b.isUnlocked) {
          return a.isUnlocked ? -1 : 1;
        }
        return a.name.compareTo(b.name);
      });
  }

  static List<CategoryUnit> heroesFrom(Player player) {
    return player.heroes
        .where((h) => h.maxLevel > 0)
        .map(
          (h) => CategoryUnit(
            name: h.name,
            level: h.level,
            maxLevel: h.maxLevel,
            village: h.village,
            category: UnitCategory.hero,
          ),
        )
        .toList()
      ..sort((a, b) {
        if (a.isUnlocked != b.isUnlocked) {
          return a.isUnlocked ? -1 : 1;
        }
        return b.level.compareTo(a.level);
      });
  }

  static Map<SpellGroup, List<CategoryUnit>> spellsGrouped(Player player) {
    final map = <SpellGroup, List<CategoryUnit>>{};
    for (final spell in spellsFrom(player)) {
      map.putIfAbsent(spell.spellGroup!, () => []).add(spell);
    }
    return map;
  }

  static List<CategoryUnit> spellsFrom(Player player) {
    return player.spells
        .where((s) => s.maxLevel > 0)
        .map(
          (s) => CategoryUnit(
            name: s.name,
            level: s.level,
            maxLevel: s.maxLevel,
            village: s.village,
            category: UnitCategory.spell,
            spellGroup: TroopCatalog.spellGroupFor(s.name),
          ),
        )
        .toList()
      ..sort((a, b) {
        final ga = a.spellGroup ?? SpellGroup.other;
        final gb = b.spellGroup ?? SpellGroup.other;
        final orderA = TroopCatalog.spellDisplayOrder.indexOf(ga);
        final orderB = TroopCatalog.spellDisplayOrder.indexOf(gb);
        if (orderA != orderB) return orderA.compareTo(orderB);
        if (a.isUnlocked != b.isUnlocked) {
          return a.isUnlocked ? -1 : 1;
        }
        return a.name.compareTo(b.name);
      });
  }

  static List<CategoryUnit> equipmentFrom(Player player) {
    return player.heroEquipment
        .where((e) => e.maxLevel > 0)
        .map(
          (e) => CategoryUnit(
            name: e.name,
            level: e.level,
            maxLevel: e.maxLevel,
            village: e.village,
            category: UnitCategory.equipment,
          ),
        )
        .toList()
      ..sort((a, b) {
        if (a.isUnlocked != b.isUnlocked) {
          return a.isUnlocked ? -1 : 1;
        }
        return b.level.compareTo(a.level);
      });
  }

  static List<CategoryUnit> buildingsFrom(Player player) {
    final thLevel = player.townHallLevel;
    final bhLevel = player.builderHallLevel;
    final weaponLevel = player.townHallWeaponLevel;

    return BuildingCatalog.allEntries().map((entry) {
      final hallLevel = entry.village == 'home' ? thLevel : bhLevel;

      if (entry.name == 'Ayuntamiento') {
        return CategoryUnit(
          name: entry.name,
          level: thLevel,
          maxLevel: 17,
          village: entry.village,
          category: UnitCategory.building,
          buildingGroup: entry.group,
          localAssetPath: townHallAssetPath(thLevel),
        );
      }

      if (entry.name == 'Ayuntamiento del Constructor' && bhLevel > 0) {
        return CategoryUnit(
          name: entry.name,
          level: bhLevel,
          maxLevel: 10,
          village: entry.village,
          category: UnitCategory.building,
          buildingGroup: entry.group,
          localAssetPath: townHallAssetPath(bhLevel),
        );
      }

      if (entry.name == 'Arma del Ayuntamiento') {
        final unlocked = thLevel >= entry.unlockLevel && weaponLevel > 0;
        return CategoryUnit(
          name: entry.name,
          level: unlocked ? weaponLevel : 0,
          maxLevel: 5,
          village: entry.village,
          category: UnitCategory.building,
          buildingGroup: entry.group,
          unlockTownHall: entry.unlockLevel,
          imageName: 'Town Hall Weapon',
        );
      }

      if (entry.name == 'Ayuntamiento del Constructor' && bhLevel <= 0) {
        return CategoryUnit(
          name: entry.name,
          level: 0,
          maxLevel: 10,
          village: entry.village,
          category: UnitCategory.building,
          buildingGroup: entry.group,
          unlockTownHall: entry.unlockLevel,
        );
      }

      final unlocked = hallLevel >= entry.unlockLevel;
      return CategoryUnit(
        name: entry.name,
        level: unlocked ? 1 : 0,
        maxLevel: 1,
        village: entry.village,
        category: UnitCategory.building,
        buildingGroup: entry.group,
        unlockTownHall: entry.unlockLevel,
        hasExactLevel: false,
        imageName: BuildingCatalog.imageNameFor(entry.name),
      );
    }).toList();
  }

  static Map<BuildingGroup, List<CategoryUnit>> buildingsGrouped(Player player) {
    final map = <BuildingGroup, List<CategoryUnit>>{};
    for (final building in buildingsFrom(player)) {
      map.putIfAbsent(building.buildingGroup!, () => []).add(building);
    }
    for (final list in map.values) {
      list.sort((a, b) {
        if (a.isUnlocked != b.isUnlocked) {
          return a.isUnlocked ? -1 : 1;
        }
        return a.name.compareTo(b.name);
      });
    }
    return map;
  }
}

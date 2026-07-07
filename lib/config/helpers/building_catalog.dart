import 'package:flutter/material.dart';

enum BuildingGroup {
  main,
  defense,
  resource,
  army,
  traps,
  builderBase,
}

class BuildingCatalog {
  static const buildingDisplayOrder = [
    BuildingGroup.main,
    BuildingGroup.defense,
    BuildingGroup.resource,
    BuildingGroup.army,
    BuildingGroup.traps,
    BuildingGroup.builderBase,
  ];

  static const _entries = [
    _Entry('Ayuntamiento', 'Town Hall', BuildingGroup.main, 'home', 1),
    _Entry('Arma del Ayuntamiento', 'Town Hall Weapon', BuildingGroup.main, 'home', 12),
    _Entry('Cañón', 'Cannon', BuildingGroup.defense, 'home', 1),
    _Entry('Torre arquera', 'Archer Tower', BuildingGroup.defense, 'home', 2),
    _Entry('Mortero', 'Mortar', BuildingGroup.defense, 'home', 3),
    _Entry('Defensa antiaérea', 'Air Defense', BuildingGroup.defense, 'home', 4),
    _Entry('Torre de magos', 'Wizard Tower', BuildingGroup.defense, 'home', 5),
    _Entry('Barrido aéreo', 'Air Sweeper', BuildingGroup.defense, 'home', 6),
    _Entry('Tesla oculta', 'Hidden Tesla', BuildingGroup.defense, 'home', 7),
    _Entry('Torre bomba', 'Bomb Tower', BuildingGroup.defense, 'home', 8),
    _Entry('Ballesta', 'X-Bow', BuildingGroup.defense, 'home', 9),
    _Entry('Torre infernal', 'Inferno Tower', BuildingGroup.defense, 'home', 10),
    _Entry('Artillería águila', 'Eagle Artillery', BuildingGroup.defense, 'home', 11),
    _Entry('Dispersor', 'Scattershot', BuildingGroup.defense, 'home', 12),
    _Entry('Monolito', 'Monolith', BuildingGroup.defense, 'home', 14),
    _Entry('Torre de hechizos', 'Spell Tower', BuildingGroup.defense, 'home', 15),
    _Entry('Mina de oro', 'Gold Mine', BuildingGroup.resource, 'home', 1),
    _Entry('Recolector de elixir', 'Elixir Collector', BuildingGroup.resource, 'home', 1),
    _Entry('Perforadora de elixir oscuro', 'Dark Elixir Drill', BuildingGroup.resource, 'home', 7),
    _Entry('Almacén de oro', 'Gold Storage', BuildingGroup.resource, 'home', 1),
    _Entry('Almacén de elixir', 'Elixir Storage', BuildingGroup.resource, 'home', 1),
    _Entry('Almacén de elixir oscuro', 'Dark Elixir Storage', BuildingGroup.resource, 'home', 7),
    _Entry('Castillo del clan', 'Clan Castle', BuildingGroup.resource, 'home', 1),
    _Entry('Campamento', 'Army Camp', BuildingGroup.army, 'home', 1),
    _Entry('Cuartel', 'Barracks', BuildingGroup.army, 'home', 1),
    _Entry('Cuartel oscuro', 'Dark Barracks', BuildingGroup.army, 'home', 7),
    _Entry('Laboratorio', 'Laboratory', BuildingGroup.army, 'home', 3),
    _Entry('Fábrica de hechizos', 'Spell Factory', BuildingGroup.army, 'home', 5),
    _Entry('Fábrica de hechizos oscuros', 'Dark Spell Factory', BuildingGroup.army, 'home', 8),
    _Entry('Taller de asedio', 'Workshop', BuildingGroup.army, 'home', 12),
    _Entry('Casa de mascotas', 'Pet House', BuildingGroup.army, 'home', 14),
    _Entry('Aldeano constructor', 'Builder\'s Hut', BuildingGroup.army, 'home', 1),
    _Entry('Bomba', 'Bomb', BuildingGroup.traps, 'home', 1),
    _Entry('Trampa de muelle', 'Spring Trap', BuildingGroup.traps, 'home', 7),
    _Entry('Bomba aérea', 'Air Bomb', BuildingGroup.traps, 'home', 5),
    _Entry('Bomba gigante', 'Giant Bomb', BuildingGroup.traps, 'home', 8),
    _Entry('Mina buscadora', 'Seeking Air Mine', BuildingGroup.traps, 'home', 9),
    _Entry('Trampa de esqueletos', 'Skeleton Trap', BuildingGroup.traps, 'home', 8),
    _Entry('Trampa tornado', 'Tornado Trap', BuildingGroup.traps, 'home', 11),
    _Entry('Ayuntamiento del Constructor', 'Builder Hall', BuildingGroup.builderBase, 'builderBase', 1),
    _Entry('Cañón gemelo', 'Double Cannon', BuildingGroup.builderBase, 'builderBase', 1),
    _Entry('Cañón múltiple', 'Multi Mortar', BuildingGroup.builderBase, 'builderBase', 2),
    _Entry('Cañón aplastador', 'Crusher', BuildingGroup.builderBase, 'builderBase', 3),
    _Entry('Arco largo', 'Long Shot', BuildingGroup.builderBase, 'builderBase', 4),
    _Entry('Cañón de cañones', 'Multi Cannon', BuildingGroup.builderBase, 'builderBase', 5),
    _Entry('Horno', 'Roaster', BuildingGroup.builderBase, 'builderBase', 6),
    _Entry('Campamento del Constructor', 'Builder Army Camp', BuildingGroup.builderBase, 'builderBase', 1),
    _Entry('Cuartel del Constructor', 'Builder Barracks', BuildingGroup.builderBase, 'builderBase', 1),
    _Entry('Laboratorio del Constructor', 'Star Laboratory', BuildingGroup.builderBase, 'builderBase', 3),
    _Entry('Elixir del Constructor', 'Elixir Collector', BuildingGroup.builderBase, 'builderBase', 1),
    _Entry('Almacén del Constructor', 'Elixir Storage', BuildingGroup.builderBase, 'builderBase', 1),
    _Entry('Mina de gemas', 'Gem Mine', BuildingGroup.builderBase, 'builderBase', 1),
    _Entry('Mega Tesla', 'Mega Tesla', BuildingGroup.builderBase, 'builderBase', 8),
  ];

  static String imageNameFor(String displayName) {
    for (final entry in _entries) {
      if (entry.name == displayName) return entry.imageName;
    }
    return displayName;
  }

  static BuildingGroup groupFor(String name) {
    for (final entry in _entries) {
      if (entry.name == name) return entry.group;
    }
    return BuildingGroup.main;
  }

  static int unlockTownHallFor(String name, String village) {
    for (final entry in _entries) {
      if (entry.name == name && entry.village == village) {
        return entry.unlockLevel;
      }
    }
    return 1;
  }

  static String groupLabel(BuildingGroup group) => switch (group) {
        BuildingGroup.main => 'Principales',
        BuildingGroup.defense => 'Defensas',
        BuildingGroup.resource => 'Recursos',
        BuildingGroup.army => 'Ejército',
        BuildingGroup.traps => 'Trampas',
        BuildingGroup.builderBase => 'Base del constructor',
      };

  static Color groupColor(BuildingGroup group) => switch (group) {
        BuildingGroup.main => const Color(0xFF6A1B9A),
        BuildingGroup.defense => const Color(0xFFC62828),
        BuildingGroup.resource => const Color(0xFFF9A825),
        BuildingGroup.army => const Color(0xFF1565C0),
        BuildingGroup.traps => const Color(0xFF546E7A),
        BuildingGroup.builderBase => const Color(0xFF2E7D32),
      };

  static List<({String name, BuildingGroup group, String village, int unlockLevel})>
      allEntries() {
    return _entries
        .map(
          (e) => (
            name: e.name,
            group: e.group,
            village: e.village,
            unlockLevel: e.unlockLevel,
          ),
        )
        .toList();
  }
}

class _Entry {
  final String name;
  final String imageName;
  final BuildingGroup group;
  final String village;
  final int unlockLevel;

  const _Entry(
    this.name,
    this.imageName,
    this.group,
    this.village,
    this.unlockLevel,
  );
}

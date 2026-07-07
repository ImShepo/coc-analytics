import 'package:flutter/material.dart';

enum TroopGroup {
  elixir,
  darkElixir,
  builderBase,
  siege,
  pet,
  other,
}

enum SpellGroup {
  elixir,
  darkElixir,
  other,
}

class TroopCatalog {
  static const _darkElixirTroops = {
    'Minion',
    'Hog Rider',
    'Valkyrie',
    'Golem',
    'Witch',
    'Lava Hound',
    'Bowler',
    'Ice Golem',
    'Headhunter',
    'Druid',
    'Furnace',
    'Mole',
    'Apprentice Warden',
    'Super Minion',
    'Super Hog Rider',
    'Super Valkyrie',
    'Super Witch',
    'Super Bowler',
    'Super Miner',
  };

  static const _elixirTroops = {
    'Barbarian',
    'Archer',
    'Giant',
    'Goblin',
    'Wall Breaker',
    'Balloon',
    'Wizard',
    'Healer',
    'Dragon',
    'P.E.K.K.A',
    'Baby Dragon',
    'Miner',
    'Electro Dragon',
    'Yeti',
    'Dragon Rider',
    'Thrower',
    'Root Rider',
    'Super Barbarian',
    'Super Archer',
    'Super Giant',
    'Super Wall Breaker',
    'Super Wizard',
    'Super Dragon',
    'Rocket Balloon',
    'Super Warden',
    'Ice Hound',
  };

  static const _siegeMachines = {
    'Wall Wrecker',
    'Battle Blimp',
    'Stone Slammer',
    'Siege Barracks',
    'Log Launcher',
    'Flame Flinger',
    'Battle Drill',
    'Troop Launcher',
  };

  static const _pets = {
    'L.A.S.S.I',
    'Mighty Yak',
    'Electro Owl',
    'Unicorn',
    'Phoenix',
    'Poison Lizard',
    'Diggy',
    'Frosty',
    'Spirit Fox',
    'Angry Jelly',
    'Sneezy',
  };

  static const _darkElixirSpells = {
    'Poison Spell',
    'Earthquake Spell',
    'Haste Spell',
    'Skeleton Spell',
    'Bat Spell',
    'Overgrowth Spell',
    'Ice Block Spell',
  };

  static const _elixirSpells = {
    'Lightning Spell',
    'Healing Spell',
    'Rage Spell',
    'Jump Spell',
    'Freeze Spell',
    'Clone Spell',
    'Invisibility Spell',
    'Recall Spell',
    'Revive Spell',
  };

  static TroopGroup troopGroupFor(String name, String village) {
    if (village == 'builderBase') return TroopGroup.builderBase;
    if (_pets.contains(name)) return TroopGroup.pet;
    if (_siegeMachines.contains(name)) return TroopGroup.siege;
    if (_darkElixirTroops.contains(name)) return TroopGroup.darkElixir;
    if (_elixirTroops.contains(name)) return TroopGroup.elixir;
    return TroopGroup.other;
  }

  static SpellGroup spellGroupFor(String name) {
    if (_darkElixirSpells.contains(name)) return SpellGroup.darkElixir;
    if (_elixirSpells.contains(name)) return SpellGroup.elixir;
    return SpellGroup.other;
  }

  static String troopGroupLabel(TroopGroup group) => switch (group) {
        TroopGroup.elixir => 'Elixir',
        TroopGroup.darkElixir => 'Elixir oscuro',
        TroopGroup.builderBase => 'Base del constructor',
        TroopGroup.siege => 'Máquinas de asedio',
        TroopGroup.pet => 'Mascotas',
        TroopGroup.other => 'Otras tropas',
      };

  static String spellGroupLabel(SpellGroup group) => switch (group) {
        SpellGroup.elixir => 'Elixir',
        SpellGroup.darkElixir => 'Elixir oscuro',
        SpellGroup.other => 'Otros hechizos',
      };

  static Color troopGroupColor(TroopGroup group) => switch (group) {
        TroopGroup.elixir => const Color(0xFFD64DB3),
        TroopGroup.darkElixir => const Color(0xFF5C2D91),
        TroopGroup.builderBase => const Color(0xFF2E7D32),
        TroopGroup.siege => const Color(0xFF795548),
        TroopGroup.pet => const Color(0xFF00838F),
        TroopGroup.other => const Color(0xFF607D8B),
      };

  static Color spellGroupColor(SpellGroup group) => switch (group) {
        SpellGroup.elixir => const Color(0xFFD64DB3),
        SpellGroup.darkElixir => const Color(0xFF5C2D91),
        SpellGroup.other => const Color(0xFF607D8B),
      };

  static const troopDisplayOrder = [
    TroopGroup.elixir,
    TroopGroup.darkElixir,
    TroopGroup.builderBase,
    TroopGroup.siege,
    TroopGroup.pet,
    TroopGroup.other,
  ];

  static const spellDisplayOrder = [
    SpellGroup.elixir,
    SpellGroup.darkElixir,
    SpellGroup.other,
  ];
}

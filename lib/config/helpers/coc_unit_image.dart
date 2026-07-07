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

class CocUnitImage {
  static const _slugOverrides = {
    'P.E.K.K.A': 'pekka',
    'X-Bow': 'x-bow',
    'L.A.S.S.I': 'lassi',
    'Mighty Yak': 'mighty-yak',
    'Electro Owl': 'electro-owl',
    'Unicorn': 'unicorn',
    'Phoenix': 'phoenix',
    'Poison Lizard': 'poison-lizard',
    'Diggy': 'diggy',
    'Frosty': 'frosty',
    'Spirit Fox': 'spirit-fox',
    'Angry Jelly': 'angry-jelly',
    'Sneezy': 'sneezy',
  };

  static const _heroFiles = {
    'Barbarian King': 'home-base/hero-pics/Icon_HV_Hero_Barbarian_King.png',
    'Archer Queen': 'home-base/hero-pics/Icon_HV_Hero_Archer_Queen.png',
    'Grand Warden': 'home-base/hero-pics/Icon_HV_Hero_Grand_Warden.png',
    'Minion Prince': 'home-base/hero-pics/Icon_HV_Hero_Minion_Prince.png',
    'Royal Champion': 'home-base/hero-pics/Icon_HV_Hero_Royal_Champion.png',
    'Dragon Duke': 'home-base/hero-pics/Icon_HV_Hero_Dragon_Duke.webp',
    'Battle Machine':
        'builder-base/hero-pics/Icon_BB_Hero_Battle_Machine.png',
    'Battle Copter': 'builder-base/hero-pics/Icon_BB_Hero_Battle_Copter.png',
  };

  static const _spellFiles = {
    'Lightning Spell': 'home-base/spell-pics/Icon_HV_Spell_Lightning.png',
    'Healing Spell': 'home-base/spell-pics/Icon_HV_Spell_Heal.png',
    'Rage Spell': 'home-base/spell-pics/Icon_HV_Spell_Rage.png',
    'Jump Spell': 'home-base/spell-pics/Icon_HV_Spell_Jump.png',
    'Freeze Spell': 'home-base/spell-pics/Icon_HV_Spell_Freeze.png',
    'Clone Spell': 'home-base/spell-pics/Icon_HV_Spell_Clone.png',
    'Invisibility Spell': 'home-base/spell-pics/Icon_HV_Spell_Invisibility.png',
    'Recall Spell': 'home-base/spell-pics/Icon_HV_Spell_Recall.png',
    'Revive Spell': 'home-base/spell-pics/Icon_HV_Spell_Hero_Revive_Potion.png',
    'Poison Spell': 'home-base/spell-pics/Icon_HV_Dark_Spell_Poison.png',
    'Earthquake Spell': 'home-base/spell-pics/Icon_HV_Dark_Spell_Earthquake.png',
    'Haste Spell': 'home-base/spell-pics/Icon_HV_Dark_Spell_Haste.png',
    'Skeleton Spell': 'home-base/spell-pics/Icon_HV_Dark_Spell_Skeleton.png',
    'Bat Spell': 'home-base/spell-pics/Icon_HV_Dark_Spell_Bat.png',
    'Overgrowth Spell': 'home-base/spell-pics/Icon_HV_Dark_Spell_Overgrowth.png',
    'Ice Block Spell': 'home-base/spell-pics/Icon_HV_Dark_Spell_Ice_block.png',
  };

  static const _equipmentFiles = {
    'Barbarian Puppet': 'home-base/equipment-pics/Hero_Equipment_BK_Barbarian_Puppet.png',
    'Rage Vial': 'home-base/equipment-pics/Hero_Equipment_BK_Rage_Vial.png',
    'Archer Puppet': 'home-base/equipment-pics/Hero_Equipment_AQ_Archer_Puppet.png',
    'Invisibility Vial': 'home-base/equipment-pics/Hero_Equipment_AQ_Invisibility_Vial.png',
    'Eternal Tome': 'home-base/equipment-pics/Hero_Equipment_GW_Eternal_Tome.png',
    'Life Gem': 'home-base/equipment-pics/Hero_Equipment_GW_Life_Gem.png',
    'Seeking Shield': 'home-base/equipment-pics/Hero_Equipment_RC_Seeking_Shield.png',
    'Royal Gem': 'home-base/equipment-pics/Hero_Equipment_RC_Royal_Gem.png',
    'Earthquake Boots': 'home-base/equipment-pics/Hero_Equipment_BK_Earthquake_Boots.png',
    'Giant Gauntlet': 'home-base/equipment-pics/Hero_Equipment_BK_Giant_Gauntlet.png',
    'Vampstache': 'home-base/equipment-pics/Hero_Equipment_BK_Vampstache.png',
    'Spiky Ball': 'home-base/equipment-pics/Hero_Equipment_BK_Spiky_Ball.png',
    'Snake Bracelet': 'home-base/equipment-pics/Hero_Equipment_BK_Snake_Bracelet.png',
    'Frozen Arrow': 'home-base/equipment-pics/Hero_Equipment_AQ_Frozen_Arrow.png',
    'Giant Arrow': 'home-base/equipment-pics/Hero_Equipment_AQ_Giant_Arrow.png',
    'Healer Puppet': 'home-base/equipment-pics/Hero_Equipment_AQ_Healer_Puppet.png',
    'Magic Mirror': 'home-base/equipment-pics/Hero_Equipment_AQ_Magic_Mirror.png',
    'Fireball': 'home-base/equipment-pics/Hero_Equipment_GW_Fireball.png',
    'Healing Tome': 'home-base/equipment-pics/Hero_Equipment_GW_Healing_Tome.png',
    'Lavaloon Puppet': 'home-base/equipment-pics/Hero_Equipment_GW_Lavaloon_Puppet.png',
    'Rage Gem': 'home-base/equipment-pics/Hero_Equipment_GW_Rage_Gem.png',
    'Electro Boots': 'home-base/equipment-pics/Hero_Equipment_RC_Electro_Boots.png',
    'Haste Vial': 'home-base/equipment-pics/Hero_Equipment_RC_Haste_Vial.png',
    'Hog Rider Doll': 'home-base/equipment-pics/Hero_Equipment_RC_Hog_Rider_Doll.png',
    'Rocket Spear': 'home-base/equipment-pics/Hero_Equipment_RC_Rocket_Spear.png',
    'Snow Flake': 'home-base/equipment-pics/Hero_Equipment_RC_Snow_Flake.png',
    'Dark Crown': 'home-base/equipment-pics/Hero_Equipment_MP_Dark_Crown.png',
    'Dark Orb': 'home-base/equipment-pics/Hero_Equipment_MP_Dark_Orb.png',
    'Henchman Puppet': 'home-base/equipment-pics/Hero_Equipment_MP_Henchman.png',
    'Metal Pants': 'home-base/equipment-pics/Hero_Equipment_MP_Metal_Pants.png',
    'Meteor Staff': 'home-base/equipment-pics/Hero_Equipment_MP_Meteor_Staff.png',
    'Noble Iron': 'home-base/equipment-pics/Hero_Equipment_MP_Noble_Iron.png',
  };

  static const _buildingFilePrefixes = {
    'Army Camp': 'troop-housing',
  };

  static const _buildingSlugs = {
    'Town Hall': 'town-hall',
    'Town Hall Weapon': 'multi-gear-tower',
    'Cannon': 'cannon',
    'Archer Tower': 'archer-tower',
    'Mortar': 'mortar',
    'Air Defense': 'air-defense',
    'Wizard Tower': 'wizard-tower',
    'Air Sweeper': 'air-sweeper',
    'Hidden Tesla': 'hidden-tesla',
    'Bomb Tower': 'bomb-tower',
    'X-Bow': 'x-bow',
    'Inferno Tower': 'inferno-tower',
    'Eagle Artillery': 'eagle-artillery',
    'Scattershot': 'scattershot',
    'Monolith': 'monolith',
    'Spell Tower': 'spell-tower',
    'Gold Mine': 'gold-mine',
    'Elixir Collector': 'elixir-collector',
    'Dark Elixir Drill': 'dark-elixir-drill',
    'Gold Storage': 'gold-storage',
    'Elixir Storage': 'elixir-storage',
    'Dark Elixir Storage': 'dark-elixir-storage',
    'Clan Castle': 'clan-castle',
    'Army Camp': 'army-camp',
    'Barracks': 'barracks',
    'Dark Barracks': 'dark-barracks',
    'Laboratory': 'laboratory',
    'Spell Factory': 'spell-factory',
    'Dark Spell Factory': 'dark-spell-factory',
    'Workshop': 'workshop',
    'Pet House': 'pet-house',
    "Builder's Hut": 'builders-hut',
    'Builder Hall': 'builder-hall',
    'Double Cannon': 'double-cannon',
    'Multi Mortar': 'multi-mortar',
    'Crusher': 'crusher',
    'Multi Cannon': 'giant-cannon',
    'Roaster': 'roaster',
    'Builder Barracks': 'builder-barracks',
    'Star Laboratory': 'star-laboratory',
    'Gem Mine': 'gem-mine',
    'Mega Tesla': 'mega-tesla',
    'Long Shot': 'longshot',
  };

  static const _trapSlugs = {
    'Bomb': 'bomb',
    'Spring Trap': 'spring-trap',
    'Air Bomb': 'air-bomb',
    'Giant Bomb': 'giant-bomb',
    'Seeking Air Mine': 'seeking-air-mine',
    'Skeleton Trap': 'skeleton-trap',
    'Tornado Trap': 'tornado-trap',
  };

  static const _siegeFiles = {
    'Wall Wrecker': 'home-base/siege-machine-pics/Icon_HV_Siege_Machine_Wall_Wrecker.png',
    'Battle Blimp': 'home-base/siege-machine-pics/Icon_HV_Siege_Machine_Battle_Blimp.png',
    'Stone Slammer': 'home-base/siege-machine-pics/Icon_HV_Siege_Machine_Stone_Slammer.png',
    'Siege Barracks': 'home-base/siege-machine-pics/Icon_HV_Siege_Machine_Siege_Barracks.png',
    'Log Launcher': 'home-base/siege-machine-pics/Icon_HV_Siege_Machine_Log_Launcher.png',
    'Flame Flinger': 'home-base/siege-machine-pics/Icon_HV_Siege_Machine_Flame_Flinger.png',
    'Battle Drill': 'home-base/siege-machine-pics/Icon_HV_Siege_Machine_Battle_Drill.png',
    'Troop Launcher': 'home-base/siege-machine-pics/Icon_HV_Siege_Machine_Troop_Launcher.png',
  };

  static const _superTroopFiles = {
    'Super Barbarian': 'home-base/super-troop-pics/Icon_HV_Super_Barbarian.png',
    'Super Archer': 'home-base/super-troop-pics/Icon_HV_Super_Archer.png',
    'Super Giant': 'home-base/super-troop-pics/Icon_HV_Super_Giant.png',
    'Super Wall Breaker': 'home-base/super-troop-pics/Icon_HV_Super_Wall_Breaker.png',
    'Super Wizard': 'home-base/super-troop-pics/Icon_HV_Super_Wizard.png',
    'Super Dragon': 'home-base/super-troop-pics/Icon_HV_Super_Dragon.png',
    'Super Minion': 'home-base/super-troop-pics/Icon_HV_Super_Minion.png',
    'Super Hog Rider': 'home-base/super-troop-pics/Icon_HV_Super_Hog_Rider.png',
    'Super Valkyrie': 'home-base/super-troop-pics/Icon_HV_Super_Valkyrie.png',
    'Super Witch': 'home-base/super-troop-pics/Icon_HV_Super_Witch.png',
    'Super Bowler': 'home-base/super-troop-pics/Icon_HV_Super_Bowler.png',
    'Super Miner': 'home-base/super-troop-pics/Icon_HV_Super_Miner.png',
    'Rocket Balloon': 'home-base/super-troop-pics/Icon_HV_Rocket_Balloon.png',
    'Ice Hound': 'home-base/super-troop-pics/Icon_HV_Ice_Hound.png',
  };

  static const _troopsWithAltCharacter = {
    'apprentice-warden',
    'azure-dragon',
    'barcher',
    'battle-drill',
    'cookie',
    'druid',
    'electro-dragon',
    'flame-flinger',
    'giant-giant',
    'giant-skeleton',
    'giant-thrower',
    'hog-wizard',
    'ice-golem',
    'ice-wizard',
    'inferno-dragon',
    'lava-hound',
    'lavaloon',
    'log-launcher',
    'party-wizard',
    'ram-rider',
    'siege-barracks',
    'sneaky-goblin',
    'super-hog-rider',
    'super-miner',
    'super-minion',
    'super-valkyrie',
    'super-witch',
    'super-wizard',
    'thrower',
    'troop-launcher',
    'wall-wrecker',
    'witch-golem',
    'yeti',
  };

  static const _petSlugs = {
    'L.A.S.S.I': 'lassi',
    'Mighty Yak': 'mighty_yak',
    'Electro Owl': 'electro_owl',
    'Unicorn': 'unicorn',
    'Phoenix': 'phoenix',
    'Poison Lizard': 'poison_lizard',
    'Diggy': 'diggy',
    'Frosty': 'frosty',
    'Spirit Fox': 'spirit_fox',
    'Angry Jelly': 'angry_jelly',
    'Sneezy': 'sneezy',
  };

  static String slugFor(String name) {
    if (_slugOverrides.containsKey(name)) {
      return _slugOverrides[name]!;
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

  static String troopSlugFor(String name) {
    return name
        .toLowerCase()
        .replaceAll("'s ", ' ')
        .replaceAll("'s", 's')
        .replaceAll('.', '')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

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
    final cdn = 'https://assets.clashk.ing';

    return switch (category) {
      UnitCategory.hero => _heroUrls(cdn: cdn, name: name, level: level),
      UnitCategory.spell => _fixedUrls(cdn, _spellFiles[name]),
      UnitCategory.equipment => _fixedUrls(cdn, _equipmentFiles[name]),
      UnitCategory.building => _buildingUrls(
          cdn: cdn,
          name: displayName,
          level: level,
          village: village,
          buildingGroup: buildingGroup,
        ),
      UnitCategory.troop => _troopUrls(
          cdn: cdn,
          name: name,
          level: level,
          maxLevel: maxLevel,
          village: village,
          troopGroup: troopGroup,
        ),
    };
  }

  static List<String> _heroUrls({
    required String cdn,
    required String name,
    required int level,
  }) {
    final slug = slugFor(name);
    final useAlt = level >= 2;
    return [
      ..._fixedUrls(cdn, _heroFiles[name]),
      if (useAlt) '$cdn/home-base/heroes/$slug/$slug-character-2.png',
      '$cdn/home-base/heroes/$slug/$slug-character.png',
      '$cdn/home-base/heroes/$slug/$slug-icon.png',
    ];
  }

  static List<String> _fixedUrls(String cdn, String? path) {
    if (path == null) return [];
    return ['$cdn/$path'];
  }

  static List<String> _buildingUrls({
    required String cdn,
    required String name,
    required int level,
    required String village,
    BuildingGroup? buildingGroup,
  }) {
    if (buildingGroup == BuildingGroup.traps) {
      final slug = _trapSlugs[name] ?? slugFor(name);
      final lvl = level.clamp(1, 9);
      return [
        '$cdn/home-base/traps/$slug/$slug-$lvl.png',
        '$cdn/home-base/traps/$slug/$slug-1.png',
      ];
    }

    if (name == 'Long Shot') {
      return ['$cdn/guardians/longshot/icon.webp'];
    }

    final slug = _buildingSlugs[name] ?? slugFor(name);
    final filePrefix = _buildingFilePrefixes[name] ?? slug;
    final lvl = level.clamp(1, 20);
    final base = village == 'builderBase'
        ? '$cdn/builder-base/buildings/$slug'
        : '$cdn/home-base/buildings/$slug';

    return [
      '$base/$filePrefix-$lvl.png',
      '$base/$filePrefix-1.png',
      '$base/$slug-$lvl.png',
      '$base/$slug-1.png',
      '$cdn/home-base/town-hall-pics/town-hall-$lvl.png',
    ];
  }

  static List<String> _troopUrls({
    required String cdn,
    required String name,
    required int level,
    required int maxLevel,
    required String village,
    TroopGroup? troopGroup,
  }) {
    if (troopGroup == TroopGroup.pet) {
      final slug = _petSlugs[name] ?? troopSlugFor(name);
      return [
        '$cdn/pets/$slug/icon.webp',
        '$cdn/pets/${slug.replaceAll('_', '-')}/icon.webp',
      ];
    }

    if (troopGroup == TroopGroup.siege) {
      final slug = slugFor(name);
      final useAlt =
          _useAltCharacter(level, maxLevel) && _troopsWithAltCharacter.contains(slug);
      return [
        if (useAlt)
          '$cdn/home-base/troops/$slug/$slug-character-2.png',
        '$cdn/home-base/troops/$slug/$slug-character.png',
        ..._fixedUrls(cdn, _siegeFiles[name]),
        '$cdn/troops/${troopSlugFor(name)}/icon.webp',
      ];
    }

    if (name.startsWith('Super ') || _superTroopFiles.containsKey(name)) {
      final slug = slugFor(name);
      final useAlt =
          _useAltCharacter(level, maxLevel) && _troopsWithAltCharacter.contains(slug);
      return [
        if (useAlt)
          '$cdn/home-base/troops/$slug/$slug-character-2.png',
        '$cdn/home-base/troops/$slug/$slug-character.png',
        ..._fixedUrls(cdn, _superTroopFiles[name]),
        '$cdn/troops/${troopSlugFor(name)}/icon.webp',
      ];
    }

    final slug = slugFor(name);
    final useAlt =
        _useAltCharacter(level, maxLevel) && _troopsWithAltCharacter.contains(slug);

    if (village == 'builderBase') {
      return [
        '$cdn/builder-base/troops/$slug/$slug-character.png',
        if (level >= 2)
          '$cdn/builder-base/troops/$slug/$slug-character-2.png',
        '$cdn/troops/${troopSlugFor(name)}/icon.webp',
      ];
    }

    return [
      '$cdn/home-base/troops/$slug/$slug-character.png',
      if (useAlt) '$cdn/home-base/troops/$slug/$slug-character-2.png',
      '$cdn/home-base/troops/$slug/$slug-icon.png',
      '$cdn/troops/${troopSlugFor(name)}/icon.webp',
      '$cdn/home-base/troop-pics/Icon_HV_${name.replaceAll(' ', '_').replaceAll('.', '')}.png',
    ];
  }

  static bool _useAltCharacter(int level, int maxLevel) {
    if (level < 2) return false;
    if (maxLevel <= 1) return level >= 2;
    return level >= (maxLevel / 2).ceil();
  }
}

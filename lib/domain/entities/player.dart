class Player {
  String tag;
  String name;
  int townHallLevel;
  int townHallWeaponLevel;
  int expLevel;
  int trophies;
  int bestTrophies;
  int warStars;
  int attackWins;
  int defenseWins;
  int builderHallLevel;
  int builderBaseTrophies;
  int bestBuilderBaseTrophies;
  String role;
  String warPreference;
  int donations;
  int donationsReceived;
  int clanCapitalContributions;
  Clan clan;
  League league;
  BuilderBaseLeague builderBaseLeague;
  LegendStatistics legendStatistics;
  List<Achievement> achievements;
  PlayerHouse playerHouse;
  List<Label> labels;
  List<HeroEquipment> troops;
  List<HeroEquipment> heroes;
  List<HeroEquipment> heroEquipment;
  List<HeroEquipment> spells;

  Player({
    required this.tag,
    required this.name,
    required this.townHallLevel,
    required this.townHallWeaponLevel,
    required this.expLevel,
    required this.trophies,
    required this.bestTrophies,
    required this.warStars,
    required this.attackWins,
    required this.defenseWins,
    required this.builderHallLevel,
    required this.builderBaseTrophies,
    required this.bestBuilderBaseTrophies,
    required this.role,
    required this.warPreference,
    required this.donations,
    required this.donationsReceived,
    required this.clanCapitalContributions,
    required this.clan,
    required this.league,
    required this.builderBaseLeague,
    required this.legendStatistics,
    required this.achievements,
    required this.playerHouse,
    required this.labels,
    required this.troops,
    required this.heroes,
    required this.heroEquipment,
    required this.spells,
  });

}

class Achievement {
  String name;
  int stars;
  int value;
  int target;
  String info;
  String? completionInfo;
  String village;

  Achievement({
    required this.name,
    required this.stars,
    required this.value,
    required this.target,
    required this.info,
    required this.completionInfo,
    required this.village,
  });

}

class BuilderBaseLeague {
  int id;
  String name;

  BuilderBaseLeague({
    required this.id,
    required this.name,
  });

}

class Clan {
  String tag;
  String name;
  int clanLevel;
  BadgeUrls badgeUrls;

  Clan({
    required this.tag,
    required this.name,
    required this.clanLevel,
    required this.badgeUrls,
  });

}

class BadgeUrls {
  String small;
  String large;
  String medium;

  BadgeUrls({
    required this.small,
    required this.large,
    required this.medium,
  });

}

class HeroEquipment {
  String name;
  int level;
  int maxLevel;
  String village;
  List<HeroEquipment>? equipment;
  bool superTroopIsActive;

  HeroEquipment({
    required this.name,
    required this.level,
    required this.maxLevel,
    required this.village,
    this.equipment,
    this.superTroopIsActive = false,
  });

}

class Label {
  int id;
  String name;
  LabelIconUrls iconUrls;

  Label({
    required this.id,
    required this.name,
    required this.iconUrls,
  });

}

class LabelIconUrls {
  String small;
  String medium;

  LabelIconUrls({
    required this.small,
    required this.medium,
  });

}

class League {
  int id;
  String name;
  LeagueIconUrls iconUrls;

  League({
    required this.id,
    required this.name,
    required this.iconUrls,
  });

}

class LeagueIconUrls {
  String small;
  String tiny;
  String medium;

  LeagueIconUrls({
    required this.small,
    required this.tiny,
    required this.medium,
  });

}

class LegendStatistics {
  int legendTrophies;
  Season previousSeason;
  Season bestSeason;
  CurrentSeason currentSeason;

  LegendStatistics({
    required this.legendTrophies,
    required this.previousSeason,
    required this.bestSeason,
    required this.currentSeason,
  });

}

class Season {
  String id;
  int rank;
  int trophies;

  Season({
    required this.id,
    required this.rank,
    required this.trophies,
  });

}

class CurrentSeason {
  int rank;
  int trophies;

  CurrentSeason({
    required this.rank,
    required this.trophies,
  });

}

class PlayerHouse {
  List<Element> elements;

  PlayerHouse({
    required this.elements,
  });

}

class Element {
  String type;
  int id;

  Element({
    required this.type,
    required this.id,
  });

}

class PlayerResponse {
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

  PlayerResponse({
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

  factory PlayerResponse.fromJson(Map<String, dynamic> json) => PlayerResponse(
        tag: json["tag"] as String,
        name: json["name"] as String,
        townHallLevel: json["townHallLevel"] as int? ?? 0,
        townHallWeaponLevel: json["townHallWeaponLevel"] as int? ?? 0,
        expLevel: json["expLevel"] as int? ?? 0,
        trophies: json["trophies"] as int? ?? 0,
        bestTrophies: json["bestTrophies"] as int? ?? 0,
        warStars: json["warStars"] as int? ?? 0,
        attackWins: json["attackWins"] as int? ?? 0,
        defenseWins: json["defenseWins"] as int? ?? 0,
        builderHallLevel: json["builderHallLevel"] as int? ?? 0,
        builderBaseTrophies: json["builderBaseTrophies"] as int? ?? 0,
        bestBuilderBaseTrophies: json["bestBuilderBaseTrophies"] as int? ?? 0,
        role: json["role"] as String? ?? '',
        warPreference: json["warPreference"] as String? ?? 'unknown',
        donations: json["donations"] as int? ?? 0,
        donationsReceived: json["donationsReceived"] as int? ?? 0,
        clanCapitalContributions: json["clanCapitalContributions"] as int? ?? 0,
        clan: json["clan"] != null
            ? Clan.fromJson(json["clan"] as Map<String, dynamic>)
            : _emptyClan(),
        league: json["league"] != null
            ? League.fromJson(json["league"] as Map<String, dynamic>)
            : _leagueFromTier(json["leagueTier"]),
        builderBaseLeague: json["builderBaseLeague"] != null
            ? BuilderBaseLeague.fromJson(
                json["builderBaseLeague"] as Map<String, dynamic>)
            : BuilderBaseLeague(id: 0, name: 'Unranked'),
        legendStatistics: json["legendStatistics"] != null
            ? LegendStatistics.fromJson(
                json["legendStatistics"] as Map<String, dynamic>)
            : _emptyLegendStatistics(),
        achievements: (json["achievements"] as List?)
                ?.map((e) => Achievement.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        playerHouse: json["playerHouse"] != null
            ? PlayerHouse.fromJson(json["playerHouse"] as Map<String, dynamic>)
            : PlayerHouse(elements: []),
        labels: (json["labels"] as List?)
                ?.map((e) => Label.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        troops: (json["troops"] as List?)
                ?.map((e) => HeroEquipment.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        heroes: (json["heroes"] as List?)
                ?.map((e) => HeroEquipment.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        heroEquipment: (json["heroEquipment"] as List?)
                ?.map((e) => HeroEquipment.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        spells: (json["spells"] as List?)
                ?.map((e) => HeroEquipment.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  static Clan _emptyClan() => Clan(
        tag: '',
        name: 'Sin clan',
        clanLevel: 0,
        badgeUrls: BadgeUrls(small: '', large: '', medium: ''),
      );

  static League _leagueFromTier(dynamic tier) {
    if (tier is! Map<String, dynamic>) {
      return League(
        id: 0,
        name: 'Unranked',
        iconUrls: LeagueIconUrls(small: '', tiny: '', medium: ''),
      );
    }

    final icons = tier['iconUrls'] as Map<String, dynamic>?;
    return League(
      id: tier['id'] as int? ?? 0,
      name: tier['name'] as String? ?? 'Unranked',
      iconUrls: LeagueIconUrls(
        small: icons?['small'] as String? ?? '',
        tiny: icons?['small'] as String? ?? '',
        medium: (icons?['large'] ?? icons?['medium'] ?? '') as String,
      ),
    );
  }

  static LegendStatistics _emptyLegendStatistics() => LegendStatistics(
        legendTrophies: 0,
        previousSeason: Season(id: '', rank: 0, trophies: 0),
        bestSeason: Season(id: '', rank: 0, trophies: 0),
        currentSeason: CurrentSeason(rank: 0, trophies: 0),
      );

  Map<String, dynamic> toJson() => {
        "tag": tag,
        "name": name,
        "townHallLevel": townHallLevel,
        "townHallWeaponLevel": townHallWeaponLevel,
        "expLevel": expLevel,
        "trophies": trophies,
        "bestTrophies": bestTrophies,
        "warStars": warStars,
        "attackWins": attackWins,
        "defenseWins": defenseWins,
        "builderHallLevel": builderHallLevel,
        "builderBaseTrophies": builderBaseTrophies,
        "bestBuilderBaseTrophies": bestBuilderBaseTrophies,
        "role": role,
        "warPreference": warPreference,
        "donations": donations,
        "donationsReceived": donationsReceived,
        "clanCapitalContributions": clanCapitalContributions,
        "clan": clan.toJson(),
        "league": league.toJson(),
        "builderBaseLeague": builderBaseLeague.toJson(),
        "legendStatistics": legendStatistics.toJson(),
        "achievements": achievements.map((e) => e.toJson()).toList(),
        "playerHouse": playerHouse.toJson(),
        "labels": labels.map((e) => e.toJson()).toList(),
        "troops": troops.map((e) => e.toJson()).toList(),
        "heroes": heroes.map((e) => e.toJson()).toList(),
        "heroEquipment": heroEquipment.map((e) => e.toJson()).toList(),
        "spells": spells.map((e) => e.toJson()).toList(),
      };
}

// Repeat for each class below

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
    this.completionInfo,
    required this.village,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
        name: json["name"] as String? ?? '',
        stars: json["stars"] as int? ?? 0,
        value: json["value"] as int? ?? 0,
        target: json["target"] as int? ?? 0,
        info: json["info"] as String? ?? '',
        completionInfo: json["completionInfo"] as String?,
        village: json["village"] as String? ?? 'home',
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "stars": stars,
        "value": value,
        "target": target,
        "info": info,
        "completionInfo": completionInfo,
        "village": village,
      };
}

class BuilderBaseLeague {
  int id;
  String name;

  BuilderBaseLeague({
    required this.id,
    required this.name,
  });

  factory BuilderBaseLeague.fromJson(Map<String, dynamic> json) => BuilderBaseLeague(
        id: json["id"] as int? ?? 0,
        name: json["name"] as String? ?? 'Unranked',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
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

  factory Clan.fromJson(Map<String, dynamic> json) => Clan(
        tag: json["tag"] as String? ?? '',
        name: json["name"] as String? ?? '',
        clanLevel: json["clanLevel"] as int? ?? 0,
        badgeUrls: json["badgeUrls"] != null
            ? BadgeUrls.fromJson(json["badgeUrls"] as Map<String, dynamic>)
            : BadgeUrls(small: '', large: '', medium: ''),
      );

  Map<String, dynamic> toJson() => {
        "tag": tag,
        "name": name,
        "clanLevel": clanLevel,
        "badgeUrls": badgeUrls.toJson(),
      };
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

  factory BadgeUrls.fromJson(Map<String, dynamic> json) => BadgeUrls(
        small: json["small"] as String? ?? '',
        large: json["large"] as String? ?? '',
        medium: json["medium"] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        "small": small,
        "large": large,
        "medium": medium,
      };
}

class HeroEquipment {
  String name;
  int level;
  int maxLevel;
  String village;
  List<HeroEquipment>? equipment;

  HeroEquipment({
    required this.name,
    required this.level,
    required this.maxLevel,
    required this.village,
    this.equipment,
  });

  factory HeroEquipment.fromJson(Map<String, dynamic> json) => HeroEquipment(
        name: json["name"] as String? ?? '',
        level: json["level"] as int? ?? 0,
        maxLevel: json["maxLevel"] as int? ?? 0,
        village: json["village"] as String? ?? '',
        equipment: json["equipment"] != null
            ? (json["equipment"] as List)
                .whereType<Map<String, dynamic>>()
                .map(HeroEquipment.fromJson)
                .toList()
            : null,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "level": level,
        "maxLevel": maxLevel,
        "village": village,
        "equipment": equipment?.map((e) => e.toJson()).toList(),
      };
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

  factory Label.fromJson(Map<String, dynamic> json) => Label(
        id: json["id"] as int? ?? 0,
        name: json["name"] as String? ?? '',
        iconUrls: json["iconUrls"] != null
            ? LabelIconUrls.fromJson(json["iconUrls"] as Map<String, dynamic>)
            : LabelIconUrls(small: '', medium: ''),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "iconUrls": iconUrls.toJson(),
      };
}

class LabelIconUrls {
  String small;
  String medium;

  LabelIconUrls({
    required this.small,
    required this.medium,
  });

  factory LabelIconUrls.fromJson(Map<String, dynamic> json) => LabelIconUrls(
        small: json["small"] as String? ?? '',
        medium: json["medium"] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        "small": small,
        "medium": medium,
      };
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

  factory League.fromJson(Map<String, dynamic> json) => League(
        id: json["id"] as int? ?? 0,
        name: json["name"] as String? ?? 'Unranked',
        iconUrls: json["iconUrls"] != null
            ? LeagueIconUrls.fromJson(json["iconUrls"] as Map<String, dynamic>)
            : LeagueIconUrls(small: '', tiny: '', medium: ''),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "iconUrls": iconUrls.toJson(),
      };
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

  factory LeagueIconUrls.fromJson(Map<String, dynamic> json) => LeagueIconUrls(
        small: json["small"] ?? '',
        tiny: json["tiny"] ?? '',
        medium: json["medium"] ?? 'http://clash-wiki.com/images/progress/leagues/no_league.png',
      );

  Map<String, dynamic> toJson() => {
        "small": small,
        "tiny": tiny,
        "medium": medium,
      };
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

  factory LegendStatistics.fromJson(Map<String, dynamic> json) => LegendStatistics(
        legendTrophies: json["legendTrophies"] as int? ?? 0,
        previousSeason: json["previousSeason"] != null
            ? Season.fromJson(json["previousSeason"] as Map<String, dynamic>)
            : Season(id: '', rank: 0, trophies: 0),
        bestSeason: json["bestSeason"] != null
            ? Season.fromJson(json["bestSeason"] as Map<String, dynamic>)
            : Season(id: '', rank: 0, trophies: 0),
        currentSeason: json["currentSeason"] != null
            ? CurrentSeason.fromJson(json["currentSeason"] as Map<String, dynamic>)
            : CurrentSeason(rank: 0, trophies: 0),
      );

  Map<String, dynamic> toJson() => {
        "legendTrophies": legendTrophies,
        "previousSeason": previousSeason.toJson(),
        "bestSeason": bestSeason.toJson(),
        "currentSeason": currentSeason.toJson(),
      };
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

  factory Season.fromJson(Map<String, dynamic> json) => Season(
        id: json["id"] as String? ?? '',
        rank: json["rank"] as int? ?? 0,
        trophies: json["trophies"] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rank": rank,
        "trophies": trophies,
      };
}

class CurrentSeason {
  int rank;
  int trophies;

  CurrentSeason({
    required this.rank,
    required this.trophies,
  });

  factory CurrentSeason.fromJson(Map<String, dynamic> json) => CurrentSeason(
        rank: json["rank"] as int? ?? 0,
        trophies: json["trophies"] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "rank": rank,
        "trophies": trophies,
      };
}

class PlayerHouse {
  List<Element> elements;

  PlayerHouse({
    required this.elements,
  });

  factory PlayerHouse.fromJson(Map<String, dynamic> json) => PlayerHouse(
        elements: (json["elements"] as List?)
                ?.whereType<Map<String, dynamic>>()
                .map(Element.fromJson)
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        "elements": elements.map((e) => e.toJson()).toList(),
      };
}

class Element {
  String type;
  int id;

  Element({
    required this.type,
    required this.id,
  });

  factory Element.fromJson(Map<String, dynamic> json) => Element(
        type: json["type"] as String? ?? '',
        id: json["id"] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
      };
}

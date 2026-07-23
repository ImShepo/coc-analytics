import 'package:coc/domain/entities/clan_war_log.dart';

class ClanWarLogResponse {
  final List<ClanWarLogEntry> items;

  const ClanWarLogResponse({required this.items});

  factory ClanWarLogResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['items'] as List? ?? const [];
    return ClanWarLogResponse(
      items: raw
          .whereType<Map<String, dynamic>>()
          .map(ClanWarLogEntryParser.fromJson)
          .toList(),
    );
  }
}

class ClanWarLogEntryParser {
  static ClanWarLogEntry fromJson(Map<String, dynamic> json) {
    return ClanWarLogEntry(
      result: json['result'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      teamSize: json['teamSize'] as int? ?? 0,
      attacksPerMember: json['attacksPerMember'] as int? ?? 0,
      clan: ClanWarLogSideParser.fromJson(
        json['clan'] as Map<String, dynamic>? ?? const {},
      ),
      opponent: ClanWarLogSideParser.fromJson(
        json['opponent'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}

class ClanWarLogSideParser {
  static ClanWarLogSide fromJson(Map<String, dynamic> json) {
    final badges = json['badgeUrls'] as Map<String, dynamic>?;
    return ClanWarLogSide(
      tag: json['tag'] as String? ?? '',
      name: json['name'] as String? ?? '',
      badgeUrl: (badges?['medium'] ?? badges?['small'] ?? '') as String,
      clanLevel: json['clanLevel'] as int? ?? 0,
      attacks: json['attacks'] as int? ?? 0,
      stars: json['stars'] as int? ?? 0,
      destructionPercentage:
          (json['destructionPercentage'] as num?)?.toDouble() ?? 0,
      expEarned: json['expEarned'] as int? ?? 0,
    );
  }
}

class CapitalRaidSeasonsResponse {
  final List<CapitalRaidSeason> items;

  const CapitalRaidSeasonsResponse({required this.items});

  factory CapitalRaidSeasonsResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['items'] as List? ?? const [];
    return CapitalRaidSeasonsResponse(
      items: raw
          .whereType<Map<String, dynamic>>()
          .map(CapitalRaidSeasonParser.fromJson)
          .toList(),
    );
  }
}

class CapitalRaidSeasonParser {
  static CapitalRaidSeason fromJson(Map<String, dynamic> json) {
    return CapitalRaidSeason(
      state: json['state'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      capitalTotalLoot: json['capitalTotalLoot'] as int? ?? 0,
      raidsCompleted: json['raidsCompleted'] as int? ?? 0,
      totalAttacks: json['totalAttacks'] as int? ?? 0,
      enemyDistrictsDestroyed: json['enemyDistrictsDestroyed'] as int? ?? 0,
      offensiveReward: json['offensiveReward'] as int? ?? 0,
      defensiveReward: json['defensiveReward'] as int? ?? 0,
    );
  }
}

import 'package:coc/domain/entities/current_clan_war.dart';

class CurrentClanWarParser {
  static CurrentClanWar fromJson(Map<String, dynamic> json) {
    return CurrentClanWar(
      state: _state(json['state'] as String?),
      teamSize: json['teamSize'] as int? ?? 0,
      attacksPerMember: json['attacksPerMember'] as int? ?? 0,
      preparationStartTime: parseCocTime(json['preparationStartTime'] as String?),
      startTime: parseCocTime(json['startTime'] as String?),
      endTime: parseCocTime(json['endTime'] as String?),
      clan: _clan(json['clan']),
      opponent: _clan(json['opponent']),
    );
  }

  static ClanWarState _state(String? raw) {
    return switch (raw) {
      'notInWar' => ClanWarState.notInWar,
      'preparation' => ClanWarState.preparation,
      'inWar' => ClanWarState.inWar,
      'warEnded' => ClanWarState.warEnded,
      _ => ClanWarState.unknown,
    };
  }

  static CurrentWarClan? _clan(dynamic raw) {
    if (raw is! Map) return null;
    final json = Map<String, dynamic>.from(raw);
    if ((json['tag'] as String?)?.isEmpty ?? true) {
      if (json['members'] == null && json['name'] == null) return null;
    }
    final badges = json['badgeUrls'] as Map?;
    final membersRaw = json['members'] as List? ?? const [];
    return CurrentWarClan(
      tag: json['tag'] as String? ?? '',
      name: json['name'] as String? ?? '',
      badgeUrl: (badges?['medium'] ?? badges?['small'] ?? '') as String? ?? '',
      attacks: json['attacks'] as int? ?? 0,
      stars: json['stars'] as int? ?? 0,
      destructionPercentage:
          (json['destructionPercentage'] as num?)?.toDouble() ?? 0,
      members: membersRaw
          .whereType<Map>()
          .map((member) => _member(Map<String, dynamic>.from(member)))
          .toList(),
    );
  }

  static CurrentWarMember _member(Map<String, dynamic> json) {
    final attacksRaw = json['attacks'] as List? ?? const [];
    return CurrentWarMember(
      tag: json['tag'] as String? ?? '',
      name: json['name'] as String? ?? '',
      townHallLevel: json['townhallLevel'] as int? ?? 0,
      mapPosition: json['mapPosition'] as int? ?? 0,
      opponentAttacks: json['opponentAttacks'] as int? ?? 0,
      attacks: attacksRaw
          .whereType<Map>()
          .map((attack) => _attack(Map<String, dynamic>.from(attack)))
          .toList(),
    );
  }

  static CurrentWarAttack _attack(Map<String, dynamic> json) {
    return CurrentWarAttack(
      attackerTag: json['attackerTag'] as String? ?? '',
      defenderTag: json['defenderTag'] as String? ?? '',
      stars: json['stars'] as int? ?? 0,
      destructionPercentage:
          (json['destructionPercentage'] as num?)?.toDouble() ?? 0,
      order: json['order'] as int? ?? 0,
    );
  }
}

/// Supercell timestamps look like `20210901T083000.000Z`.
DateTime? parseCocTime(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  final match = RegExp(r'^(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})(\d{2})')
      .firstMatch(raw);
  if (match == null) return DateTime.tryParse(raw)?.toUtc();
  return DateTime.utc(
    int.parse(match.group(1)!),
    int.parse(match.group(2)!),
    int.parse(match.group(3)!),
    int.parse(match.group(4)!),
    int.parse(match.group(5)!),
    int.parse(match.group(6)!),
  );
}

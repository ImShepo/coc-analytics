enum ClanWarState { notInWar, preparation, inWar, warEnded, unknown }

class CurrentWarAttack {
  final String attackerTag;
  final String defenderTag;
  final int stars;
  final double destructionPercentage;
  final int order;

  const CurrentWarAttack({
    required this.attackerTag,
    required this.defenderTag,
    required this.stars,
    required this.destructionPercentage,
    required this.order,
  });
}

class CurrentWarMember {
  final String tag;
  final String name;
  final int townHallLevel;
  final int mapPosition;
  final int opponentAttacks;
  final List<CurrentWarAttack> attacks;

  const CurrentWarMember({
    required this.tag,
    required this.name,
    required this.townHallLevel,
    required this.mapPosition,
    required this.opponentAttacks,
    required this.attacks,
  });

  int get attacksUsed => attacks.length;
}

class CurrentWarClan {
  final String tag;
  final String name;
  final String badgeUrl;
  final int attacks;
  final int stars;
  final double destructionPercentage;
  final List<CurrentWarMember> members;

  const CurrentWarClan({
    required this.tag,
    required this.name,
    required this.badgeUrl,
    required this.attacks,
    required this.stars,
    required this.destructionPercentage,
    required this.members,
  });
}

class CurrentClanWar {
  final ClanWarState state;
  final int teamSize;
  final int attacksPerMember;
  final DateTime? preparationStartTime;
  final DateTime? startTime;
  final DateTime? endTime;
  final CurrentWarClan? clan;
  final CurrentWarClan? opponent;

  const CurrentClanWar({
    required this.state,
    required this.teamSize,
    required this.attacksPerMember,
    required this.preparationStartTime,
    required this.startTime,
    required this.endTime,
    required this.clan,
    required this.opponent,
  });

  bool get hasRoster =>
      state == ClanWarState.preparation ||
      state == ClanWarState.inWar ||
      state == ClanWarState.warEnded;
}

class WarStanding {
  final CurrentWarMember member;
  final int stars;
  final double destruction;
  final int rank;

  const WarStanding({
    required this.member,
    required this.stars,
    required this.destruction,
    required this.rank,
  });
}

/// Best attack per defender, then sum. Two swings on the same base do not
/// double-count stars.
List<WarStanding> warStandings(CurrentWarClan clan) {
  final scored = clan.members.map((member) {
    final bestByDefender = <String, CurrentWarAttack>{};
    for (final attack in member.attacks) {
      final key = attack.defenderTag.isEmpty
          ? 'order-${attack.order}'
          : attack.defenderTag;
      final current = bestByDefender[key];
      if (current == null ||
          attack.stars > current.stars ||
          (attack.stars == current.stars &&
              attack.destructionPercentage > current.destructionPercentage)) {
        bestByDefender[key] = attack;
      }
    }
    final stars = bestByDefender.values.fold<int>(0, (sum, attack) => sum + attack.stars);
    final destruction = bestByDefender.values.fold<double>(
      0,
      (sum, attack) => sum + attack.destructionPercentage,
    );
    return (member: member, stars: stars, destruction: destruction);
  }).toList();

  scored.sort((a, b) {
    final byStars = b.stars.compareTo(a.stars);
    if (byStars != 0) return byStars;
    final byDestruction = b.destruction.compareTo(a.destruction);
    if (byDestruction != 0) return byDestruction;
    final aAttacked = a.member.attacksUsed > 0 ? 1 : 0;
    final bAttacked = b.member.attacksUsed > 0 ? 1 : 0;
    final byAttacked = bAttacked.compareTo(aAttacked);
    if (byAttacked != 0) return byAttacked;
    return a.member.mapPosition.compareTo(b.member.mapPosition);
  });

  return [
    for (var i = 0; i < scored.length; i++)
      WarStanding(
        member: scored[i].member,
        stars: scored[i].stars,
        destruction: scored[i].destruction,
        rank: i + 1,
      ),
  ];
}

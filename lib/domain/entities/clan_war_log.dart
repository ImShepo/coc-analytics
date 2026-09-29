class ClanWarLogEntry {
  final String result;
  final String endTime;
  final int teamSize;
  final int attacksPerMember;
  final ClanWarLogSide clan;
  final ClanWarLogSide opponent;

  const ClanWarLogEntry({
    required this.result,
    required this.endTime,
    required this.teamSize,
    required this.attacksPerMember,
    required this.clan,
    required this.opponent,
  });
}

class ClanWarLogSide {
  final String tag;
  final String name;
  final String badgeUrl;
  final int clanLevel;
  final int attacks;
  final int stars;
  final double destructionPercentage;
  final int expEarned;

  const ClanWarLogSide({
    required this.tag,
    required this.name,
    required this.badgeUrl,
    required this.clanLevel,
    required this.attacks,
    required this.stars,
    required this.destructionPercentage,
    required this.expEarned,
  });
}

class CapitalRaidMember {
  final String tag;
  final String name;
  final int attacks;
  final int capitalResourcesLooted;

  const CapitalRaidMember({
    required this.tag,
    required this.name,
    required this.attacks,
    required this.capitalResourcesLooted,
  });
}

class CapitalRaidSeason {
  final String state;
  final String startTime;
  final String endTime;
  final int capitalTotalLoot;
  final int raidsCompleted;
  final int totalAttacks;
  final int enemyDistrictsDestroyed;
  final int offensiveReward;
  final int defensiveReward;
  final List<CapitalRaidMember> members;

  const CapitalRaidSeason({
    required this.state,
    required this.startTime,
    required this.endTime,
    required this.capitalTotalLoot,
    required this.raidsCompleted,
    required this.totalAttacks,
    required this.enemyDistrictsDestroyed,
    required this.offensiveReward,
    required this.defensiveReward,
    this.members = const [],
  });

  List<CapitalRaidMember> get lootRanking {
    final ranked = [...members];
    ranked.sort(
      (a, b) => b.capitalResourcesLooted.compareTo(a.capitalResourcesLooted),
    );
    return ranked;
  }
}

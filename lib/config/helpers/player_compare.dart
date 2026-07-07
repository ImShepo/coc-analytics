import 'package:coc/config/helpers/achievement_utils.dart';
import 'package:coc/config/helpers/troop_catalog.dart';
import 'package:coc/domain/entities/player.dart';

class CompareMetric {
  final String label;
  final String group;
  final int you;
  final int them;

  const CompareMetric({
    required this.label,
    required this.group,
    required this.you,
    required this.them,
  });

  int get maxValue => you > them ? you : them;

  CompareWinner get winner {
    if (you > them) return CompareWinner.you;
    if (them > you) return CompareWinner.them;
    return CompareWinner.tie;
  }
}

enum CompareWinner { you, them, tie }

class CompareSummary {
  final int youWins;
  final int themWins;
  final int ties;

  const CompareSummary({
    required this.youWins,
    required this.themWins,
    required this.ties,
  });

  int get total => youWins + themWins + ties;
}

class RadarAxis {
  final String label;
  final double you;
  final double them;

  const RadarAxis({
    required this.label,
    required this.you,
    required this.them,
  });
}

class AchievementMatch {
  final String name;
  final Achievement yours;
  final Achievement theirs;

  const AchievementMatch({
    required this.name,
    required this.yours,
    required this.theirs,
  });

  CompareWinner get winner {
    final youDone = yours.target > 0 && yours.value >= yours.target;
    final themDone = theirs.target > 0 && theirs.value >= theirs.target;
    if (youDone && !themDone) return CompareWinner.you;
    if (themDone && !youDone) return CompareWinner.them;
    if (youDone && themDone) {
      if (yours.stars > theirs.stars) return CompareWinner.you;
      if (theirs.stars > yours.stars) return CompareWinner.them;
    }
    final youRatio = yours.target == 0 ? 0.0 : yours.value / yours.target;
    final themRatio = theirs.target == 0 ? 0.0 : theirs.value / theirs.target;
    if (youRatio > themRatio) return CompareWinner.you;
    if (themRatio > youRatio) return CompareWinner.them;
    return CompareWinner.tie;
  }
}

List<CompareMetric> buildCompareMetrics(Player you, Player them) {
  return [
    CompareMetric(
      label: 'Ayuntamiento',
      group: 'Ayuntamiento',
      you: you.townHallLevel,
      them: them.townHallLevel,
    ),
    CompareMetric(
      label: 'Experiencia',
      group: 'Ayuntamiento',
      you: you.expLevel,
      them: them.expLevel,
    ),
    CompareMetric(
      label: 'Trofeos',
      group: 'Ayuntamiento',
      you: you.trophies,
      them: them.trophies,
    ),
    CompareMetric(
      label: 'Mejor récord',
      group: 'Ayuntamiento',
      you: you.bestTrophies,
      them: them.bestTrophies,
    ),
    CompareMetric(
      label: 'Estrellas de guerra',
      group: 'Ayuntamiento',
      you: you.warStars,
      them: them.warStars,
    ),
    CompareMetric(
      label: 'Victorias ataque',
      group: 'Ayuntamiento',
      you: you.attackWins,
      them: them.attackWins,
    ),
    CompareMetric(
      label: 'Victorias defensa',
      group: 'Ayuntamiento',
      you: you.defenseWins,
      them: them.defenseWins,
    ),
    CompareMetric(
      label: 'Ayuntamiento BB',
      group: 'Constructor',
      you: you.builderHallLevel,
      them: them.builderHallLevel,
    ),
    CompareMetric(
      label: 'Trofeos BB',
      group: 'Constructor',
      you: you.builderBaseTrophies,
      them: them.builderBaseTrophies,
    ),
    CompareMetric(
      label: 'Récord BB',
      group: 'Constructor',
      you: you.bestBuilderBaseTrophies,
      them: them.bestBuilderBaseTrophies,
    ),
    CompareMetric(
      label: 'Donaciones',
      group: 'Clan',
      you: you.donations,
      them: them.donations,
    ),
    CompareMetric(
      label: 'Recibidas',
      group: 'Clan',
      you: you.donationsReceived,
      them: them.donationsReceived,
    ),
    CompareMetric(
      label: 'Capital',
      group: 'Clan',
      you: you.clanCapitalContributions,
      them: them.clanCapitalContributions,
    ),
  ];
}

CompareSummary buildCompareSummary(List<CompareMetric> metrics) {
  var youWins = 0;
  var themWins = 0;
  var ties = 0;

  for (final metric in metrics) {
    switch (metric.winner) {
      case CompareWinner.you:
        youWins++;
      case CompareWinner.them:
        themWins++;
      case CompareWinner.tie:
        ties++;
    }
  }

  return CompareSummary(youWins: youWins, themWins: themWins, ties: ties);
}

List<RadarAxis> buildRadarAxes(Player you, Player them) {
  double norm(int a, int b) {
    final max = [a, b, 1].reduce((x, y) => x > y ? x : y);
    return max == 0 ? 0 : a / max;
  }

  return [
    RadarAxis(
      label: 'TH',
      you: norm(you.townHallLevel, them.townHallLevel),
      them: norm(them.townHallLevel, you.townHallLevel),
    ),
    RadarAxis(
      label: 'XP',
      you: norm(you.expLevel, them.expLevel),
      them: norm(them.expLevel, you.expLevel),
    ),
    RadarAxis(
      label: 'Trofeos',
      you: norm(you.trophies, them.trophies),
      them: norm(them.trophies, you.trophies),
    ),
    RadarAxis(
      label: 'BB',
      you: norm(you.builderBaseTrophies, them.builderBaseTrophies),
      them: norm(them.builderBaseTrophies, you.builderBaseTrophies),
    ),
    RadarAxis(
      label: 'Donar',
      you: norm(you.donations, them.donations),
      them: norm(them.donations, you.donations),
    ),
    RadarAxis(
      label: 'Guerra',
      you: norm(you.warStars, them.warStars),
      them: norm(them.warStars, you.warStars),
    ),
  ];
}

List<AchievementMatch> buildAchievementMatches(Player you, Player them) {
  final themByName = {for (final a in them.achievements) a.name: a};
  final matches = <AchievementMatch>[];

  for (final yours in you.achievements) {
    final theirs = themByName[yours.name];
    if (theirs != null) {
      matches.add(
        AchievementMatch(name: yours.name, yours: yours, theirs: theirs),
      );
    }
  }

  matches.sort((a, b) {
    if (a.winner != b.winner) {
      if (a.winner == CompareWinner.you) return -1;
      if (b.winner == CompareWinner.you) return 1;
    }
    return a.name.compareTo(b.name);
  });

  return matches;
}

AchievementStats homeStats(Player player) =>
    achievementStats(homeAchievements(player.achievements));

AchievementStats builderStats(Player player) =>
    achievementStats(builderAchievements(player.achievements));

class TroopMatch {
  final String name;
  final TroopGroup group;
  final int youLevel;
  final int themLevel;
  final int youMax;
  final int themMax;

  const TroopMatch({
    required this.name,
    required this.group,
    required this.youLevel,
    required this.themLevel,
    required this.youMax,
    required this.themMax,
  });

  CompareWinner get winner {
    if (youLevel > themLevel) return CompareWinner.you;
    if (themLevel > youLevel) return CompareWinner.them;
    return CompareWinner.tie;
  }
}

class TroopGroupSummary {
  final TroopGroup group;
  final int youUnlocked;
  final int themUnlocked;
  final int youTotal;
  final int themTotal;

  const TroopGroupSummary({
    required this.group,
    required this.youUnlocked,
    required this.themUnlocked,
    required this.youTotal,
    required this.themTotal,
  });
}

List<TroopMatch> buildTroopMatches(Player you, Player them) {
  final themByName = {for (final t in them.troops) t.name: t};
  final matches = <TroopMatch>[];

  for (final yours in you.troops) {
    if (yours.maxLevel <= 0) continue;
    final theirs = themByName[yours.name];
    if (theirs == null) continue;

    matches.add(
      TroopMatch(
        name: yours.name,
        group: TroopCatalog.troopGroupFor(yours.name, yours.village),
        youLevel: yours.level,
        themLevel: theirs.level,
        youMax: yours.maxLevel,
        themMax: theirs.maxLevel,
      ),
    );
  }

  matches.sort((a, b) {
    final orderA = TroopCatalog.troopDisplayOrder.indexOf(a.group);
    final orderB = TroopCatalog.troopDisplayOrder.indexOf(b.group);
    if (orderA != orderB) return orderA.compareTo(orderB);
    if (a.winner != b.winner) {
      if (a.winner == CompareWinner.you) return -1;
      if (b.winner == CompareWinner.you) return 1;
    }
    return a.name.compareTo(b.name);
  });

  return matches;
}

Map<TroopGroup, List<TroopMatch>> troopMatchesGrouped(Player you, Player them) {
  final map = <TroopGroup, List<TroopMatch>>{};
  for (final match in buildTroopMatches(you, them)) {
    map.putIfAbsent(match.group, () => []).add(match);
  }
  return map;
}

List<TroopGroupSummary> buildTroopGroupSummaries(Player you, Player them) {
  int unlocked(Player player, TroopGroup group) {
    return player.troops
        .where(
          (t) =>
              t.maxLevel > 0 &&
              t.level > 0 &&
              TroopCatalog.troopGroupFor(t.name, t.village) == group,
        )
        .length;
  }

  int total(Player player, TroopGroup group) {
    return player.troops
        .where(
          (t) =>
              t.maxLevel > 0 &&
              TroopCatalog.troopGroupFor(t.name, t.village) == group,
        )
        .length;
  }

  return TroopCatalog.troopDisplayOrder
      .map(
        (group) => TroopGroupSummary(
          group: group,
          youUnlocked: unlocked(you, group),
          themUnlocked: unlocked(them, group),
          youTotal: total(you, group),
          themTotal: total(them, group),
        ),
      )
      .where((s) => s.youTotal > 0 || s.themTotal > 0)
      .toList();
}

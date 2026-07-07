import 'package:coc/config/helpers/building_catalog.dart';
import 'package:coc/config/helpers/coc_unit_image.dart';
import 'package:coc/config/helpers/unit_static_repository.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:coc/l10n/app_localizations.dart';
import 'package:coc/l10n/catalog_l10n.dart';
import 'package:coc/l10n/category_unit_l10n.dart';
import 'package:coc/presentation/models/category_unit.dart';
import 'package:flutter/material.dart';

class DetailStat {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const DetailStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class UnitDetailInsights {
  final String? description;
  final String statusHeadline;
  final String statusDetail;
  final List<DetailStat> stats;
  final List<String> highlights;
  final double progress;
  final bool showProgress;

  const UnitDetailInsights({
    this.description,
    required this.statusHeadline,
    required this.statusDetail,
    required this.stats,
    required this.highlights,
    required this.progress,
    required this.showProgress,
  });

  static Future<UnitDetailInsights> build({
    required CategoryUnit unit,
    required Player player,
    required AppLocalizations l10n,
  }) async {
    await UnitStaticRepository.instance.load();
    final staticItem = UnitStaticRepository.instance.findFor(unit);
    final repo = UnitStaticRepository.instance;

    final hallLevel = unit.village == 'builderBase'
        ? player.builderHallLevel
        : player.townHallLevel;

    final stats = <DetailStat>[];
    final highlights = <String>[];
    var headline =
        unit.isUnlocked ? l10n.unlockedStatus : l10n.locked;
    var detail = '';
    final progress = unit.progress;
    final showProgress = unit.hasExactLevel && unit.maxLevel > 0;

    if (staticItem != null) {
      final description = staticItem['info'] as String?;
      final maxAtHall = repo.maxLevelAtTownHall(staticItem, hallLevel);
      final unlockTh = unit.unlockTownHall ?? repo.unlockTownHall(staticItem);
      final totalLevels = repo.levelsFor(staticItem).length;

      if (unit.category == UnitCategory.building ||
          unit.buildingGroup == BuildingGroup.traps) {
        headline = unit.isUnlocked
            ? l10n.availableInVillage
            : l10n.notYetAvailable;
        if (unit.hasExactLevel) {
          detail = l10n.levelInProfile(unit.level, unit.maxLevel);
          stats.addAll([
            DetailStat(
              label: l10n.currentLevel,
              value: '${unit.level}',
              icon: Icons.trending_up_rounded,
              color: const Color(0xFF1565C0),
            ),
            DetailStat(
              label: l10n.globalMax,
              value: '${unit.maxLevel}',
              icon: Icons.flag_rounded,
              color: const Color(0xFFC9A227),
            ),
          ]);
        } else {
          detail = unit.isUnlocked
              ? l10n.canUpgradeToLevel(hallLevel, maxAtHall)
              : l10n.unlocksAtTownHall(unlockTh);
          stats.addAll([
            DetailStat(
              label: l10n.yourTownHall,
              value: l10n.townHallShort(hallLevel),
              icon: Icons.account_balance_rounded,
              color: const Color(0xFF6A1B9A),
            ),
            DetailStat(
              label: l10n.maxInVillage,
              value: l10n.levelLabel(maxAtHall),
              icon: Icons.home_work_rounded,
              color: const Color(0xFF2E7D32),
            ),
            DetailStat(
              label: l10n.unlockAt,
              value: l10n.townHallShort(unlockTh),
              icon: Icons.lock_open_rounded,
              color: const Color(0xFF546E7A),
            ),
            DetailStat(
              label: l10n.totalLevels,
              value: '$totalLevels',
              icon: Icons.layers_rounded,
              color: const Color(0xFF1565C0),
            ),
          ]);
        }
        if (unit.buildingGroup != null) {
          highlights.add(
            l10n.categoryPrefix(
              l10n.buildingGroupLabel(unit.buildingGroup!),
            ),
          );
        }
      } else {
        final effectiveLevel = unit.isUnlocked ? unit.level : 0;
        final current = effectiveLevel > 0
            ? repo.levelAt(staticItem, effectiveLevel)
            : null;
        final next = effectiveLevel > 0 && effectiveLevel < unit.maxLevel
            ? repo.levelAt(staticItem, effectiveLevel + 1)
            : null;

        headline = unit.isUnlocked
            ? (unit.isMaxed
                ? l10n.maxLevelReachedHeadline
                : l10n.inProgressHeadline)
            : l10n.notUnlockedHeadline;

        if (unit.isUnlocked) {
          detail = unit.isMaxed
              ? l10n.allUpgradesCompleted
              : l10n.levelsToMax(unit.maxLevel - unit.level, unit.maxLevel);
        } else {
          detail = l10n.researchWhenUnlocked;
        }

        stats.addAll([
          DetailStat(
            label: l10n.level,
            value: unit.isUnlocked ? '${unit.level}' : '—',
            icon: Icons.military_tech_rounded,
            color: const Color(0xFF1565C0),
          ),
          DetailStat(
            label: l10n.maximum,
            value: '${unit.maxLevel}',
            icon: Icons.emoji_events_rounded,
            color: const Color(0xFFC9A227),
          ),
          DetailStat(
            label: l10n.yourTownHall,
            value: l10n.townHallShort(hallLevel),
            icon: Icons.account_balance_rounded,
            color: const Color(0xFF6A1B9A),
          ),
        ]);

        if (current != null) {
          final hp = current['hitpoints'] as int?;
          final dps = current['dps'] as int?;
          if (hp != null) {
            stats.add(DetailStat(
              label: l10n.health,
              value: '$hp',
              icon: Icons.favorite_rounded,
              color: const Color(0xFFC62828),
            ));
          }
          if (dps != null && dps != 0) {
            final label = dps < 0 ? l10n.healPerSec : l10n.damagePerSec;
            stats.add(DetailStat(
              label: label,
              value: '${dps.abs()}',
              icon: Icons.flash_on_rounded,
              color: const Color(0xFFF9A825),
            ));
          }
        }

        final housing = repo.housingSpace(staticItem);
        if (housing != null) {
          stats.add(DetailStat(
            label: l10n.housingSpace,
            value: '$housing',
            icon: Icons.grid_view_rounded,
            color: const Color(0xFF546E7A),
          ));
        }

        if (next != null) {
          final lab = next['required_lab_level'] as int?;
          final cost = next['upgrade_cost'] as int?;
          if (lab != null) {
            highlights.add(l10n.nextUpgradeLab(lab));
          }
          if (cost != null && cost > 0) {
            highlights.add(l10n.estimatedCost(_formatCost(cost)));
          }
        }

        final resource = unit.resourceLabelL10n(l10n);
        if (resource != null) {
          highlights.add(l10n.resourceHighlight(resource));
        }
      }

      return UnitDetailInsights(
        description: description?.replaceAll('\\n', '\n'),
        statusHeadline: headline,
        statusDetail: detail,
        stats: stats,
        highlights: highlights,
        progress: progress,
        showProgress: showProgress,
      );
    }

    if (unit.hasExactLevel) {
      detail = unit.isUnlocked
          ? l10n.levelOfMaxShort(unit.level, unit.maxLevel)
          : l10n.unitNotUnlocked;
      stats.addAll([
        DetailStat(
          label: l10n.level,
          value: unit.isUnlocked ? '${unit.level}' : '—',
          icon: Icons.military_tech_rounded,
          color: const Color(0xFF1565C0),
        ),
        DetailStat(
          label: l10n.maximum,
          value: '${unit.maxLevel}',
          icon: Icons.emoji_events_rounded,
          color: const Color(0xFFC9A227),
        ),
        DetailStat(
          label: l10n.villageLabel,
          value: unit.villageShortLabelL10n(l10n),
          icon: Icons.map_rounded,
          color: const Color(0xFF6A1B9A),
        ),
      ]);
    } else if (unit.unlockTownHall != null) {
      detail = unit.isUnlocked
          ? l10n.availableAtCurrentTH(hallLevel)
          : l10n.requiresTownHallLevel(unit.unlockTownHall!);
      stats.addAll([
        DetailStat(
          label: l10n.yourTownHall,
          value: l10n.townHallShort(hallLevel),
          icon: Icons.account_balance_rounded,
          color: const Color(0xFF6A1B9A),
        ),
        DetailStat(
          label: l10n.unlockAt,
          value: l10n.townHallShort(unit.unlockTownHall!),
          icon: Icons.lock_open_rounded,
          color: const Color(0xFF546E7A),
        ),
      ]);
    }

    return UnitDetailInsights(
      statusHeadline: headline,
      statusDetail: detail,
      stats: stats,
      highlights: highlights,
      progress: progress,
      showProgress: showProgress,
    );
  }

  static String _formatCost(int cost) {
    if (cost >= 1000000) {
      return '${(cost / 1000000).toStringAsFixed(1)}M';
    }
    if (cost >= 1000) {
      return '${(cost / 1000).toStringAsFixed(0)}K';
    }
    return '$cost';
  }
}

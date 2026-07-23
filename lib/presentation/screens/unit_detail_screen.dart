import 'package:coc/config/helpers/troop_catalog.dart';
import 'package:coc/config/helpers/coc_unit_image.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:coc/l10n/category_unit_l10n.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/models/category_unit.dart';
import 'package:coc/presentation/models/unit_detail_insights.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_stack.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_background_variant.dart';
import 'package:coc/presentation/widgets/categories/coc_unit_image_widget.dart';
import 'package:coc/presentation/widgets/categories/unit_hero_image.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:flutter/material.dart';

class UnitDetailScreen extends StatefulWidget {
  final CategoryUnit unit;
  final Player player;

  const UnitDetailScreen({
    super.key,
    required this.unit,
    required this.player,
  });

  @override
  State<UnitDetailScreen> createState() => _UnitDetailScreenState();
}

class _UnitDetailScreenState extends State<UnitDetailScreen> {
  Future<UnitDetailInsights>? _insightsFuture;
  Locale? _lastLocale;

  CategoryUnit get unit => widget.unit;

  List<HeroEquipment> get _equippedGear {
    if (unit.category != UnitCategory.hero) return const [];
    for (final hero in widget.player.heroes) {
      if (hero.name == unit.name) {
        return hero.equipment ?? const [];
      }
    }
    return const [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    if (_lastLocale != locale) {
      _lastLocale = locale;
      _insightsFuture = UnitDetailInsights.build(
        unit: unit,
        player: widget.player,
        l10n: context.l10n,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppScreenStack(
        variant: AppScreenBackgroundVariant.unit,
        child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: colorScheme.onPrimary,
            leadingWidth: 42,
            leading: const GlassBackLeading(),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/COC.jpeg', fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorScheme.primary.withValues(alpha: 0.25),
                          colorScheme.onPrimary.withValues(alpha: 0.88),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: UnitHeroImage(
                      unit: unit,
                      player: widget.player,
                      size: 220,
                      backgroundColor: Colors.white.withValues(alpha: 0.12),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    unit.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.primary,
                      color: colorScheme.onPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Chip(
                        label: unit.categoryLabel(l10n),
                        color: colorScheme.primary,
                      ),
                      _Chip(
                        label: unit.villageLabelL10n(l10n),
                        color: colorScheme.onPrimary,
                      ),
                      if (unit.resourceLabelL10n(l10n) != null)
                        _Chip(
                          label: unit.resourceLabelL10n(l10n)!,
                          color: unit.troopGroup != null
                              ? TroopCatalog.troopGroupColor(unit.troopGroup!)
                              : TroopCatalog.spellGroupColor(unit.spellGroup!),
                        ),
                      if (!unit.isUnlocked)
                        _Chip(label: l10n.locked, color: Colors.grey.shade600),
                      if (unit.isMaxed)
                        _Chip(
                          label: l10n.maxLevel,
                          color: const Color(0xFFC9A227),
                        ),
                      if (unit.superTroopIsActive)
                        _Chip(
                          label: l10n.superTroopActive,
                          color: const Color(0xFF6B2D8B),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_equippedGear.isNotEmpty) ...[
                    _EquippedGearCard(
                      equipment: _equippedGear,
                      player: widget.player,
                    ),
                    const SizedBox(height: 14),
                  ],
                  FutureBuilder<UnitDetailInsights>(
                    future: _insightsFuture,
                    builder: (context, snapshot) {
                      if (_insightsFuture == null ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return const _LoadingCard();
                      }

                      final insights = snapshot.data;
                      if (insights == null) {
                        return _LevelCard(unit: unit, player: widget.player);
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _StatusCard(
                            unit: unit,
                            insights: insights,
                          ),
                          if (insights.stats.isNotEmpty) ...[
                            const SizedBox(height: 14),
                            _StatsGrid(stats: insights.stats),
                          ],
                          if (insights.showProgress) ...[
                            const SizedBox(height: 14),
                            _ProgressCard(unit: unit, insights: insights),
                          ],
                          if (insights.highlights.isNotEmpty) ...[
                            const SizedBox(height: 14),
                            _HighlightsCard(items: insights.highlights),
                          ],
                          if (insights.description != null) ...[
                            const SizedBox(height: 14),
                            _DescriptionCard(text: insights.description!),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _EquippedGearCard extends StatelessWidget {
  final List<HeroEquipment> equipment;
  final Player player;

  const _EquippedGearCard({
    required this.equipment,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.equippedEquipment.toUpperCase(),
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: colorScheme.onPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 12),
          ...equipment.map((gear) {
            final owned = player.heroEquipment
                .where((e) => e.name == gear.name)
                .toList();
            final level = owned.isNotEmpty ? owned.first.level : gear.level;
            final maxLevel =
                owned.isNotEmpty ? owned.first.maxLevel : gear.maxLevel;
            final village =
                owned.isNotEmpty ? owned.first.village : gear.village;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  CocUnitImageWidget(
                    name: gear.name,
                    category: UnitCategory.equipment,
                    level: level,
                    maxLevel: maxLevel,
                    village: village,
                    width: 44,
                    height: 44,
                    showLevelBadge: true,
                    levelBadgeValue: level,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gear.name,
                          style: TextStyle(
                            fontFamily: AppFonts.primary,
                            color: colorScheme.onPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Nv. $level / $maxLevel',
                          style: TextStyle(
                            fontFamily: AppFonts.primary,
                            color: colorScheme.onPrimary.withValues(alpha: 0.65),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final CategoryUnit unit;
  final UnitDetailInsights insights;

  const _StatusCard({required this.unit, required this.insights});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = unit.isUnlocked
        ? (unit.isMaxed ? const Color(0xFFC9A227) : colorScheme.primary)
        : Colors.grey.shade600;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.onPrimary.withValues(alpha: 0.95),
            colorScheme.onPrimary.withValues(alpha: 0.82),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                unit.isUnlocked ? Icons.check_circle_rounded : Icons.lock_rounded,
                color: statusColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  insights.statusHeadline.toUpperCase(),
                  style: TextStyle(
                    fontFamily: AppFonts.primary,
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            insights.statusDetail,
            style: const TextStyle(
              fontFamily: AppFonts.light,
              color: Colors.white,
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final List<DetailStat> stats;

  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final stat in stats)
          SizedBox(
            width: (MediaQuery.sizeOf(context).width - 52) / 2,
            child: _StatTile(stat: stat),
          ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final DetailStat stat;

  const _StatTile({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: stat.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(stat.icon, color: stat.color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.light,
                    color: Colors.grey.shade600,
                    fontSize: 8,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    stat.value,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: AppFonts.primary,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final CategoryUnit unit;
  final UnitDetailInsights insights;

  const _ProgressCard({required this.unit, required this.insights});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.unitDetailProgress.toUpperCase(),
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  color: colorScheme.onPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${unit.level} / ${unit.maxLevel}',
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  color: colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: insights.progress),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 10,
                  backgroundColor: colorScheme.secondary.withValues(alpha: 0.35),
                  color: unit.isMaxed
                      ? const Color(0xFFC9A227)
                      : colorScheme.primary,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            unit.isMaxed
                ? l10n.maxLevelReachedMessage
                : l10n.levelsRemainingMessage(unit.maxLevel - unit.level),
            style: TextStyle(
              fontFamily: AppFonts.light,
              color: Colors.grey.shade600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightsCard extends StatelessWidget {
  final List<String> items;

  const _HighlightsCard({required this.items});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.unitDetailDetails,
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: colorScheme.onPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < items.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_right_rounded,
                  color: colorScheme.primary,
                  size: 18,
                ),
                Expanded(
                  child: Text(
                    items[i],
                    style: TextStyle(
                      fontFamily: AppFonts.light,
                      color: Colors.grey.shade700,
                      fontSize: 10,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (i < items.length - 1) const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  final String text;

  const _DescriptionCard({required this.text});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.unitDetailDescription.toUpperCase(),
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: colorScheme.onPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              fontFamily: AppFonts.light,
              color: Colors.grey.shade700,
              fontSize: 10,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final CategoryUnit unit;
  final Player player;

  const _LevelCard({required this.unit, required this.player});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        unit.hasExactLevel
            ? l10n.levelSlashMax(unit.level, unit.maxLevel)
            : unit.levelLabelForL10n(player, l10n),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppFonts.primary,
          color: colorScheme.primary,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: AppFonts.light,
          color: color,
          fontSize: 9,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

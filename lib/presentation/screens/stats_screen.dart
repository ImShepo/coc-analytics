import 'package:coc/config/helpers/achievement_utils.dart';
import 'package:coc/config/helpers/human_formats.dart';
import 'package:coc/config/helpers/town_hall_asset.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:coc/l10n/app_localizations.dart';
import 'package:coc/l10n/catalog_l10n.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/screens/compare_screen.dart';
import 'package:coc/presentation/widgets/achievement_tile.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_stack.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_background_variant.dart';
import 'package:coc/presentation/widgets/coc_network_image.dart';
import 'package:coc/presentation/widgets/label_chip.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  static const name = 'stats-screen';

  final Player player;

  const StatsScreen({super.key, required this.player});

  String get _leagueIcon => player.league.iconUrls.medium.isEmpty
      ? 'http://clash-wiki.com/images/progress/leagues/no_league.png'
      : player.league.iconUrls.medium;

  bool get _hasLegendData =>
      player.legendStatistics.legendTrophies > 0 ||
      player.legendStatistics.currentSeason.trophies > 0 ||
      player.legendStatistics.previousSeason.trophies > 0 ||
      player.legendStatistics.bestSeason.trophies > 0;

  List<Achievement> get _homeAchievements =>
      sortAchievements(homeAchievements(player.achievements));

  List<Achievement> get _builderAchievements =>
      sortAchievements(builderAchievements(player.achievements));

  void _openCompare(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CompareScreen(me: player),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppScreenStack(
        variant: AppScreenBackgroundVariant.stats,
        child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            backgroundColor: colorScheme.onPrimary,
            leadingWidth: 42,
            leading: const GlassBackLeading(),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GlassTextButton(
                  label: l10n.compare,
                  icon: Icons.compare_arrows_rounded,
                  onPressed: () => _openCompare(context),
                  style: GlassButtonStyle.ghostOnDark,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 48, bottom: 14, right: 16),
              title: Text(
                player.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: AppFonts.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
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
                          colorScheme.primary.withValues(alpha: 0.35),
                          colorScheme.onPrimary.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment(0, -0.15),
                    child: _StatsTitleLabel(),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _OverviewHero(
                  townHallLevel: player.townHallLevel,
                  weaponLevel: player.townHallWeaponLevel,
                  expLevel: player.expLevel,
                  leagueName: player.league.name,
                  leagueIcon: _leagueIcon,
                  townHallAsset: townHallAssetPath(player.townHallLevel),
                ),
                if (player.labels.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: player.labels.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, index) {
                        final label = player.labels[index];
                        return LabelChip(
                          name: label.name,
                          iconUrl: label.iconUrls.medium.isNotEmpty
                              ? label.iconUrls.medium
                              : label.iconUrls.small,
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                _MetricsRow(
                  items: [
                    _MetricItem(l10n.trophies, '${player.trophies}', '🏆'),
                    _MetricItem(l10n.bestRecord, '${player.bestTrophies}', '⭐'),
                    _MetricItem(l10n.contributions, '${player.clanCapitalContributions}', '⚒'),
                  ],
                ),
                const SizedBox(height: 12),
                _StatsCard(
                  title: l10n.mainTownHall,
                  children: [
                    _StatRow(label: l10n.league, value: player.league.name),
                    _StatRow(
                      label: l10n.warStars,
                      value: '${player.warStars}',
                    ),
                    _StatRow(label: l10n.attackWins, value: '${player.attackWins}'),
                    _StatRow(label: l10n.defenseWins, value: '${player.defenseWins}'),
                    _StatRow(
                      label: l10n.warPreference,
                      value: _warPreferenceLabel(l10n, player.warPreference),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _StatsCard(
                  title: l10n.builderBaseSection,
                  children: [
                    _StatRow(
                      label: l10n.townHall,
                      value: '${l10n.level} ${player.builderHallLevel}',
                    ),
                    _StatRow(
                      label: l10n.trophies,
                      value: '${player.builderBaseTrophies}',
                    ),
                    _StatRow(
                      label: l10n.bestRecord,
                      value: '${player.bestBuilderBaseTrophies}',
                    ),
                    _StatRow(
                      label: l10n.league,
                      value: player.builderBaseLeague.name,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _StatsCard(
                  title: l10n.clanAndDonations,
                  children: [
                    _StatRow(
                      label: l10n.donations,
                      value: HumanFormats.number(player.donations.toDouble()),
                    ),
                    _StatRow(
                      label: l10n.donationsReceived,
                      value: HumanFormats.number(player.donationsReceived.toDouble()),
                    ),
                    if (player.clan.tag.isNotEmpty)
                      _StatRow(
                        label: l10n.clan,
                        value: '${player.clan.name} (${player.clan.tag})',
                      ),
                    _StatRow(label: l10n.role, value: player.role),
                  ],
                ),
                if (_hasLegendData) ...[
                  const SizedBox(height: 12),
                  _StatsCard(
                    title: l10n.legendLeague,
                    children: [
                      _StatRow(
                        label: l10n.legendTrophies,
                        value: '${player.legendStatistics.legendTrophies}',
                      ),
                      if (player.legendStatistics.currentSeason.trophies > 0)
                        _StatRow(
                          label: l10n.currentSeason,
                          value:
                              '${player.legendStatistics.currentSeason.trophies} · #${player.legendStatistics.currentSeason.rank}',
                        ),
                      if (player.legendStatistics.previousSeason.trophies > 0)
                        _StatRow(
                          label: l10n.previousSeason,
                          value:
                              '${player.legendStatistics.previousSeason.trophies} · #${player.legendStatistics.previousSeason.rank}',
                        ),
                      if (player.legendStatistics.bestSeason.trophies > 0)
                        _StatRow(
                          label: l10n.bestSeason,
                          value:
                              '${player.legendStatistics.bestSeason.trophies} · #${player.legendStatistics.bestSeason.rank}',
                        ),
                    ],
                  ),
                ],
                if (player.playerHouse.elements.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _PlayerHouseCard(house: player.playerHouse),
                ],
                const SizedBox(height: 12),
                _ComparePromoCard(onTap: () => _openCompare(context)),
                const SizedBox(height: 20),
                _SectionLabel(
                  title: l10n.achievementsHomeVillage,
                  count: _homeAchievements.length,
                ),
                const SizedBox(height: 10),
              ]),
            ),
          ),
          if (_homeAchievements.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _EmptyAchievements(message: l10n.noHomeAchievements),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              sliver: SliverList.separated(
                itemCount: _homeAchievements.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, index) => AchievementTile(
                  achievement: _homeAchievements[index],
                  showVillage: false,
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            sliver: SliverToBoxAdapter(
              child: _SectionLabel(
                title: l10n.achievementsBuilderVillage,
                count: _builderAchievements.length,
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 10),
            sliver: SliverToBoxAdapter(child: SizedBox.shrink()),
          ),
          if (_builderAchievements.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _EmptyAchievements(message: l10n.noBuilderAchievements),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList.separated(
                itemCount: _builderAchievements.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, index) => AchievementTile(
                  achievement: _builderAchievements[index],
                  showVillage: false,
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Center(
                child: Text(
                  player.tag,
                  style: AppFonts.scrimCaption(fontSize: 10),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  String _warPreferenceLabel(AppLocalizations l10n, String preference) {
    switch (preference.toLowerCase()) {
      case 'in':
        return l10n.warPreferenceIn;
      case 'out':
        return l10n.warPreferenceOut;
      default:
        return preference;
    }
  }
}

class _StatsTitleLabel extends StatelessWidget {
  const _StatsTitleLabel();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.statsTitle,
      style: const TextStyle(
        fontFamily: AppFonts.light,
        color: Colors.white70,
        fontSize: 10,
        letterSpacing: 1.6,
      ),
    );
  }
}

class _OverviewHero extends StatelessWidget {
  final int townHallLevel;
  final int weaponLevel;
  final int expLevel;
  final String leagueName;
  final String leagueIcon;
  final String townHallAsset;

  const _OverviewHero({
    required this.townHallLevel,
    required this.weaponLevel,
    required this.expLevel,
    required this.leagueName,
    required this.leagueIcon,
    required this.townHallAsset,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final weaponSuffix = weaponLevel > 0 ? ' ($weaponLevel)' : '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(townHallAsset, width: 72, height: 72, fit: BoxFit.cover),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.townHallBanner(townHallLevel, weaponSuffix),
                  style: TextStyle(
                    fontFamily: AppFonts.primary,
                    color: colorScheme.onPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.experienceLevelLine(expLevel),
                  style: TextStyle(
                    fontFamily: AppFonts.light,
                    color: Colors.grey.shade600,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CocNetworkImage(
                      url: leagueIcon,
                      width: 22,
                      height: 22,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        leagueName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppFonts.light,
                          color: colorScheme.primary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem {
  final String label;
  final String value;
  final String emoji;

  const _MetricItem(this.label, this.value, this.emoji);
}

class _MetricsRow extends StatelessWidget {
  final List<_MetricItem> items;

  const _MetricsRow({required this.items});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: items.map((item) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: item == items.last ? 0 : 8,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(item.emoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    item.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFonts.primary,
                      color: colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    item.label.toUpperCase(),
                    style: TextStyle(
                      fontFamily: AppFonts.light,
                      color: Colors.grey.shade600,
                      fontSize: 8,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PlayerHouseCard extends StatelessWidget {
  final PlayerHouse house;

  const _PlayerHouseCard({required this.house});

  IconData _iconFor(String type) => switch (type) {
        'ground' => Icons.grass_rounded,
        'roof' => Icons.roofing_rounded,
        'walls' => Icons.fence_rounded,
        'decoration' || 'deco' => Icons.yard_rounded,
        'foot' => Icons.foundation_rounded,
        _ => Icons.home_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final sorted = [...house.elements]
      ..sort((a, b) => a.type.compareTo(b.type));

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.playerHouse.toUpperCase(),
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: colorScheme.onPrimary,
              fontSize: 11,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final element in sorted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _iconFor(element.type),
                        size: 16,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.houseElementTypeLabel(element.type),
                        style: TextStyle(
                          fontFamily: AppFonts.primary,
                          color: colorScheme.onPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.houseElementId(element.id),
                        style: TextStyle(
                          fontFamily: AppFonts.light,
                          color: colorScheme.onPrimary.withValues(alpha: 0.65),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _StatsCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: colorScheme.onPrimary,
              fontSize: 11,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.light,
                color: Colors.grey.shade700,
                fontSize: 11,
                height: 1.3,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: AppFonts.primary,
                color: colorScheme.onPrimary,
                fontSize: 11,
                height: 1.3,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final int count;

  const _SectionLabel({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: AppFonts.primary,
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _ComparePromoCard extends StatelessWidget {
  final VoidCallback onTap;

  const _ComparePromoCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: LiquidGlassSurface(
          borderRadius: BorderRadius.circular(18),
          tintColor: colorScheme.primary,
          tintStrength: 0.78,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const LiquidGlassSurface(
                circular: true,
                tintColor: Colors.white,
                tintStrength: 0.3,
                padding: EdgeInsets.all(10),
                child: Icon(Icons.compare_arrows_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.comparePlayersPromo,
                      style: const TextStyle(
                        fontFamily: AppFonts.primary,
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.comparePlayersSubtitle,
                      style: const TextStyle(
                        fontFamily: AppFonts.light,
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyAchievements extends StatelessWidget {
  final String message;

  const _EmptyAchievements({this.message = 'No hay logros registrados.'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppFonts.light,
          color: Colors.grey.shade600,
          fontSize: 11,
        ),
      ),
    );
  }
}

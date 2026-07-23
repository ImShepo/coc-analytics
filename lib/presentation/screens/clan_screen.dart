import 'package:coc/config/helpers/clan_tag.dart';
import 'package:coc/l10n/category_unit_l10n.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/domain/entities/clan.dart';
import 'package:coc/domain/entities/player.dart' show Player;
import 'package:coc/domain/entities/member_list.dart';
import 'package:coc/presentation/providers/clans/clan_info_provider.dart';
import 'package:coc/presentation/screens/clan_member_screen.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_stack.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_background_variant.dart';
import 'package:coc/presentation/widgets/clan/clan_hero_header.dart';
import 'package:coc/presentation/widgets/clan/war/war_logs_list.dart';
import 'package:coc/presentation/widgets/coc_network_image.dart';
import 'package:coc/presentation/widgets/label_chip.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:coc/presentation/widgets/section_title.dart';
import 'package:coc/presentation/widgets/stat_detail.dart';
import 'package:coc/presentation/widgets/cache_status_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClanScreen extends ConsumerStatefulWidget {
  static const name = 'clan-screen';

  final String clanId;
  final Player? viewerPlayer;

  const ClanScreen({super.key, required this.clanId, this.viewerPlayer});

  @override
  ClanScreenState createState() => ClanScreenState();
}

class ClanScreenState extends ConsumerState<ClanScreen> {
  late final String _cacheKey;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cacheKey = normalizeClanTag(widget.clanId);
    Future.microtask(
      () => ref.read(clanInfoProvider.notifier).loadClan(_cacheKey),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Clan? clan = ref.watch(
      clanInfoProvider.select((session) => session.byTag[_cacheKey]),
    );
    final clanMeta = ref.watch(
      clanInfoProvider.select((session) => session.metaByTag[_cacheKey]),
    );

    if (clan == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(clanInfoProvider.notifier).refreshClan(_cacheKey),
        child: AppScreenStack(
        variant: AppScreenBackgroundVariant.clan,
        primary: Theme.of(context).colorScheme.onPrimary,
        secondary: Theme.of(context).colorScheme.secondary,
        child: CustomScrollView(
          key: PageStorageKey<String>('clan-scroll-$_cacheKey'),
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            ..._ClanContentSlivers(
              clan: clan,
              viewerPlayer: widget.viewerPlayer,
              isRefreshing: clanMeta?.isRefreshing ?? false,
              refreshFailed: clanMeta?.refreshFailed ?? false,
              fetchedAt: clanMeta?.fetchedAt,
            ).build(context),
          ],
        ),
        ),
      ),
    );
  }
}

class _ClanContentSlivers {
  final Clan clan;
  final Player? viewerPlayer;
  final bool isRefreshing;
  final bool refreshFailed;
  final DateTime? fetchedAt;

  const _ClanContentSlivers({
    required this.clan,
    this.viewerPlayer,
    this.isRefreshing = false,
    this.refreshFailed = false,
    this.fetchedAt,
  });

  List<Widget> build(BuildContext context) {
    final l10n = context.l10n;

    return [
      if (isRefreshing || refreshFailed || fetchedAt != null)
        SliverToBoxAdapter(
          child: CacheStatusBanner(
            isRefreshing: isRefreshing,
            refreshFailed: refreshFailed,
            fetchedAt: fetchedAt,
          ),
        ),
      _CustomSliverAppBar(clan: clan),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(10, 16, 10, 0),
        sliver: SliverToBoxAdapter(child: _ClanInfoSection(clan: clan)),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(10, 16, 10, 0),
        sliver: SliverToBoxAdapter(
          child: SectionTitle(title: l10n.stats),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        sliver: SliverToBoxAdapter(child: _ClanStatsCard(clan: clan)),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(10, 24, 10, 0),
        sliver: SliverToBoxAdapter(
          child: SectionTitle(title: l10n.warLog),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        sliver: SliverToBoxAdapter(child: _WarStats(clan: clan)),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(10, 24, 10, 6),
        sliver: SliverToBoxAdapter(
          child: SectionTitle(
            title: l10n.clanMembersCount(clan.memberList.length),
            bottomPadding: 0,
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.only(bottom: 20),
        sliver: SliverList.separated(
          itemCount: clan.memberList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) => _MemberTile(
            player: clan.memberList[index],
            viewerPlayer: viewerPlayer,
          ),
        ),
      ),
    ];
  }
}

class _ClanInfoSection extends StatelessWidget {
  final Clan clan;

  const _ClanInfoSection({required this.clan});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (clan.isFamilyFriendly || clan.labels.isNotEmpty) ...[
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: (clan.isFamilyFriendly ? 1 : 0) + clan.labels.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                if (clan.isFamilyFriendly && index == 0) {
                  return const _FamilyFriendlyChip();
                }
                final labelIndex = clan.isFamilyFriendly ? index - 1 : index;
                final label = clan.labels[labelIndex];
                return LabelChip(
                  name: label.name,
                  iconUrl: label.iconUrls.medium.isNotEmpty
                      ? label.iconUrls.medium
                      : label.iconUrls.small,
                );
              },
            ),
          ),
          const SizedBox(height: 14),
        ],
        if (clan.description.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              clan.description,
              style: const TextStyle(
                fontFamily: AppFonts.primary,
                color: Color(0xFF3B3B3B),
                fontSize: 11,
                height: 1.45,
              ),
            ),
          ),
      ],
    );
  }
}

class _FamilyFriendlyChip extends StatelessWidget {
  const _FamilyFriendlyChip();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.family_restroom_rounded, size: 16, color: colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            l10n.familyFriendly,
            style: TextStyle(
              fontFamily: AppFonts.primary,
              fontSize: 10,
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClanStatsCard extends StatelessWidget {
  final Clan clan;

  const _ClanStatsCard({required this.clan});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.12,
                  child: Image.asset(
                    'assets/images/MapBackground.jpeg',
                    fit: BoxFit.cover,
                    cacheWidth: 800,
                  ),
                ),
              ),
              Container(
                color: Colors.white.withValues(alpha: 0.94),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  children: [
                    StatDetail(
                      title: l10n.clanWarLeague,
                      value: clan.warLeague.name,
                    ),
                    _statDivider(colorScheme),
                    StatDetail(
                      title: l10n.totalPoints,
                      value:
                          '${clan.clanPoints} 🏆  ·  ${clan.clanCapitalPoints} ⚒',
                    ),
                    _statDivider(colorScheme),
                    StatDetail(
                      title: l10n.location,
                      value: clan.location.name,
                    ),
                    _statDivider(colorScheme),
                    StatDetail(
                      title: l10n.chatLanguage,
                      value: clan.chatLanguage.name,
                    ),
                    _statDivider(colorScheme),
                    StatDetail(
                      title: l10n.clanType,
                      value: clan.type,
                    ),
                    _statDivider(colorScheme),
                    StatDetail(
                      title: l10n.familyFriendly,
                      value: clan.isFamilyFriendly
                          ? l10n.familyFriendlyYes
                          : l10n.familyFriendlyNo,
                    ),
                    _statDivider(colorScheme),
                    StatDetail(
                      title: l10n.requiredTrophies,
                      value:
                          '${clan.requiredTrophies} 🏆  ·  ${clan.requiredBuilderBaseTrophies} ⚒',
                    ),
                    _statDivider(colorScheme),
                    StatDetail(
                      title: l10n.requiredTownHall,
                      value: '${clan.requiredTownhallLevel}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statDivider(ColorScheme colorScheme) {
    return Divider(
      height: 1,
      thickness: 1,
      color: colorScheme.secondary.withValues(alpha: 0.35),
    );
  }
}

class _WarStats extends StatelessWidget {
  final Clan clan;

  const _WarStats({required this.clan});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _WarStatTile(
                    label: l10n.wins,
                    value: '${clan.warWins}',
                    accent: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _WarStatTile(
                    label: l10n.ties,
                    value: '${clan.warTies}',
                    accent: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _WarStatTile(
                    label: l10n.losses,
                    value: '${clan.warLosses}',
                    accent: Colors.red.shade400,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _WarStatTile(
                    label: l10n.winStreak,
                    value: '${clan.warWinStreak}',
                    accent: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.secondary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l10n.warFrequencyLabel(clan.warFrequency),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  color: colorScheme.onPrimary,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 16),
            WarLogsList(clan: clan),
          ],
        ),
      ),
    );
  }
}

class _WarStatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const _WarStatTile({
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: accent,
              fontSize: 20,
              height: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppFonts.cardLabel(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  final MemberList player;
  final Player? viewerPlayer;

  const _MemberTile({
    required this.player,
    this.viewerPlayer,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final leagueIcon = player.league.iconUrls.medium.isEmpty
        ? 'http://clash-wiki.com/images/progress/leagues/no_league.png'
        : player.league.iconUrls.medium;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ClanMemberScreen(
                  member: player,
                  viewerPlayer: viewerPlayer,
                ),
              ),
            );
          },
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
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
                Hero(
                  tag: 'member-league-${player.tag}',
                  child: CocNetworkAvatar(
                    radius: 20,
                    url: leagueIcon,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        player.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppFonts.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.memberRoleLabel(player.role),
                        style: TextStyle(
                          fontFamily: AppFonts.light,
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${player.trophies} 🏆',
                      style: TextStyle(
                        fontFamily: AppFonts.primary,
                        color: colorScheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${l10n.donationsShort} ${player.donations}',
                      style: TextStyle(
                        fontFamily: AppFonts.light,
                        fontSize: 9,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      '${l10n.receivedShort} ${player.donationsReceived}',
                      style: TextStyle(
                        fontFamily: AppFonts.light,
                        fontSize: 9,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Clan clan;

  const _CustomSliverAppBar({required this.clan});

  static const _heroRadius = 28.0;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      expandedHeight: 248,
      floating: false,
      pinned: true,
      stretch: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(_heroRadius),
        ),
      ),
      leadingWidth: 42,
      leading: const GlassBackLeading(),
      title: Text(
        clan.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontFamily: AppFonts.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          shadows: AppFonts.onDarkSurfaceOutline,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: ClanHeroHeader(
            clan: clan,
            bottomRadius: _heroRadius,
          ),
        ),
      ),
    );
  }
}

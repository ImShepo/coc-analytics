import 'package:coc/config/helpers/player_tag.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/domain/entities/current_clan_war.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/providers/clans/current_war_provider.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_background_variant.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_stack.dart';
import 'package:coc/presentation/widgets/coc_network_image.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WarRoomScreen extends ConsumerWidget {
  final String clanTag;
  final String viewerTag;

  const WarRoomScreen({
    super.key,
    required this.clanTag,
    required this.viewerTag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final warAsync = ref.watch(
      currentWarProvider.select((session) => session.byTag[clanTag]),
    );
    final war = warAsync?.asData?.value;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppScreenStack(
        variant: AppScreenBackgroundVariant.clan,
        primary: colorScheme.onPrimary,
        secondary: colorScheme.secondary,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: colorScheme.onPrimary,
              leadingWidth: 42,
              leading: const GlassBackLeading(),
              centerTitle: false,
              title: AppBarScreenTitle(l10n.warRoomTitle),
            ),
            if (war == null || war.clan == null)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 28),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    _rows(context, war),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _rows(BuildContext context, CurrentClanWar war) {
    final l10n = context.l10n;
    final clan = war.clan!;
    final standings = warStandings(clan);
    final viewerId = normalizePlayerTag(viewerTag);
    WarStanding? mine;
    for (final standing in standings) {
      if (normalizePlayerTag(standing.member.tag) == viewerId) {
        mine = standing;
        break;
      }
    }

    return [
      _SideSummary(name: clan.name, badgeUrl: clan.badgeUrl, stars: clan.stars, destruction: clan.destructionPercentage),
      const SizedBox(height: 8),
      _SideSummary(
        name: war.opponent?.name ?? '',
        badgeUrl: war.opponent?.badgeUrl ?? '',
        stars: war.opponent?.stars ?? 0,
        destruction: war.opponent?.destructionPercentage ?? 0,
      ),
      const SizedBox(height: 16),
      Text(l10n.warRoomYourAttacks, style: AppFonts.sectionTitle()),
      const SizedBox(height: 6),
      if (mine == null || mine.member.attacks.isEmpty)
        Text(l10n.warRoomNoAttacksYet, style: AppFonts.scrimBody())
      else
        for (final attack in mine.member.attacks)
          Text(
            l10n.warRoomAttackLine(
              attack.stars,
              attack.destructionPercentage.toStringAsFixed(1),
            ),
            style: AppFonts.scrimBody(),
          ),
      const SizedBox(height: 16),
      Text(l10n.warRoomRanking, style: AppFonts.sectionTitle()),
      const SizedBox(height: 8),
      if (mine != null) ...[
        _YourPlaceCard(
          standing: mine,
          total: standings.length,
          attacksPerMember: war.attacksPerMember,
        ),
        const SizedBox(height: 8),
      ],
      for (final standing in standings)
        _StandingRow(
          standing: standing,
          attacksPerMember: war.attacksPerMember,
          highlighted: normalizePlayerTag(standing.member.tag) == viewerId,
        ),
    ];
  }
}

class _SideSummary extends StatelessWidget {
  final String name;
  final String badgeUrl;
  final int stars;
  final double destruction;

  const _SideSummary({
    required this.name,
    required this.badgeUrl,
    required this.stars,
    required this.destruction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (badgeUrl.isNotEmpty)
          CocNetworkImage(url: badgeUrl, width: 36, height: 36)
        else
          const SizedBox(width: 36, height: 36),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              fontFamily: AppFonts.primary,
              fontSize: 16,
              color: Color(0xFF2C2C2C),
            ),
          ),
        ),
        Text(
          '$stars ★  ${destruction.toStringAsFixed(1)}%',
          style: AppFonts.cardLabel(fontSize: 12),
        ),
      ],
    );
  }
}

class _YourPlaceCard extends StatelessWidget {
  final WarStanding standing;
  final int total;
  final int attacksPerMember;

  const _YourPlaceCard({
    required this.standing,
    required this.total,
    required this.attacksPerMember,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(
            '${standing.rank}',
            style: TextStyle(
              fontFamily: AppFonts.primary,
              fontSize: 28,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.warRoomYourPlace, style: AppFonts.sectionTitle(fontSize: 11)),
                const SizedBox(height: 2),
                Text(
                  l10n.warNowYourRank(standing.rank, total),
                  style: const TextStyle(
                    fontFamily: AppFonts.primary,
                    fontSize: 14,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                Text(
                  l10n.warNowStarsLine(
                    standing.stars,
                    standing.destruction.toStringAsFixed(1),
                  ),
                  style: AppFonts.cardLabel(fontSize: 12),
                ),
                Text(
                  l10n.warRoomAttacksUsed(
                    standing.member.attacksUsed,
                    attacksPerMember,
                  ),
                  style: AppFonts.cardLabel(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StandingRow extends StatelessWidget {
  final WarStanding standing;
  final int attacksPerMember;
  final bool highlighted;

  const _StandingRow({
    required this.standing,
    required this.attacksPerMember,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final member = standing.member;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: highlighted
            ? colorScheme.primary.withValues(alpha: 0.16)
            : Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${standing.rank}',
              style: TextStyle(
                fontFamily: AppFonts.primary,
                fontSize: 14,
                color: highlighted ? colorScheme.primary : const Color(0xFF2C2C2C),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppFonts.primary,
                    fontSize: 13,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                if (member.townHallLevel > 0)
                  Text(
                    l10n.townHallShort(member.townHallLevel),
                    style: AppFonts.cardLabel(fontSize: 10),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                l10n.warNowStarsLine(
                  standing.stars,
                  standing.destruction.toStringAsFixed(1),
                ),
                style: AppFonts.cardLabel(fontSize: 11),
              ),
              Text(
                l10n.warRoomAttacksUsed(member.attacksUsed, attacksPerMember),
                style: AppFonts.cardLabel(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

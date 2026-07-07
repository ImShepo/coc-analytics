import 'package:coc/config/helpers/member_role.dart';
import 'package:coc/config/helpers/player_tag.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/domain/entities/member_list.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:coc/l10n/category_unit_l10n.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/screens/compare_screen.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_stack.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_background_variant.dart';
import 'package:coc/presentation/widgets/coc_network_image.dart';
import 'package:coc/presentation/widgets/member_profile_categories.dart';
import 'package:flutter/material.dart';

class ClanMemberScreen extends StatelessWidget {
  final MemberList member;
  final Player? viewerPlayer;

  const ClanMemberScreen({
    super.key,
    required this.member,
    this.viewerPlayer,
  });

  String _townHallAsset(int level) {
    final assetLevel = level.clamp(1, 16);
    return 'assets/images/townhall/TownHall$assetLevel.png';
  }

  String get _leagueIcon => member.league.iconUrls.medium.isEmpty
      ? 'http://clash-wiki.com/images/progress/leagues/no_league.png'
      : member.league.iconUrls.medium;

  int get _rankDelta => member.previousClanRank - member.clanRank;

  void _openCompare(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CompareScreen(
          me: viewerPlayer!,
          initialOpponentTag: member.tag,
          initialOpponentName: member.name,
        ),
      ),
    );
  }

  bool get _canCompare =>
      viewerPlayer != null &&
      normalizePlayerTag(viewerPlayer!.tag) != normalizePlayerTag(member.tag);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final roleColor = memberRoleColor(member.role);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppScreenStack(
        variant: AppScreenBackgroundVariant.member,
        child: CustomScrollView(
        key: PageStorageKey<String>('member-scroll-${member.tag}'),
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 230,
            pinned: true,
            backgroundColor: colorScheme.onPrimary,
            leadingWidth: 42,
            leading: const GlassBackLeading(),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/ClashOfClans.jpeg',
                    fit: BoxFit.cover,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorScheme.onPrimary.withValues(alpha: 0.55),
                          colorScheme.onPrimary.withValues(alpha: 0.92),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, 0.35),
                    child: Hero(
                      tag: 'member-league-${member.tag}',
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: roleColor, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: roleColor.withValues(alpha: 0.45),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: CocNetworkAvatar(
                              radius: 42,
                              url: _leagueIcon,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          if (_canCompare)
                            Positioned(
                              bottom: -6,
                              child: _CompareHeroButton(
                                onTap: () => _openCompare(context),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -28),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _ProfileHeader(member: member, roleColor: roleColor),
                    const SizedBox(height: 16),
                    _RankCard(
                      rank: member.clanRank,
                      rankDelta: _rankDelta,
                    ),
                    const SizedBox(height: 14),
                    _SectionTitle(title: l10n.mainTownHall),
                    const SizedBox(height: 8),
                    _StatsPanel(
                      children: [
                        _HighlightStat(
                          icon: Icons.emoji_events_outlined,
                          label: l10n.trophies,
                          value: '${member.trophies}',
                          accent: colorScheme.primary,
                        ),
                        _DetailRow(
                          label: l10n.league,
                          value: member.league.name,
                          trailing: _LeagueBadge(url: _leagueIcon),
                        ),
                        _DetailRow(
                          label: l10n.townHall,
                          value: l10n.levelLabel(member.townHallLevel),
                          trailing: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              _townHallAsset(member.townHallLevel),
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        _DetailRow(
                          label: l10n.experience,
                          value: l10n.levelLabel(member.expLevel),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _SectionTitle(title: l10n.builderBaseSection),
                    const SizedBox(height: 8),
                    _StatsPanel(
                      children: [
                        _HighlightStat(
                          icon: Icons.construction_outlined,
                          label: l10n.trophiesBB,
                          value: '${member.builderBaseTrophies}',
                          accent: colorScheme.onPrimary,
                        ),
                        _DetailRow(
                          label: l10n.leagueBB,
                          value: member.builderBaseLeague.name,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _SectionTitle(title: l10n.clanContribution),
                    const SizedBox(height: 8),
                    _DonationsCard(
                      donated: member.donations,
                      received: member.donationsReceived,
                    ),
                    const SizedBox(height: 14),
                    MemberProfileCategories(memberTag: member.tag),
                    const SizedBox(height: 14),
                    _TagCard(tag: member.tag),
                    if (_canCompare) ...[
                      const SizedBox(height: 12),
                      _CompareActionCard(onTap: () => _openCompare(context)),
                    ],
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final MemberList member;
  final Color roleColor;

  const _ProfileHeader({
    required this.member,
    required this.roleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 52, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            member.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.primary,
              fontSize: 22,
              height: 1.1,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: roleColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: roleColor.withValues(alpha: 0.5)),
            ),
            child: Text(
              context.l10n.memberRoleLabel(member.role).toUpperCase(),
              style: TextStyle(
                fontFamily: AppFonts.light,
                fontSize: 10,
                letterSpacing: 0.8,
                color: roleColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RankCard extends StatelessWidget {
  final int rank;
  final int rankDelta;

  const _RankCard({required this.rank, required this.rankDelta});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final improved = rankDelta > 0;
    final dropped = rankDelta < 0;
    final deltaColor = improved
        ? colorScheme.primary
        : dropped
            ? Colors.red.shade400
            : Colors.grey.shade600;
    final deltaLabel = rankDelta == 0
        ? l10n.noRankChange
        : improved
            ? '+$rankDelta'
            : '$rankDelta';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.onPrimary.withValues(alpha: 0.92),
            colorScheme.onPrimary.withValues(alpha: 0.78),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onPrimary.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '#$rank',
              style: const TextStyle(
                fontFamily: AppFonts.primary,
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.rankInClan,
                  style: const TextStyle(
                    fontFamily: AppFonts.light,
                    color: Colors.white70,
                    fontSize: 9,
                    letterSpacing: 0.7,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.clanPosition(rank),
                  style: const TextStyle(
                    fontFamily: AppFonts.primary,
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                improved
                    ? Icons.trending_up_rounded
                    : dropped
                        ? Icons.trending_down_rounded
                        : Icons.trending_flat_rounded,
                color: deltaColor,
                size: 20,
              ),
              const SizedBox(height: 2),
              Text(
                deltaLabel,
                style: TextStyle(
                  fontFamily: AppFonts.light,
                  color: deltaColor,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontFamily: AppFonts.primary,
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _StatsPanel extends StatelessWidget {
  final List<Widget> children;

  const _StatsPanel({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
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
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Divider(
                height: 20,
                thickness: 1,
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withValues(alpha: 0.35),
              ),
          ],
        ],
      ),
    );
  }
}

class _HighlightStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  const _HighlightStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: accent, size: 22),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontFamily: AppFonts.light,
                color: Colors.grey.shade600,
                fontSize: 9,
                letterSpacing: 0.6,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontFamily: AppFonts.primary,
                color: accent,
                fontSize: 24,
                height: 1,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const _DetailRow({
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.light,
              color: Colors.grey.shade700,
              fontSize: 11,
            ),
          ),
        ),
        if (trailing != null) ...[
          trailing!,
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _LeagueBadge extends StatelessWidget {
  final String url;

  const _LeagueBadge({required this.url});

  @override
  Widget build(BuildContext context) {
    return CocNetworkImage(
      url: url,
      width: 24,
      height: 24,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(6),
    );
  }
}

class _DonationsCard extends StatelessWidget {
  final int donated;
  final int received;

  const _DonationsCard({
    required this.donated,
    required this.received,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final total = donated + received;
    final donateRatio = total == 0 ? 0.5 : donated / total;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DonationStat(
                label: l10n.donated,
                value: '$donated',
                color: colorScheme.primary,
              ),
              _DonationStat(
                label: l10n.received,
                value: '$received',
                color: colorScheme.onPrimary,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Expanded(
                    flex: (donateRatio * 100).round().clamp(1, 99),
                    child: ColoredBox(color: colorScheme.primary),
                  ),
                  Expanded(
                    flex: ((1 - donateRatio) * 100).round().clamp(1, 99),
                    child: ColoredBox(
                      color: colorScheme.onPrimary.withValues(alpha: 0.35),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            total == 0
                ? l10n.donationActivityNone
                : l10n.donationBalance(
                    (donateRatio * 100).round(),
                    (100 - donateRatio * 100).round(),
                  ),
            textAlign: TextAlign.center,
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

class _DonationStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _DonationStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFonts.primary,
            color: color,
            fontSize: 22,
            height: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: AppFonts.light,
            color: Colors.grey.shade600,
            fontSize: 9,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _CompareHeroButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CompareHeroButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GlassButton(
      label: l10n.compare,
      icon: Icons.compare_arrows_rounded,
      onPressed: onTap,
      style: GlassButtonStyle.primary,
      height: 32,
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }
}

class _CompareActionCard extends StatelessWidget {
  final VoidCallback onTap;

  const _CompareActionCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: LiquidGlassSurface(
          borderRadius: BorderRadius.circular(16),
          tintColor: colorScheme.primary,
          tintStrength: 0.45,
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(Icons.insights_rounded, color: colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.compareStatsTitle,
                      style: TextStyle(
                        fontFamily: AppFonts.primary,
                        color: colorScheme.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.compareStatsSubtitle,
                      style: TextStyle(
                        fontFamily: AppFonts.light,
                        color: Colors.grey.shade700,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _TagCard extends StatelessWidget {
  final String tag;

  const _TagCard({required this.tag});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.secondary.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.tag_rounded, size: 16, color: colorScheme.onPrimary),
          const SizedBox(width: 8),
          Text(
            tag,
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: colorScheme.onPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

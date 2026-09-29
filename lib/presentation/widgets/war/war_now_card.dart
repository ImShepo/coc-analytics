import 'package:coc/config/helpers/errors.dart';
import 'package:coc/config/helpers/player_tag.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/domain/entities/current_clan_war.dart';
import 'package:coc/l10n/app_localizations.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/providers/clans/current_war_provider.dart';
import 'package:coc/presentation/screens/war_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WarNowCard extends ConsumerWidget {
  final String clanTag;
  final String viewerTag;

  const WarNowCard({
    super.key,
    required this.clanTag,
    required this.viewerTag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final warAsync = ref.watch(
      currentWarProvider.select((session) => session.byTag[clanTag]),
    );

    if (warAsync == null || warAsync.isLoading) {
      return const _WarLine(child: LinearProgressIndicator(minHeight: 2));
    }

    if (warAsync.hasError) {
      if (isApiForbidden(warAsync.error!)) return const SizedBox.shrink();
      return _WarLine(
        child: Text(l10n.warNowLoadError, style: AppFonts.cardLabel(fontSize: 12)),
      );
    }

    final war = warAsync.value;
    if (war == null || !war.hasRoster) {
      return _WarLine(
        child: Text(l10n.warNowNotInWar, style: AppFonts.cardLabel(fontSize: 12)),
      );
    }

    final standings = war.clan == null ? const <WarStanding>[] : warStandings(war.clan!);
    final mine = _standingFor(standings, viewerTag);
    final attacksLeft = mine == null
        ? null
        : (war.attacksPerMember - mine.member.attacksUsed)
            .clamp(0, war.attacksPerMember);
    final clock = warClockLabel(l10n, war);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Material(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ref.read(currentWarProvider.notifier).load(clanTag, force: true);
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => WarRoomScreen(
                  clanTag: clanTag,
                  viewerTag: viewerTag,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.warNowTitle, style: AppFonts.sectionTitle(fontSize: 11)),
                const SizedBox(height: 4),
                Text(
                  warStateLabel(l10n, war.state),
                  style: AppFonts.cardLabel(fontSize: 13),
                ),
                if ((war.opponent?.name ?? '').isNotEmpty)
                  Text(
                    war.opponent!.name,
                    style: const TextStyle(
                      fontFamily: AppFonts.primary,
                      fontSize: 16,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  l10n.warNowStarsLine(
                    war.clan?.stars ?? 0,
                    _percent(war.clan?.destructionPercentage ?? 0),
                  ),
                  style: AppFonts.cardLabel(fontSize: 12),
                ),
                if (mine != null)
                  Text(
                    l10n.warNowYourRank(mine.rank, standings.length),
                    style: AppFonts.cardLabel(fontSize: 12),
                  ),
                if (attacksLeft != null)
                  Text(
                    l10n.warNowAttacksLeft(attacksLeft),
                    style: AppFonts.cardLabel(fontSize: 12),
                  ),
                if (clock != null)
                  Text(clock, style: AppFonts.cardLabel(fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WarLine extends StatelessWidget {
  final Widget child;

  const _WarLine({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 12, 8),
      child: child,
    );
  }
}

WarStanding? _standingFor(List<WarStanding> standings, String viewerTag) {
  final id = normalizePlayerTag(viewerTag);
  for (final standing in standings) {
    if (normalizePlayerTag(standing.member.tag) == id) return standing;
  }
  return null;
}

String warStateLabel(AppLocalizations l10n, ClanWarState state) {
  return switch (state) {
    ClanWarState.preparation => l10n.warNowPreparation,
    ClanWarState.inWar => l10n.warNowInWar,
    ClanWarState.warEnded => l10n.warNowEnded,
    ClanWarState.notInWar || ClanWarState.unknown => l10n.warNowNotInWar,
  };
}

String? warClockLabel(AppLocalizations l10n, CurrentClanWar war) {
  final now = DateTime.now().toUtc();
  if (war.state == ClanWarState.preparation && war.startTime != null) {
    return l10n.warNowStartsIn(_formatClock(war.startTime!.difference(now)));
  }
  if (war.state == ClanWarState.inWar && war.endTime != null) {
    return l10n.warNowEndsIn(_formatClock(war.endTime!.difference(now)));
  }
  return null;
}

String _formatClock(Duration duration) {
  final remaining = duration.isNegative ? Duration.zero : duration;
  final hours = remaining.inHours;
  final minutes = remaining.inMinutes.remainder(60);
  if (hours > 0) return '${hours}h ${minutes}m';
  return '${minutes}m';
}

String _percent(double value) => value.toStringAsFixed(1);

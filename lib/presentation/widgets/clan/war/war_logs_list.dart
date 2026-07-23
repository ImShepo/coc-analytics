import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/domain/entities/clan.dart';
import 'package:coc/domain/entities/clan_war_log.dart';
import 'package:coc/l10n/app_localizations.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/providers/clans/clans_repository_provider.dart';
import 'package:coc/presentation/widgets/coc_network_image.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _WarLogTab { home, builder, capital }

class WarLogsList extends StatefulWidget {
  final Clan clan;

  const WarLogsList({super.key, required this.clan});

  @override
  State<WarLogsList> createState() => _WarLogsListState();
}

class _WarLogsListState extends State<WarLogsList> {
  _WarLogTab selectedWarLog = _WarLogTab.home;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 34,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _warLogTab(_WarLogTab.home, l10n.warLogTabHome),
              _warLogTab(_WarLogTab.builder, l10n.warLogTabBuilder),
              _warLogTab(_WarLogTab.capital, l10n.warLogTabCapital),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (!widget.clan.isWarLogPublic) const _PrivateWarLogBanner(),
        if (!widget.clan.isWarLogPublic) const SizedBox(height: 10),
        _warLogContent(),
      ],
    );
  }

  Widget _warLogTab(_WarLogTab tab, String label) {
    final isSelected = tab == selectedWarLog;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GlassChipButton(
        label: label,
        selected: isSelected,
        onPressed: () => setState(() => selectedWarLog = tab),
      ),
    );
  }

  Widget _warLogContent() {
    final clan = widget.clan;

    return switch (selectedWarLog) {
      _WarLogTab.home => HomeVillageWarLog(clan: clan),
      _WarLogTab.builder => BuilderBaseWarLog(clan: clan),
      _WarLogTab.capital => ClanCapitalWarLog(clan: clan),
    };
  }
}

class _PrivateWarLogBanner extends StatelessWidget {
  const _PrivateWarLogBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.secondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, size: 16, color: colorScheme.onPrimary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.warLogPrivateHint,
              style: TextStyle(
                fontFamily: AppFonts.primary,
                color: colorScheme.onPrimary,
                fontSize: 10,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarLogPanel extends StatelessWidget {
  final List<_WarLogRowData> rows;
  final String? footer;

  const _WarLogPanel({
    required this.rows,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            _WarLogRow(label: rows[i].label, value: rows[i].value),
            if (i < rows.length - 1)
              Divider(
                height: 16,
                thickness: 1,
                color: colorScheme.secondary.withValues(alpha: 0.35),
              ),
          ],
          if (footer != null) ...[
            const SizedBox(height: 10),
            Text(
              footer!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.primary,
                color: Colors.grey.shade600,
                fontSize: 10,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WarLogRowData {
  final String label;
  final String value;

  const _WarLogRowData(this.label, this.value);
}

class _WarLogRow extends StatelessWidget {
  final String label;
  final String value;

  const _WarLogRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppFonts.cardLabel(fontSize: 11, height: 1.3),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
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
    );
  }
}

String _formatCocDate(String raw) {
  if (raw.length < 8) return raw;
  final y = raw.substring(0, 4);
  final m = raw.substring(4, 6);
  final d = raw.substring(6, 8);
  return '$d/$m/$y';
}

String _warResultLabel(AppLocalizations l10n, String result) {
  return switch (result) {
    'win' => l10n.warResultWin,
    'lose' => l10n.warResultLose,
    'tie' => l10n.warResultTie,
    _ => result.isEmpty ? '—' : result,
  };
}

class HomeVillageWarLog extends ConsumerStatefulWidget {
  final Clan clan;

  const HomeVillageWarLog({super.key, required this.clan});

  @override
  ConsumerState<HomeVillageWarLog> createState() => _HomeVillageWarLogState();
}

class _HomeVillageWarLogState extends ConsumerState<HomeVillageWarLog> {
  late final Future<List<ClanWarLogEntry>>? _warLogFuture;

  int get _totalWars =>
      widget.clan.warWins + widget.clan.warTies + widget.clan.warLosses;

  String get _winRate {
    if (_totalWars == 0) return '—';
    final rate = (widget.clan.warWins / _totalWars * 100).round();
    return '$rate%';
  }

  @override
  void initState() {
    super.initState();
    _warLogFuture = widget.clan.isWarLogPublic
        ? ref
            .read(clanRepositoryProvider)
            .getWarLog(widget.clan.tag, limit: 12)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final clan = widget.clan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WarLogPanel(
          rows: [
            _WarLogRowData(l10n.warLeagueLabel, clan.warLeague.name),
            _WarLogRowData(l10n.warFrequencyShort, clan.warFrequency),
            _WarLogRowData(l10n.wins, '${clan.warWins}'),
            _WarLogRowData(l10n.ties, '${clan.warTies}'),
            _WarLogRowData(l10n.losses, '${clan.warLosses}'),
            _WarLogRowData(l10n.winStreakLabel, '${clan.warWinStreak}'),
            _WarLogRowData(l10n.totalWarsLabel, '$_totalWars'),
            _WarLogRowData(l10n.winRateLabel, _winRate),
          ],
          footer: clan.isWarLogPublic ? null : l10n.warLogPrivateFooter,
        ),
        if (_warLogFuture != null) ...[
          const SizedBox(height: 12),
          FutureBuilder<List<ClanWarLogEntry>>(
            future: _warLogFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return _WarLogPanel(
                  rows: const [],
                  footer: l10n.warLogLoadError,
                );
              }
              final entries = snapshot.data ?? const [];
              if (entries.isEmpty) {
                return _WarLogPanel(
                  rows: const [],
                  footer: l10n.warLogEmpty,
                );
              }
              return Column(
                children: [
                  for (var i = 0; i < entries.length; i++) ...[
                    if (i > 0) const SizedBox(height: 8),
                    _WarLogEntryCard(entry: entries[i]),
                  ],
                ],
              );
            },
          ),
        ],
      ],
    );
  }
}

class _WarLogEntryCard extends StatelessWidget {
  final ClanWarLogEntry entry;

  const _WarLogEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final resultColor = switch (entry.result) {
      'win' => colorScheme.primary,
      'lose' => const Color(0xFFB54A4A),
      'tie' => const Color(0xFFC9A227),
      _ => colorScheme.onPrimary,
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          if (entry.opponent.badgeUrl.isNotEmpty)
            CocNetworkImage(
              url: entry.opponent.badgeUrl,
              width: 36,
              height: 36,
              fit: BoxFit.cover,
              cacheWidth: 72,
              fadeIn: false,
              animatedPlaceholder: false,
              borderRadius: BorderRadius.circular(8),
            )
          else
            Icon(Icons.shield_outlined, color: colorScheme.primary, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.opponent.name.isEmpty ? '—' : entry.opponent.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.primary,
                    color: colorScheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatCocDate(entry.endTime),
                  style: AppFonts.cardLabel(fontSize: 10),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _warResultLabel(l10n, entry.result),
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  color: resultColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${entry.clan.stars}★ · ${entry.clan.destructionPercentage.round()}%',
                style: AppFonts.cardLabel(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BuilderBaseWarLog extends StatelessWidget {
  final Clan clan;

  const BuilderBaseWarLog({super.key, required this.clan});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _WarLogPanel(
      rows: [
        _WarLogRowData(
          l10n.builderPointsLabel,
          '${clan.clanBuilderBasePoints} ⚒',
        ),
        _WarLogRowData(
          l10n.requiredTrophiesLabel,
          '${clan.requiredBuilderBaseTrophies} ⚒',
        ),
        _WarLogRowData(l10n.membersLabel, '${clan.members}'),
      ],
      footer: l10n.builderWarComingSoon,
    );
  }
}

class ClanCapitalWarLog extends ConsumerStatefulWidget {
  final Clan clan;

  const ClanCapitalWarLog({super.key, required this.clan});

  @override
  ConsumerState<ClanCapitalWarLog> createState() => _ClanCapitalWarLogState();
}

class _ClanCapitalWarLogState extends ConsumerState<ClanCapitalWarLog> {
  late final Future<List<CapitalRaidSeason>> _raidsFuture;

  @override
  void initState() {
    super.initState();
    _raidsFuture = ref
        .read(clanRepositoryProvider)
        .getCapitalRaidSeasons(widget.clan.tag, limit: 8);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final clan = widget.clan;
    final capital = clan.clanCapital;
    final districts = [...capital.districts]
      ..sort((a, b) => a.name.compareTo(b.name));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WarLogPanel(
          rows: [
            _WarLogRowData(
              l10n.capitalPointsLabel,
              '${clan.clanCapitalPoints} ⚒',
            ),
            _WarLogRowData(l10n.capitalLeagueLabel, clan.capitalLeague.name),
            if (capital.capitalHallLevel > 0)
              _WarLogRowData(
                l10n.capitalHallLevelLabel,
                '${capital.capitalHallLevel}',
              ),
            _WarLogRowData(l10n.clanLevelLabel, '${clan.clanLevel}'),
          ],
        ),
        if (districts.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            l10n.capitalDistrictsLabel,
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: colorScheme.onPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _WarLogPanel(
            rows: [
              for (final district in districts)
                _WarLogRowData(
                  district.name,
                  'Nv. ${district.districtHallLevel}',
                ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        FutureBuilder<List<CapitalRaidSeason>>(
          future: _raidsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
            if (snapshot.hasError) {
              return _WarLogPanel(
                rows: const [],
                footer: l10n.capitalRaidsLoadError,
              );
            }
            final seasons = snapshot.data ?? const [];
            if (seasons.isEmpty) {
              return _WarLogPanel(
                rows: const [],
                footer: l10n.capitalRaidsEmpty,
              );
            }
            return Column(
              children: [
                for (var i = 0; i < seasons.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  _RaidSeasonCard(season: seasons[i]),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _RaidSeasonCard extends StatelessWidget {
  final CapitalRaidSeason season;

  const _RaidSeasonCard({required this.season});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _WarLogPanel(
      rows: [
        _WarLogRowData(
          _formatCocDate(season.startTime),
          season.state,
        ),
        _WarLogRowData(
          l10n.capitalRaidLoot,
          '${season.capitalTotalLoot}',
        ),
        _WarLogRowData(
          l10n.capitalRaidRaids,
          '${season.raidsCompleted}',
        ),
        _WarLogRowData(
          l10n.capitalRaidAttacks,
          '${season.totalAttacks}',
        ),
        _WarLogRowData(
          l10n.capitalRaidDistricts,
          '${season.enemyDistrictsDestroyed}',
        ),
      ],
    );
  }
}

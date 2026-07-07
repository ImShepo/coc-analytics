import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/domain/entities/clan.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:flutter/material.dart';

enum _WarLogTab { home, builder, capital }

class WarLogsList extends StatefulWidget {
  final Clan clan;

  const WarLogsList({super.key, required this.clan});

  @override
  WarLogsListState createState() => WarLogsListState();
}

class WarLogsListState extends State<WarLogsList> {
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
                fontFamily: AppFonts.light,
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
                fontFamily: AppFonts.light,
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

class HomeVillageWarLog extends StatelessWidget {
  final Clan clan;

  const HomeVillageWarLog({super.key, required this.clan});

  int get _totalWars => clan.warWins + clan.warTies + clan.warLosses;

  String get _winRate {
    if (_totalWars == 0) return '—';
    final rate = (clan.warWins / _totalWars * 100).round();
    return '$rate%';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _WarLogPanel(
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

class ClanCapitalWarLog extends StatelessWidget {
  final Clan clan;

  const ClanCapitalWarLog({super.key, required this.clan});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _WarLogPanel(
      rows: [
        _WarLogRowData(
          l10n.capitalPointsLabel,
          '${clan.clanCapitalPoints} ⚒',
        ),
        _WarLogRowData(l10n.capitalLeagueLabel, clan.capitalLeague.name),
        _WarLogRowData(l10n.clanLevelLabel, '${clan.clanLevel}'),
      ],
      footer: l10n.capitalRaidsComingSoon,
    );
  }
}

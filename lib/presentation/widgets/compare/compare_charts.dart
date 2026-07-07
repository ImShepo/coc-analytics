import 'dart:math' as math;

import 'package:coc/config/helpers/achievement_utils.dart';
import 'package:coc/config/helpers/coc_unit_image.dart';
import 'package:coc/config/helpers/player_compare.dart';
import 'package:coc/config/helpers/troop_catalog.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/l10n/catalog_l10n.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/widgets/categories/coc_unit_image_widget.dart';
import 'package:flutter/material.dart';

class CompareRadarChart extends StatelessWidget {
  final List<RadarAxis> axes;
  final Color youColor;
  final Color themColor;

  const CompareRadarChart({
    super.key,
    required this.axes,
    required this.youColor,
    required this.themColor,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _RadarPainter(
          axes: axes,
          youColor: youColor,
          themColor: themColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Stack(
            children: [
              for (var i = 0; i < axes.length; i++)
                _AxisLabel(
                  label: axes[i].label,
                  index: i,
                  total: axes.length,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AxisLabel extends StatelessWidget {
  final String label;
  final int index;
  final int total;

  const _AxisLabel({
    required this.label,
    required this.index,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final angle = -math.pi / 2 + (2 * math.pi * index / total);
    final alignment = Alignment(
      math.cos(angle) * 1.05,
      math.sin(angle) * 1.05,
    );

    return Align(
      alignment: alignment,
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.light,
          color: Colors.grey.shade700,
          fontSize: 9,
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final List<RadarAxis> axes;
  final Color youColor;
  final Color themColor;

  _RadarPainter({
    required this.axes,
    required this.youColor,
    required this.themColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (axes.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    final count = axes.length;

    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var ring = 1; ring <= 4; ring++) {
      final r = radius * ring / 4;
      final path = Path();
      for (var i = 0; i < count; i++) {
        final angle = -math.pi / 2 + (2 * math.pi * i / count);
        final point = center + Offset(math.cos(angle) * r, math.sin(angle) * r);
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    for (var i = 0; i < count; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / count);
      final end = center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      canvas.drawLine(center, end, gridPaint);
    }

    _drawPolygon(canvas, center, radius, axes.map((a) => a.them).toList(), themColor, 0.18);
    _drawPolygon(canvas, center, radius, axes.map((a) => a.you).toList(), youColor, 0.28);
  }

  void _drawPolygon(
    Canvas canvas,
    Offset center,
    double radius,
    List<double> values,
    Color color,
    double fillAlpha,
  ) {
    final count = values.length;
    final path = Path();
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    final fill = Paint()
      ..color = color.withValues(alpha: fillAlpha)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < count; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / count);
      final value = values[i].clamp(0.0, 1.0);
      final point = center +
          Offset(math.cos(angle) * radius * value, math.sin(angle) * radius * value);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.axes != axes;
}

class CompareDualBar extends StatelessWidget {
  final String label;
  final int you;
  final int them;
  final Color youColor;
  final Color themColor;

  const CompareDualBar({
    super.key,
    required this.label,
    required this.you,
    required this.them,
    required this.youColor,
    required this.themColor,
  });

  @override
  Widget build(BuildContext context) {
    final max = [you, them, 1].reduce((a, b) => a > b ? a : b);
    final youRatio = you / max;
    final themRatio = them / max;
    final winner = you > them
        ? CompareWinner.you
        : them > you
            ? CompareWinner.them
            : CompareWinner.tie;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFonts.light,
                    color: Colors.grey.shade700,
                    fontSize: 10,
                  ),
                ),
              ),
              if (winner == CompareWinner.you)
                Icon(Icons.arrow_back_rounded, size: 12, color: youColor)
              else if (winner == CompareWinner.them)
                Icon(Icons.arrow_forward_rounded, size: 12, color: themColor),
            ],
          ),
          const SizedBox(height: 6),
          _BarRow(value: you, ratio: youRatio, color: youColor, alignEnd: false),
          const SizedBox(height: 4),
          _BarRow(value: them, ratio: themRatio, color: themColor, alignEnd: true),
        ],
      ),
    );
  }
}

class _BarRow extends StatelessWidget {
  final int value;
  final double ratio;
  final Color color;
  final bool alignEnd;

  const _BarRow({
    required this.value,
    required this.ratio,
    required this.color,
    required this.alignEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!alignEnd)
          SizedBox(
            width: 42,
            child: Text(
              '$value',
              style: TextStyle(
                fontFamily: AppFonts.primary,
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio.clamp(0.05, 1.0),
              minHeight: 8,
              backgroundColor: color.withValues(alpha: 0.12),
              color: color,
            ),
          ),
        ),
        if (alignEnd)
          SizedBox(
            width: 42,
            child: Text(
              '$value',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: AppFonts.primary,
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

class CompareAchievementSummaryCard extends StatelessWidget {
  final String title;
  final AchievementStats you;
  final AchievementStats them;
  final Color youColor;
  final Color themColor;

  const CompareAchievementSummaryCard({
    super.key,
    required this.title,
    required this.you,
    required this.them,
    required this.youColor,
    required this.themColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          CompareDualBar(
            label: l10n.compareCompleted,
            you: you.completed,
            them: them.completed,
            youColor: youColor,
            themColor: themColor,
          ),
          CompareDualBar(
            label: l10n.starsEarned,
            you: you.earnedStars,
            them: them.earnedStars,
            youColor: youColor,
            themColor: themColor,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: _PctChip(
                  label: l10n.yourProgress,
                  value: you.completionRate,
                  color: youColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PctChip(
                  label: l10n.rival,
                  value: them.completionRate,
                  color: themColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PctChip extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _PctChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            '${(value * 100).round()}%',
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.light,
              color: Colors.grey.shade600,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class CompareAchievementMatchTile extends StatelessWidget {
  final AchievementMatch match;
  final Color youColor;
  final Color themColor;

  const CompareAchievementMatchTile({
    super.key,
    required this.match,
    required this.youColor,
    required this.themColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final winner = match.winner;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            match.name,
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _SideStat(
                  label: l10n.you,
                  stars: match.yours.stars,
                  done: match.yours.target > 0 && match.yours.value >= match.yours.target,
                  color: youColor,
                  highlight: winner == CompareWinner.you,
                ),
              ),
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  l10n.versus,
                  style: TextStyle(
                    fontFamily: AppFonts.light,
                    color: Colors.grey.shade600,
                    fontSize: 8,
                  ),
                ),
              ),
              Expanded(
                child: _SideStat(
                  label: l10n.rival,
                  stars: match.theirs.stars,
                  done: match.theirs.target > 0 && match.theirs.value >= match.theirs.target,
                  color: themColor,
                  highlight: winner == CompareWinner.them,
                  alignEnd: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SideStat extends StatelessWidget {
  final String label;
  final int stars;
  final bool done;
  final Color color;
  final bool highlight;
  final bool alignEnd;

  const _SideStat({
    required this.label,
    required this.stars,
    required this.done,
    required this.color,
    required this.highlight,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    final completedLabel = context.l10n.completed;
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.light,
            color: Colors.grey.shade600,
            fontSize: 9,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (highlight)
              Icon(Icons.emoji_events_rounded, size: 12, color: color),
            Text(
              done ? completedLabel : '★' * stars,
              style: TextStyle(
                fontFamily: AppFonts.primary,
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CompareTroopGroupSummaryCard extends StatelessWidget {
  final TroopGroupSummary summary;
  final Color youColor;
  final Color themColor;

  const CompareTroopGroupSummaryCard({
    super.key,
    required this.summary,
    required this.youColor,
    required this.themColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: TroopCatalog.troopGroupColor(summary.group),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.troopGroupLabel(summary.group).toUpperCase(),
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          CompareDualBar(
            label: l10n.unlocked,
            you: summary.youUnlocked,
            them: summary.themUnlocked,
            youColor: youColor,
            themColor: themColor,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.totalAvailable(summary.youTotal, summary.themTotal),
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

class CompareTroopMatchTile extends StatelessWidget {
  final TroopMatch match;
  final Color youColor;
  final Color themColor;

  const CompareTroopMatchTile({
    super.key,
    required this.match,
    required this.youColor,
    required this.themColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final winner = match.winner;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: CocUnitImageWidget(
                    name: match.name,
                    category: UnitCategory.troop,
                    width: 44,
                    height: 44,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  match.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.primary,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ),
              if (winner == CompareWinner.you)
                Icon(Icons.emoji_events_rounded, size: 14, color: youColor)
              else if (winner == CompareWinner.them)
                Icon(Icons.emoji_events_rounded, size: 14, color: themColor),
            ],
          ),
          const SizedBox(height: 10),
          CompareDualBar(
            label: l10n.level,
            you: match.youLevel,
            them: match.themLevel,
            youColor: youColor,
            themColor: themColor,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.maximumVs(match.youMax, match.themMax),
            style: TextStyle(
              fontFamily: AppFonts.light,
              color: Colors.grey.shade600,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

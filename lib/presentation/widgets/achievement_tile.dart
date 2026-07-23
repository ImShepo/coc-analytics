import 'package:coc/config/helpers/human_formats.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AchievementTile extends StatelessWidget {
  final Achievement achievement;
  final bool showVillage;

  const AchievementTile({
    super.key,
    required this.achievement,
    this.showVillage = true,
  });

  bool get _isComplete =>
      achievement.target > 0 && achievement.value >= achievement.target;

  double get _progress => achievement.target == 0
      ? 0
      : (achievement.value / achievement.target).clamp(0.0, 1.0);

  String _formatCount(int n) {
    if (n >= 1000000) {
      return NumberFormat.compact(locale: 'en').format(n);
    }
    return HumanFormats.number(n.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const starColor = Color(0xFFC9A227);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isComplete
              ? colorScheme.primary.withValues(alpha: 0.35)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${'★' * achievement.stars.clamp(0, 3)}${'☆' * (3 - achievement.stars.clamp(0, 3))}',
                style: const TextStyle(color: starColor, fontSize: 12, height: 1.2),
              ),
              const Spacer(),
              if (_isComplete)
                Icon(Icons.check_circle_rounded, size: 16, color: colorScheme.primary)
              else
                Text(
                  '${(_progress * 100).round()}%',
                  style: TextStyle(
                    fontFamily: AppFonts.light,
                    color: Colors.grey.shade600,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            achievement.name,
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: colorScheme.onPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),
          ),
          if (achievement.info.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              achievement.info,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFonts.light,
                color: Colors.grey.shade600,
                fontSize: 10,
                height: 1.3,
              ),
            ),
          ],
          if (achievement.completionInfo != null &&
              achievement.completionInfo!.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              achievement.completionInfo!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFonts.primary,
                color: colorScheme.primary.withValues(alpha: 0.85),
                fontSize: 10,
                height: 1.3,
              ),
            ),
          ],
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 6,
              backgroundColor: colorScheme.secondary.withValues(alpha: 0.35),
              color: _isComplete ? colorScheme.primary : starColor,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_formatCount(achievement.value)} / ${_formatCount(achievement.target)}',
                  style: TextStyle(
                    fontFamily: AppFonts.light,
                    color: Colors.grey.shade700,
                    fontSize: 10,
                  ),
                ),
              ),
              if (showVillage)
                Text(
                  achievement.village == 'home'
                      ? context.l10n.compareGroupTownHall
                      : context.l10n.compareGroupBuilder,
                  style: TextStyle(
                    fontFamily: AppFonts.light,
                    color: Colors.grey.shade500,
                    fontSize: 9,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

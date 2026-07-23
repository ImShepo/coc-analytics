import 'package:coc/domain/entities/player.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/l10n/category_unit_l10n.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/models/category_unit.dart';
import 'package:coc/presentation/routes/unit_detail_route.dart';
import 'package:coc/presentation/widgets/categories/unit_hero_image.dart';
import 'package:flutter/material.dart';

class CategoryUnitCard extends StatelessWidget {
  final CategoryUnit unit;
  final Player player;

  const CategoryUnitCard({super.key, required this.unit, required this.player});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => openUnitDetail(context, unit, player: player),
          borderRadius: BorderRadius.circular(16),
          child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: !unit.isUnlocked
                  ? Colors.grey.shade300
                  : unit.isMaxed
                      ? const Color(0xFFC9A227).withValues(alpha: 0.45)
                      : Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Opacity(
            opacity: unit.isUnlocked ? 1 : 0.55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = (constraints.maxWidth < constraints.maxHeight
                              ? constraints.maxWidth
                              : constraints.maxHeight) -
                          12;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Center(
                            child: UnitHeroImage(
                              unit: unit,
                              player: player,
                              size: size.clamp(0, double.infinity),
                              performanceMode: true,
                              backgroundColor:
                                  colorScheme.secondary.withValues(alpha: 0.18),
                            ),
                          ),
                          if (unit.superTroopIsActive)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6B2D8B),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  l10n.superTroopActiveBadge,
                                  style: const TextStyle(
                                    fontFamily: AppFonts.primary,
                                    color: Colors.white,
                                    fontSize: 7,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        unit.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFonts.primary,
                          color: colorScheme.onPrimary,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: unit.isMaxed
                              ? const Color(0xFFC9A227).withValues(alpha: 0.18)
                              : colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          unit.levelLabelForL10n(player, l10n),
                          style: TextStyle(
                            fontFamily: AppFonts.light,
                            color: unit.isUnlocked
                                ? (unit.isMaxed
                                    ? const Color(0xFF9A7B0A)
                                    : colorScheme.primary)
                                : Colors.grey.shade600,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}

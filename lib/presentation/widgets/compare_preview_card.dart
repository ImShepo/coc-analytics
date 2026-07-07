import 'package:coc/config/helpers/coc_unit_image.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:coc/presentation/widgets/categories/coc_unit_image_widget.dart';
import 'package:flutter/material.dart';

class ComparePreviewCard extends StatelessWidget {
  final Player player;

  const ComparePreviewCard({super.key, required this.player});

  static const _labelShadows = AppFonts.onDarkSurfaceOutline;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.38),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.compareTitle,
                    style: const TextStyle(
                      fontFamily: AppFonts.primary,
                      color: Colors.white,
                      fontSize: 10,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w500,
                      shadows: _labelShadows,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _TroopPortrait(
                        troopName: 'Barbarian',
                        accentColor: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontFamily: AppFonts.primary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    height: 1.1,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: player.name,
                                      style: TextStyle(
                                        color: colorScheme.secondary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: l10n.versusSeparator,
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                    const TextSpan(
                                      text: '?',
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.pickOpponent,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: AppFonts.primary,
                                color: Colors.white,
                                fontSize: 9,
                                letterSpacing: 0.4,
                                shadows: _labelShadows,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _MysteryTroopPortrait(accentColor: const Color(0xFF6B4E71)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                  Text(
                    l10n.comparePreviewSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppFonts.primary,
                      color: Colors.white,
                      fontSize: 8,
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w500,
                      shadows: _labelShadows,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TroopPortrait extends StatelessWidget {
  final String troopName;
  final Color accentColor;

  const _TroopPortrait({
    required this.troopName,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withValues(alpha: 0.55), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CocUnitImageWidget(
          name: troopName,
          category: UnitCategory.troop,
          width: 56,
          height: 56,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _MysteryTroopPortrait extends StatelessWidget {
  final Color accentColor;

  const _MysteryTroopPortrait({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: 0.45,
          child: _TroopPortrait(
            troopName: 'P.E.K.K.A',
            accentColor: accentColor,
          ),
        ),
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white38),
          ),
          alignment: Alignment.center,
          child: const Text(
            '?',
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

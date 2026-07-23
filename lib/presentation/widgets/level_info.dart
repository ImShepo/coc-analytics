import 'package:coc/config/helpers/human_formats.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/widgets/coc_network_image.dart';
import 'package:flutter/material.dart';

class LevelInfo extends StatelessWidget {
  final String title;
  final String imagePath;
  final String levelText;
  final String leagueText;
  final String leagueImagePath;
  final String leagueImageUrl;
  final bool showAsLeague;

  const LevelInfo({
    super.key,
    required this.title,
    required this.imagePath,
    required this.levelText,
    required this.leagueText,
    this.leagueImagePath = '',
    this.leagueImageUrl = '',
    this.showAsLeague = false,
  });

  static TextStyle _labelStyle({
    required double fontSize,
    required double letterSpacing,
  }) {
    return TextStyle(
      fontFamily: AppFonts.primary,
      color: Colors.white,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      fontWeight: FontWeight.w500,
      shadows: AppFonts.onDarkSurfaceOutline,
    );
  }

  bool get _isLeague =>
      showAsLeague || leagueImageUrl.isNotEmpty || leagueImagePath.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLeague = _isLeague;
    final l10n = context.l10n;
    final secondaryLabel = isLeague ? l10n.league : l10n.contributions;
    final secondaryValue = isLeague
        ? leagueText
        : HumanFormats.number(double.tryParse(leagueText) ?? 0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: _labelStyle(fontSize: 10, letterSpacing: 0.8),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imagePath.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imagePath,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.castle_outlined,
                    color: colorScheme.secondary,
                    size: 24,
                  ),
                ),
              const SizedBox(width: 10),
              Text(
                levelText.isNotEmpty ? levelText : secondaryValue,
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  color: colorScheme.secondary,
                  fontSize: 26,
                  height: 1,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colors.white.withValues(alpha: 0.25),
            ),
          ),
          Text(
            secondaryLabel.toUpperCase(),
            style: _labelStyle(fontSize: 9, letterSpacing: 0.6),
          ),
          const SizedBox(height: 4),
          if (isLeague)
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      leagueText,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.primary,
                        color: colorScheme.secondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                if (leagueImageUrl.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  CocNetworkImage(
                    url: leagueImageUrl,
                    width: 28,
                    height: 28,
                    fit: BoxFit.cover,
                    cacheWidth: 56,
                    fadeIn: false,
                    animatedPlaceholder: false,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ] else if (leagueImagePath.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      leagueImagePath,
                      width: 28,
                      height: 28,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/domain/entities/clan.dart';
import 'package:coc/presentation/widgets/coc_network_image.dart';
import 'package:flutter/material.dart';

class ClanHeroHeader extends StatelessWidget {
  final Clan clan;
  final double bottomRadius;

  const ClanHeroHeader({
    super.key,
    required this.clan,
    this.bottomRadius = 28,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(bottomRadius),
      ),
      child: Stack(
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
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.05),
                  Colors.black.withValues(alpha: 0.55),
                  Colors.black.withValues(alpha: 0.82),
                ],
                stops: const [0.0, 0.35, 0.72, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 18,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Hero(
                  tag: 'clan-badge-${clan.tag}',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CocNetworkImage(
                      url: clan.badgeUrls.large,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      cacheWidth: 144,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Text(
                          'LV ${clan.clanLevel}',
                          style: const TextStyle(
                            fontFamily: AppFonts.primary,
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            shadows: AppFonts.onDarkSurfaceOutline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        clan.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: AppFonts.primary,
                          color: Colors.white,
                          fontSize: 22,
                          height: 1.05,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              color: Color(0xCC000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                            Shadow(
                              color: Color(0x66000000),
                              blurRadius: 16,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        clan.tag,
                        style: TextStyle(
                          fontFamily: AppFonts.light,
                          color: colorScheme.secondary,
                          fontSize: 12,
                          letterSpacing: 0.4,
                          shadows: const [
                            Shadow(
                              color: Color(0xAA000000),
                              blurRadius: 6,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/presentation/widgets/coc_network_image.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:flutter/material.dart';

/// Shared chip for clan/player labels (icon + name).
class LabelChip extends StatelessWidget {
  final String name;
  final String iconUrl;

  const LabelChip({
    super.key,
    required this.name,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LiquidGlassSurface(
      borderRadius: BorderRadius.circular(20),
      tintColor: colorScheme.primary,
      tintStrength: 0.22,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconUrl.isNotEmpty) ...[
            CocNetworkImage(
              url: iconUrl,
              width: 16,
              height: 16,
              fit: BoxFit.cover,
              cacheWidth: 32,
              fadeIn: false,
              animatedPlaceholder: false,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            name,
            style: TextStyle(
              fontFamily: AppFonts.primary,
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/presentation/widgets/coc_network_image.dart';
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconUrl.isNotEmpty) ...[
            CocNetworkImage(
              url: iconUrl,
              width: 18,
              height: 18,
              fit: BoxFit.cover,
              cacheWidth: 36,
              fadeIn: false,
              animatedPlaceholder: false,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            name,
            style: TextStyle(
              fontFamily: AppFonts.primary,
              fontSize: 10,
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

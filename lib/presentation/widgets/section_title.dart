import 'package:coc/config/theme/app_fonts.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? buttonText;
  final VoidCallback? onPressed;
  final double topPadding;
  final double bottomPadding;

  const SectionTitle({
    super.key,
    required this.title,
    this.buttonText,
    this.onPressed,
    this.topPadding = 10,
    this.bottomPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final actionColor = onPressed != null
        ? colorScheme.primary
        : colorScheme.primary.withValues(alpha: 0.4);

    return Padding(
      padding: EdgeInsets.fromLTRB(10, topPadding, 10, bottomPadding),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppFonts.sectionTitle(),
          ),
          if (buttonText != null)
            TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: actionColor,
                overlayColor: colorScheme.primary.withValues(alpha: 0.08),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
              ),
              child: Text(
                buttonText!,
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: actionColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

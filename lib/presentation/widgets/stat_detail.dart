import 'package:coc/config/theme/app_fonts.dart';
import 'package:flutter/material.dart';

class StatDetail extends StatelessWidget {
  final String title;
  final String value;

  const StatDetail({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
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
      ),
    );
  }
}

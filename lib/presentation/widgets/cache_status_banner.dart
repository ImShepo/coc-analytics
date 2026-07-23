import 'package:coc/l10n/locale_extensions.dart';
import 'package:flutter/material.dart';

class CacheStatusBanner extends StatelessWidget {
  final bool isRefreshing;
  final bool refreshFailed;
  final DateTime? fetchedAt;

  const CacheStatusBanner({
    super.key,
    required this.isRefreshing,
    required this.refreshFailed,
    this.fetchedAt,
  });

  @override
  Widget build(BuildContext context) {
    if (!isRefreshing && !refreshFailed && fetchedAt == null) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    String message;
    Color background;
    Color foreground;

    if (isRefreshing) {
      message = l10n.dataRefreshing;
      background = colorScheme.secondary.withValues(alpha: 0.35);
      foreground = colorScheme.onPrimary;
    } else if (refreshFailed) {
      message = l10n.dataRefreshFailed;
      background = Colors.orange.shade100;
      foreground = Colors.orange.shade900;
    } else if (fetchedAt != null) {
      final minutes =
          DateTime.now().difference(fetchedAt!).inMinutes.clamp(0, 9999);
      message = minutes < 1
          ? l10n.dataUpdatedJustNow
          : l10n.dataUpdatedAgo(minutes);
      background = colorScheme.secondary.withValues(alpha: 0.22);
      foreground = colorScheme.onPrimary.withValues(alpha: 0.85);
    } else {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (isRefreshing) ...[
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foreground,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 11,
                  color: foreground,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

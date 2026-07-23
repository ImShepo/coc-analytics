import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/widgets/account_menu_button.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  final String name;
  final String tag;
  final bool canUnlinkPlayer;

  const Welcome({
    Key? key,
    required this.name,
    required this.tag,
    this.canUnlinkPlayer = false,
  }) : super(key: key);

  /// First word, or first two when the full name has more than one.
  static String shortName(String raw) {
    final parts =
        raw.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return raw.trim();
    if (parts.length == 1) return parts.first;
    return '${parts[0]} ${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayName = shortName(name);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(15, 20, 15, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: context.l10n.welcomeGreeting,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 0,
                        ),
                      ),
                      TextSpan(
                        text: '$displayName!',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 18,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  tag,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.secondary,
                    fontSize: 10,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          AccountMenuButton(canUnlinkPlayer: canUnlinkPlayer),
        ],
      ),
    );
  }
}

import 'package:coc/l10n/locale_extensions.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  final String name;
  final String tag;

  const Welcome({Key? key, required this.name, required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(15, 20, 15, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    context.l10n.welcomeGreeting,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 0,
                    ),
                  ),
                  Text(
                    '$name!',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 18,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
              Text(
                tag,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: colorScheme.secondary,
                  fontSize: 10,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

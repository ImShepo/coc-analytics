import 'package:coc/presentation/widgets/coc_network_image.dart';
import 'package:flutter/material.dart';

class ClanCard extends StatelessWidget {
  final String clanName;
  final String clanTag;
  final String badgeUrl;

  const ClanCard({
    Key? key,
    required this.clanName,
    required this.clanTag,
    required this.badgeUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clanName,
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 18,
                          letterSpacing: 0,
                        ),
                      ),
                      Text(
                        clanTag,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: colorScheme.secondary,
                          fontSize: 12,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CocNetworkImage(
                        url: badgeUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

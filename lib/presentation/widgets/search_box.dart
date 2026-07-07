import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.80,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.58),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                        child: FaIcon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      Text(
                        context.l10n.searchClanPlaceholder,
                        style: const TextStyle(
                          fontFamily: AppFonts.primary,
                          color: Colors.white,
                          fontSize: 11,
                          letterSpacing: 0.2,
                          shadows: AppFonts.onDarkSurfaceOutline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
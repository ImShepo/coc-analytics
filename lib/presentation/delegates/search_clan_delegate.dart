import 'dart:async';

import 'package:coc/config/helpers/clan_tag.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/domain/entities/clan.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_background.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_background_variant.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_content_scrim.dart';
import 'package:coc/presentation/widgets/coc_network_image.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:flutter/material.dart';

typedef SearchClansCallback = Future<List<Clan>> Function(String query);

class SearchClanDelegate extends SearchDelegate<Clan?> {
  final SearchClansCallback searchClans;
  List<Clan> initialClans;

  final StreamController<List<Clan>> debouncedClans =
      StreamController.broadcast();
  final StreamController<bool> isLoadingStream =
      StreamController.broadcast();

  Timer? _debounceTimer;
  String _lastQuery = '';

  SearchClanDelegate({
    required this.searchClans,
    required this.initialClans,
    required String searchFieldLabel,
  }) : super(
          searchFieldLabel: searchFieldLabel,
          textInputAction: TextInputAction.search,
        ) {
    leadingWidth = 42;
    automaticallyImplyLeading = false;
  }

  void _disposeStreams() {
    _debounceTimer?.cancel();
    if (!debouncedClans.isClosed) debouncedClans.close();
    if (!isLoadingStream.isClosed) isLoadingStream.close();
  }

  @override
  void dispose() {
    _disposeStreams();
    super.dispose();
  }

  @override
  void close(BuildContext context, Clan? result) {
    _disposeStreams();
    super.close(context, result);
  }

  void _onQueryChanged(String query) {
    if (query == _lastQuery) return;
    _lastQuery = query;

    isLoadingStream.add(true);

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final clans = await searchClans(query);
      initialClans = clans;
      if (!debouncedClans.isClosed) {
        debouncedClans.add(clans);
      }
      if (!isLoadingStream.isClosed) {
        isLoadingStream.add(false);
      }
    });
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final borderColor = colorScheme.primary.withValues(alpha: 0.2);
    final focusedBorderColor = colorScheme.primary.withValues(alpha: 0.45);

    return theme.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 8,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.primary,
          fontSize: 12,
          color: colorScheme.onPrimary,
          height: 1.2,
          fontWeight: FontWeight.w500,
        ),
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: TextStyle(
          fontFamily: AppFonts.primary,
          fontSize: 12,
          color: colorScheme.onPrimary,
          height: 1.2,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        hintStyle: TextStyle(
          fontFamily: AppFonts.light,
          fontSize: 12,
          color: Colors.grey.shade400.withValues(alpha: 0.9),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: focusedBorderColor, width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GlassBackLeading(
      onPressed: () => close(context, null),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder<bool>(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          if (query.isEmpty) return const SizedBox(width: 8);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GlassIconButton(
              icon: Icons.close_rounded,
              size: 28,
              iconSize: 16,
              onPressed: () => query = '',
            ),
          );
        },
      ),
    ];
  }

  Widget _screenBackground() {
    return const Stack(
      fit: StackFit.expand,
      children: [
        AppScreenBackground(variant: AppScreenBackgroundVariant.clan),
        AppScreenContentScrim(),
      ],
    );
  }

  Widget _buildResultsBody(BuildContext context) {
    final l10n = context.l10n;

    return Stack(
      fit: StackFit.expand,
      children: [
        _screenBackground(),
        StreamBuilder<bool>(
          initialData: false,
          stream: isLoadingStream.stream,
          builder: (context, loadingSnapshot) {
            final isLoading = loadingSnapshot.data ?? false;

            return StreamBuilder<List<Clan>>(
              initialData: initialClans,
              stream: debouncedClans.stream,
              builder: (context, snapshot) {
                final clans = snapshot.data ?? [];

                if (query.trim().isEmpty) {
                  return _SearchMessage(
                    icon: Icons.groups_rounded,
                    message: l10n.searchClanQueryHint,
                  );
                }

                if (isLoading && clans.isEmpty) {
                  return const Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  );
                }

                if (!isLoading && clans.isEmpty) {
                  return _SearchMessage(
                    icon: Icons.search_off_rounded,
                    message: l10n.searchClanNoResults,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                  itemCount: clans.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => _ClanItem(
                    clan: clans[index],
                    onClanSelected: (ctx, clan) => close(ctx, clan),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _onQueryChanged(query);
    return _buildResultsBody(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return _buildResultsBody(context);
  }
}

class _SearchMessage extends StatelessWidget {
  final IconData icon;
  final String message;

  const _SearchMessage({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 36,
              color: colorScheme.primary.withValues(alpha: 0.45),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppFonts.scrimBody(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClanItem extends StatelessWidget {
  final Clan clan;
  final void Function(BuildContext context, Clan clan) onClanSelected;

  const _ClanItem({
    required this.clan,
    required this.onClanSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayTag = normalizeClanTag(clan.tag);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onClanSelected(context, clan),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: CocNetworkImage(
                  url: clan.badgeUrls.large,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  cacheWidth: 112,
                  filterQuality: FilterQuality.low,
                  animatedPlaceholder: false,
                  fadeIn: false,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clan.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppFonts.primary,
                        color: colorScheme.onPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      displayTag,
                      style: AppFonts.cardLabel(fontSize: 10),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: colorScheme.primary.withValues(alpha: 0.55),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

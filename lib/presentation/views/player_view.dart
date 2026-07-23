import 'package:coc/config/helpers/player_tag.dart';
import 'package:coc/config/helpers/clan_tag.dart';
import 'package:coc/config/helpers/errors.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/providers/auth/auth_provider.dart';
import 'package:coc/presentation/widgets/floating_language_fab.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:coc/presentation/providers/players/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:coc/presentation/delegates/search_clan_delegate.dart';
import 'package:coc/presentation/providers/search/search_clans_provider.dart';
import 'package:coc/presentation/screens/clan_screen.dart';
import 'package:coc/presentation/screens/compare_screen.dart';
import 'package:coc/presentation/screens/stats_screen.dart';
import 'package:coc/presentation/widgets/categories_list.dart';
import 'package:coc/presentation/widgets/clan_card.dart';
import 'package:coc/presentation/widgets/custom_card.dart';
import 'package:coc/presentation/widgets/search_box.dart';
import 'package:coc/presentation/widgets/section_title.dart';
import 'package:coc/presentation/widgets/compare_preview_card.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_background_variant.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_stack.dart';
import 'package:coc/presentation/widgets/stats_carousel.dart';
import 'package:coc/presentation/widgets/welcome.dart';
import 'package:coc/infrastructure/cache/cache_policy.dart';
import 'package:coc/presentation/widgets/cache_status_banner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerView extends ConsumerStatefulWidget {
  static const name = 'player-screen';

  /// Null/empty = Inicio without a linked Clash player.
  final String? playerId;

  const PlayerView({super.key, this.playerId});

  @override
  PlayerViewState createState() => PlayerViewState();
}

class PlayerViewState extends ConsumerState<PlayerView>
    with WidgetsBindingObserver {
  bool get _isGuest {
    final id = widget.playerId;
    return id == null || id.isEmpty;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!_isGuest) {
      Future.microtask(
        () => ref.read(playerProvider.notifier).loadPlayer(widget.playerId!),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || _isGuest) return;
    final playerId = normalizePlayerTag(widget.playerId!);
    final session = ref.read(playerProvider);
    final meta = session.metaByTag[playerId];
    final fetchedAt = meta?.fetchedAt;
    final shouldRefresh = fetchedAt == null ||
        DateTime.now().difference(fetchedAt) > CachePolicy.resumeRefreshAfter;
    if (shouldRefresh) {
      ref.read(playerProvider.notifier).loadPlayer(playerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isGuest) {
      return const _GuestHomeContent();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final playerId = normalizePlayerTag(widget.playerId!);
    final session = ref.watch(playerProvider);
    final playerAsync = session.byTag[playerId];
    final playerMeta = session.metaByTag[playerId] ?? PlayerLoadMeta.empty;

    if (playerAsync == null) {
      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: AppScreenStack(
                variant: AppScreenBackgroundVariant.home,
                primary: colorScheme.onPrimary,
                secondary: colorScheme.secondary,
                child: const SizedBox.shrink(),
              ),
            ),
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ],
        ),
      );
    }

    return playerAsync.when(
      loading: () => Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: AppScreenStack(
                variant: AppScreenBackgroundVariant.home,
                primary: colorScheme.onPrimary,
                secondary: colorScheme.secondary,
                child: const SizedBox.shrink(),
              ),
            ),
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ],
        ),
      ),
      error: (error, _) {
        final l10n = context.l10n;
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: AppScreenStack(
                  variant: AppScreenBackgroundVariant.home,
                  primary: colorScheme.onPrimary,
                  secondary: colorScheme.secondary,
                  child: const SizedBox.shrink(),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        localizedApiError(error, l10n),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (isApiForbidden(error)) ...[
                        const SizedBox(height: 8),
                        Text(
                          l10n.playerErrorForbiddenHint,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                      const SizedBox(height: 24),
                      GlassButton(
                        label: l10n.retry,
                        onPressed: () {
                          ref
                              .read(playerProvider.notifier)
                              .loadPlayer(playerId, force: true);
                        },
                        style: GlassButtonStyle.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      data: (player) => _PlayerContent(
        player: player,
        playerId: playerId,
        loadMeta: playerMeta,
      ),
    );
  }
}

/// Same Inicio shell as the linked home, with empty-state placeholders.
class _GuestHomeContent extends ConsumerStatefulWidget {
  const _GuestHomeContent();

  @override
  ConsumerState<_GuestHomeContent> createState() => _GuestHomeContentState();
}

class _GuestHomeContentState extends ConsumerState<_GuestHomeContent> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openClanSearch() {
    final l10n = context.l10n;

    openClanSearch(
      context,
      searchFieldLabel: l10n.searchClanQueryHint,
      initialClans: ref.read(searchedClansProvider),
      query: ref.read(searchQueryProvider),
      searchClans: ref.read(searchedClansProvider.notifier).searchClansByQuery,
    ).then((clan) {
      if (clan == null || !mounted) return;
      context.push('/clan/${clanTagToApiPath(clan.tag)}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(authStateProvider).valueOrNull;
    final displayName = (user?.displayName?.trim().isNotEmpty ?? false)
        ? user!.displayName!.trim()
        : (user?.email?.split('@').first ?? '—');

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: AppScreenStack(
            variant: AppScreenBackgroundVariant.home,
            primary: colorScheme.onPrimary,
            secondary: colorScheme.secondary,
            child: const SizedBox.shrink(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: ListView(
            controller: _scrollController,
            key: const PageStorageKey<String>('player-scroll-guest'),
            children: [
              CustomCard(
                backgroundImage: 'assets/images/ClashOfClans.jpeg',
                height: 170,
                content: Column(
                  children: [
                    Welcome(
                      name: displayName,
                      tag: l10n.guestHomeUnlinkedTag,
                      canUnlinkPlayer: false,
                    ),
                    GestureDetector(
                      onTap: _openClanSearch,
                      child: const SearchBox(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: GlassButton(
                  label: l10n.guestHomeLinkCta,
                  onPressed: () => context.push('/link-player'),
                  style: GlassButtonStyle.primary,
                ),
              ),
              SectionTitle(title: l10n.yourStats),
              _GuestSectionCard(message: l10n.guestHomeStatsHint),
              SectionTitle(title: l10n.compare),
              _GuestSectionCard(message: l10n.guestHomeCompareHint),
              SectionTitle(title: l10n.yourClan),
              _GuestSectionCard(message: l10n.guestHomeClanHint),
              const SizedBox(height: 10),
              SectionTitle(
                title: l10n.categories,
                bottomPadding: 14,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  l10n.guestHomeCategoriesHint,
                  style: AppFonts.scrimCaption(fontSize: 11),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        FloatingLanguageFab(scrollController: _scrollController),
      ],
    );
  }
}

class _GuestSectionCard extends StatelessWidget {
  final String message;

  const _GuestSectionCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      backgroundImage: 'assets/images/COC.jpeg',
      height: 120,
      opacity: 0.62,
      content: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayerContent extends ConsumerStatefulWidget {
  final Player player;
  final String playerId;
  final PlayerLoadMeta loadMeta;

  const _PlayerContent({
    required this.player,
    required this.playerId,
    required this.loadMeta,
  });

  @override
  ConsumerState<_PlayerContent> createState() => _PlayerContentState();
}

class _PlayerContentState extends ConsumerState<_PlayerContent> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openClanSearch() {
    final l10n = context.l10n;

    openClanSearch(
      context,
      searchFieldLabel: l10n.searchClanQueryHint,
      initialClans: ref.read(searchedClansProvider),
      query: ref.read(searchQueryProvider),
      searchClans: ref.read(searchedClansProvider.notifier).searchClansByQuery,
    ).then((clan) {
      if (clan == null || !mounted) return;
      context.push('/clan/${clanTagToApiPath(clan.tag)}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final player = widget.player;
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: AppScreenStack(
            variant: AppScreenBackgroundVariant.home,
            primary: colorScheme.onPrimary,
            secondary: colorScheme.secondary,
            child: const SizedBox.shrink(),
          ),
        ),
        RefreshIndicator(
          onRefresh: () => ref
              .read(playerProvider.notifier)
              .loadPlayer(widget.playerId, force: true),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ListView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              key: PageStorageKey<String>('player-scroll-${player.tag}'),
              children: [
                CacheStatusBanner(
                  isRefreshing: widget.loadMeta.isRefreshing,
                  refreshFailed: widget.loadMeta.refreshFailed,
                  fetchedAt: widget.loadMeta.fetchedAt,
                ),
              CustomCard(
                  backgroundImage: 'assets/images/ClashOfClans.jpeg',
                  height: 170,
                  content: Column(
                    children: [
                      Welcome(
                        name: player.name,
                        tag: player.tag,
                        canUnlinkPlayer: true,
                      ),
                      GestureDetector(
                        onTap: _openClanSearch,
                        child: const SearchBox(),
                      ),
                    ],
                  )),
                  SectionTitle(
                    title: l10n.yourStats,
                    buttonText: l10n.seeAll,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StatsScreen(player: player),
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StatsScreen(player: player),
                        ),
                      );
                    },
                    child: CustomCard(
                      backgroundImage: 'assets/images/COC.jpeg',
                      height: 220,
                      opacity: 0.62,
                      content: StatsCarousel(player: player),
                    ),
                  ),
                  SectionTitle(
                    title: l10n.compare,
                    buttonText: l10n.open,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompareScreen(me: player),
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompareScreen(me: player),
                        ),
                      );
                    },
                    child: CustomCard(
                      backgroundImage: 'assets/images/COC.jpeg',
                      height: 180,
                      opacity: 0.62,
                      content: ComparePreviewCard(player: player),
                    ),
                  ),
                  SectionTitle(
                    title: l10n.yourClan,
                    buttonText: l10n.seeMore,
                    onPressed: player.clan.tag.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ClanScreen(
                                        clanId: normalizeClanTag(player.clan.tag),
                                        viewerPlayer: player,
                                      )),
                            );
                          },
                  ),
                  if (player.clan.tag.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ClanScreen(
                                    clanId: normalizeClanTag(player.clan.tag),
                                    viewerPlayer: player,
                                  )),
                        );
                      },
                      child: CustomCard(
                        backgroundImage: 'assets/images/COC.jpeg',
                        height: 100,
                        content: ClanCard(
                          clanName: player.clan.name,
                          clanTag: player.clan.tag,
                          badgeUrl: player.clan.badgeUrls.medium.isNotEmpty
                              ? player.clan.badgeUrls.medium
                              : player.clan.badgeUrls.large,
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        l10n.playerNotInClan,
                        style: AppFonts.scrimCaption(fontSize: 11),
                      ),
                    ),
                  const SizedBox(height: 10),
                  SectionTitle(
                    title: l10n.categories,
                    bottomPadding: 14,
                  ),
                  CategoriesList(player: player),
                ],
            ),
          ),
        ),
        FloatingLanguageFab(scrollController: _scrollController),
      ],
    );
  }
}

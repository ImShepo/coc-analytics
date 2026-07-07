import 'package:coc/config/helpers/clan_tag.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/widgets/floating_language_fab.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:coc/presentation/providers/players/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:coc/domain/entities/clan.dart' as coc;
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
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerView extends ConsumerStatefulWidget {
  static const name = 'player-screen';

  final String playerId;

  const PlayerView({super.key, required this.playerId});

  @override
  PlayerViewState createState() => PlayerViewState();
}

class PlayerViewState extends ConsumerState<PlayerView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(playerProvider.notifier).loadPlayer(widget.playerId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final playerAsync = ref.watch(
      playerProvider.select((players) => players[widget.playerId]),
    );

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
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.playerErrorForbiddenHint,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      GlassButton(
                        label: l10n.retry,
                        onPressed: () {
                          ref
                              .read(playerProvider.notifier)
                              .loadPlayer(widget.playerId);
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
      data: (player) => _PlayerContent(player: player),
    );
  }
}

class _PlayerContent extends ConsumerStatefulWidget {
  final Player player;

  const _PlayerContent({required this.player});

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
        Padding(
          padding: const EdgeInsets.all(5),
          child: ListView(
            controller: _scrollController,
            key: PageStorageKey<String>('player-scroll-${player.tag}'),
            children: [
              CustomCard(
                  backgroundImage: 'assets/images/ClashOfClans.jpeg',
                  height: 170,
                  content: Column(
                    children: [
                      Welcome(name: player.name, tag: player.tag),
                      GestureDetector(
                        onTap: () {
                          final searchedClans = ref.read(searchedClansProvider);
                          final searchQuery = ref.read(searchQueryProvider);

                          showSearch<coc.Clan?>(
                            query: searchQuery,
                            context: context,
                            delegate: SearchClanDelegate(
                              initialClans: searchedClans,
                              searchFieldLabel: l10n.searchClanQueryHint,
                              searchClans: ref
                                  .read(searchedClansProvider.notifier)
                                  .searchClansByQuery,
                            ),
                          ).then((clan) {
                            if (clan == null) return;

                            context.push('/clan/${clanTagToApiPath(clan.tag)}');
                          });
                        },
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
                          badgeUrl:
                              'https://api-assets.clashofclans.com/badges/200/NY0o6PJd_9-c7_exrzE3XexRyAbEDcRh_dvbwdNnU3s.png',
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
        FloatingLanguageFab(scrollController: _scrollController),
      ],
    );
  }
}

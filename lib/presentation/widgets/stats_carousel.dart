import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:flutter/material.dart';
import 'level_info.dart';

class StatsCarousel extends StatefulWidget {
  final Player player;

  const StatsCarousel({super.key, required this.player});

  @override
  StatsCarouselState createState() => StatsCarouselState();
}

class StatsCarouselState extends State<StatsCarousel> {
  static const _pageCount = 3;
  static const _duration = Duration(milliseconds: 320);

  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.82);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _townHallAsset(int level) {
    final assetLevel = level.clamp(1, 16);
    return 'assets/images/townhall/TownHall$assetLevel.png';
  }

  _StatSlide _slideForIndex(int index, BuildContext context) {
    final player = widget.player;
    final l10n = context.l10n;
    final weaponSuffix =
        player.townHallWeaponLevel > 0 ? ' (${player.townHallWeaponLevel})' : '';

    switch (index) {
      case 0:
        return _StatSlide(
          title: l10n.levelTownHall,
          imagePath: _townHallAsset(player.townHallLevel),
          levelText: '${player.townHallLevel}$weaponSuffix',
          leagueText: player.league.name,
          leagueImagePath: 'assets/images/Titan_League.png',
        );
      case 1:
        return _StatSlide(
          title: l10n.levelBuilderHall,
          imagePath: _townHallAsset(player.builderHallLevel),
          levelText: '${player.builderHallLevel}',
          leagueText: player.builderBaseLeague.name,
          leagueImagePath: 'assets/images/Builder_Base_Platinum_League_2.png',
        );
      default:
        return _StatSlide(
          title: l10n.levelClanCapital,
          imagePath: '',
          levelText: '',
          leagueText: '${player.clanCapitalContributions}',
          leagueImagePath: '',
        );
    }
  }

  double get _page =>
      _controller.hasClients ? (_controller.page ?? 0.0) : 0.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final page = _page;
        final currentIndex = page.round().clamp(0, _pageCount - 1);

        return LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 148,
                    child: PageView.builder(
                      controller: _controller,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      itemCount: _pageCount,
                      itemBuilder: (context, index) {
                        final slide = _slideForIndex(index, context);
                        final delta = (page - index).abs();
                        final scale = (1 - delta * 0.08).clamp(0.92, 1.0);
                        final opacity = (1 - delta * 0.35).clamp(0.6, 1.0);

                        return Center(
                          child: Transform.scale(
                            scale: scale,
                            child: Opacity(
                              opacity: opacity,
                              child: LevelInfo(
                                title: slide.title,
                                imagePath: slide.imagePath,
                                levelText: slide.levelText,
                                leagueText: slide.leagueText,
                                leagueImagePath: slide.leagueImagePath,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pageCount, (index) {
                      final isActive = currentIndex == index;
                      final proximity =
                          (1 - (page - index).abs()).clamp(0.0, 1.0);

                      return AnimatedContainer(
                        duration: _duration,
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 22 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Color.lerp(
                            Colors.grey.shade400,
                            colorScheme.primary,
                            isActive ? 1.0 : proximity * 0.5,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _StatSlide {
  final String title;
  final String imagePath;
  final String levelText;
  final String leagueText;
  final String leagueImagePath;

  const _StatSlide({
    required this.title,
    required this.imagePath,
    required this.levelText,
    required this.leagueText,
    required this.leagueImagePath,
  });
}

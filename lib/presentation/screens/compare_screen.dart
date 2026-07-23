import 'package:coc/config/helpers/clan_tag.dart';
import 'package:coc/config/helpers/errors.dart';
import 'package:coc/config/helpers/player_compare.dart';
import 'package:coc/config/helpers/player_tag.dart';
import 'package:coc/config/helpers/troop_catalog.dart';
import 'package:coc/config/helpers/upper_case_formatter.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/domain/entities/member_list.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:coc/l10n/app_localizations.dart';
import 'package:coc/l10n/catalog_l10n.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/providers/clans/clan_info_provider.dart';
import 'package:coc/presentation/providers/players/player_provider.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_stack.dart';
import 'package:coc/presentation/widgets/backgrounds/app_screen_background_variant.dart';
import 'package:coc/presentation/widgets/coc_network_image.dart';
import 'package:coc/presentation/widgets/compare/compare_charts.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:coc/services/recent_compare_tags_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompareScreen extends ConsumerStatefulWidget {
  static const name = 'compare-screen';

  final Player me;
  final String? initialOpponentTag;
  final String? initialOpponentName;

  const CompareScreen({
    super.key,
    required this.me,
    this.initialOpponentTag,
    this.initialOpponentName,
  });

  @override
  ConsumerState<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends ConsumerState<CompareScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _tagController;
  late final FocusNode _tagFocusNode;
  String? _opponentTag;
  String? _opponentName;
  List<RecentCompareTag> _recentTags = const [];
  bool _showRecentPanel = false;
  CompareWinner? _cachedTabWinner;
  int? _cachedTabIndex;
  String? _cachedOpponentTag;

  CompareWinner _resolveTabWinner(int tabIndex, Player opponent) {
    if (_cachedTabWinner != null &&
        _cachedTabIndex == tabIndex &&
        _cachedOpponentTag == opponent.tag) {
      return _cachedTabWinner!;
    }
    final winner = _tabWinnerForIndex(tabIndex, widget.me, opponent);
    _cachedTabWinner = winner;
    _cachedTabIndex = tabIndex;
    _cachedOpponentTag = opponent.tag;
    return winner;
  }

  void _invalidateTabWinnerCache() {
    _cachedTabWinner = null;
    _cachedTabIndex = null;
    _cachedOpponentTag = null;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _tagFocusNode = FocusNode();
    _opponentTag = widget.initialOpponentTag != null
        ? normalizePlayerTag(widget.initialOpponentTag!)
        : null;
    _opponentName = widget.initialOpponentName;
    _tagController = TextEditingController(
      text: _opponentTag != null ? playerTagToDisplay(_opponentTag!) : '',
    );
    _tagFocusNode.addListener(_onSearchFocusChanged);

    Future.microtask(_loadRecentTags);

    if (_opponentTag != null && _opponentTag!.isNotEmpty) {
      Future.microtask(_loadOpponent);
    }

    if (widget.me.clan.tag.isNotEmpty) {
      Future.microtask(
        () => ref
            .read(clanInfoProvider.notifier)
            .loadClan(normalizeClanTag(widget.me.clan.tag)),
      );
    }
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging || !mounted) return;
    setState(() {});
  }

  CompareWinner _tabWinnerForIndex(int index, Player me, Player opponent) {
    return switch (index) {
      0 || 1 => tabWinnerFromMetrics(buildCompareMetrics(me, opponent)),
      2 => tabWinnerFromAchievements(me, opponent),
      3 => tabWinnerFromUnits(me, opponent),
      _ => CompareWinner.tie,
    };
  }

  @override
  void dispose() {
    _tagFocusNode.removeListener(_onSearchFocusChanged);
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _tagController.dispose();
    _tagFocusNode.dispose();
    super.dispose();
  }

  List<RecentCompareTag> _filteredRecentTagsFor(String rawQuery) {
    final myTag = normalizePlayerTag(widget.me.tag);
    final query = normalizePlayerTag(rawQuery);
    final base = _recentTags.where((e) => e.tag != myTag);
    if (query.isEmpty) return base.toList();
    return base
        .where((e) {
          final tagHit = e.tag.contains(query);
          final nameHit =
              e.name?.toUpperCase().contains(query.toUpperCase()) ?? false;
          return tagHit || nameHit;
        })
        .toList();
  }

  void _onSearchFocusChanged() {
    if (_tagFocusNode.hasFocus) {
      setState(() => _showRecentPanel = true);
    }
  }

  void _dismissTagSearch() {
    final hadFocus = _tagFocusNode.hasFocus;
    final panelOpen = _showRecentPanel;
    if (!hadFocus && !panelOpen) return;
    _tagFocusNode.unfocus();
    setState(() => _showRecentPanel = false);
  }

  void _focusSearch() {
    _tagFocusNode.requestFocus();
    setState(() => _showRecentPanel = true);
  }

  Future<void> _loadRecentTags() async {
    final entries = await RecentCompareTagsStore.load();
    if (!mounted) return;
    setState(() => _recentTags = entries);
  }

  Future<void> _rememberRecentTag(String tag, {String? name}) async {
    final myTag = normalizePlayerTag(widget.me.tag);
    final normalized = normalizePlayerTag(tag);
    if (normalized.isEmpty || normalized == myTag) return;
    final entries = await RecentCompareTagsStore.remember(
      normalized,
      name: name,
    );
    if (!mounted) return;
    setState(() => _recentTags = entries);
  }

  Future<void> _removeRecentTag(String tag) async {
    final entries = await RecentCompareTagsStore.remove(tag);
    if (!mounted) return;
    setState(() => _recentTags = entries);
  }

  Future<void> _clearRecentTags() async {
    final entries = await RecentCompareTagsStore.clear();
    if (!mounted) return;
    setState(() => _recentTags = entries);
  }

  void _selectRecentTag(RecentCompareTag entry) {
    _tagController.text = entry.displayTag;
    setState(() => _opponentName = entry.name);
    _loadOpponent();
  }

  void _selectClanMate(MemberList member) {
    final tag = normalizePlayerTag(member.tag);
    if (tag == _opponentTag) return;
    _tagController.text = playerTagToDisplay(member.tag);
    setState(() => _opponentName = member.name);
    _rememberRecentTag(tag, name: member.name);
    _loadOpponent();
  }

  void _resetOpponent() {
    setState(() {
      _opponentTag = null;
      _opponentName = null;
      _tagController.clear();
    });
    _invalidateTabWinnerCache();
    _tagFocusNode.requestFocus();
  }

  Future<void> _openOpponentPicker({
    required List<MemberList> clanMates,
    required bool clanLoading,
  }) async {
    FocusScope.of(context).unfocus();
    setState(() => _showRecentPanel = false);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _OpponentPickerSheet(
        controller: _tagController,
        clanMates: clanMates,
        clanLoading: clanLoading,
        currentOpponentTag: _opponentTag,
        onSelectClanMate: (member) {
          Navigator.pop(sheetContext);
          _selectClanMate(member);
        },
        onSearch: () {
          Navigator.pop(sheetContext);
          _loadOpponent();
        },
      ),
    );
  }

  void _loadOpponent() {
    final tag = normalizePlayerTag(_tagController.text);
    if (tag.isEmpty) return;
    if (tag == normalizePlayerTag(widget.me.tag)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.compareSelfError)),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    if (_tabController.index != 0) {
      _tabController.animateTo(0);
    }
    setState(() {
      _opponentTag = tag;
      _opponentName = null;
      _showRecentPanel = false;
    });
    _invalidateTabWinnerCache();
    ref.read(playerProvider.notifier).loadPlayer(tag, force: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final youColor = colorScheme.primary;
    // Rival purple tuned for white cards + white text on dark app bar.
    const themColor = Color(0xFF7A5688);
    const themDark = Color(0xFF3D2A48);
    const themSoft = Color(0xFFE9D8F0);

    final opponentAsync = _opponentTag == null
        ? null
        : ref.watch(playerProvider.select((m) => m.byTag[_opponentTag!]));

    final opponent = opponentAsync?.valueOrNull;
    final hasComparison = opponent != null;

    final tabIndex = _tabController.indexIsChanging
        ? _tabController.previousIndex
        : _tabController.index;

    final tabWinner = hasComparison
        ? _resolveTabWinner(tabIndex, opponent)
        : CompareWinner.tie;
    final moodAccent = switch (tabWinner) {
      CompareWinner.you => youColor,
      CompareWinner.them => themColor,
      CompareWinner.tie => Color.lerp(youColor, themColor, 0.5)!,
    };
    final moodDark = switch (tabWinner) {
      CompareWinner.you => colorScheme.onPrimary,
      CompareWinner.them => themDark,
      CompareWinner.tie =>
        Color.lerp(colorScheme.onPrimary, themDark, 0.5)!,
    };
    final moodSoft = switch (tabWinner) {
      CompareWinner.you => colorScheme.secondary,
      CompareWinner.them => themSoft,
      CompareWinner.tie => Color.lerp(colorScheme.secondary, themSoft, 0.5)!,
    };

    // Load the rival's clan when the compared player is ready.
    ref.listen(
      playerProvider.select(
        (m) => _opponentTag == null ? null : m.byTag[_opponentTag!],
      ),
      (previous, next) {
        final player = next?.valueOrNull;
        if (player != null) {
          final tag = normalizePlayerTag(player.tag);
          if (tag == _opponentTag) {
            _rememberRecentTag(tag, name: player.name);
          }
        }
        final clanTag = player?.clan.tag;
        if (clanTag != null && clanTag.isNotEmpty) {
          ref.read(clanInfoProvider.notifier).loadClan(clanTag);
        }
      },
    );

    // My clan mates — used to pick an opponent before / from the sheet.
    final myClanCacheKey = widget.me.clan.tag.isEmpty
        ? null
        : normalizeClanTag(widget.me.clan.tag);
    final myClan = myClanCacheKey == null
        ? null
        : ref.watch(clanInfoProvider.select((m) => m.byTag[myClanCacheKey]));
    final myClanMates = myClan?.memberList
            .where(
              (m) =>
                  normalizePlayerTag(m.tag) !=
                  normalizePlayerTag(widget.me.tag),
            )
            .toList() ??
        const <MemberList>[];

    // Rival clan mates — quick switch only when the compared player has a clan.
    final rivalClanCacheKey = (opponent == null || opponent.clan.tag.isEmpty)
        ? null
        : normalizeClanTag(opponent.clan.tag);
    final rivalClan = rivalClanCacheKey == null
        ? null
        : ref.watch(clanInfoProvider.select((m) => m.byTag[rivalClanCacheKey]));
    if (rivalClanCacheKey != null && rivalClan == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(clanInfoProvider.notifier).loadClan(rivalClanCacheKey);
      });
    }
    final rivalClanMates = rivalClan == null || opponent == null
        ? const <MemberList>[]
        : rivalClan.memberList
            .where(
              (m) =>
                  normalizePlayerTag(m.tag) !=
                      normalizePlayerTag(opponent.tag) &&
                  normalizePlayerTag(m.tag) !=
                      normalizePlayerTag(widget.me.tag),
            )
            .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppScreenStack(
        variant: AppScreenBackgroundVariant.compare,
        primary: hasComparison ? youColor : null,
        secondary: hasComparison ? themColor : null,
        mood: hasComparison ? moodSoft : null,
        child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 210,
            pinned: true,
            backgroundColor: hasComparison ? moodDark : colorScheme.onPrimary,
            title: Text(
              l10n.compareTitle,
              style: const TextStyle(
                fontFamily: AppFonts.primary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            centerTitle: false,
            leadingWidth: 42,
            leading: const GlassBackLeading(),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/COC.jpeg', fit: BoxFit.cover),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 380),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          (hasComparison ? moodAccent : colorScheme.primary)
                              .withValues(alpha: 0.42),
                          (hasComparison ? moodDark : colorScheme.onPrimary)
                              .withValues(alpha: 0.92),
                        ],
                      ),
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final settings = context
                          .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
                      final toolbarOpacity = settings?.toolbarOpacity ?? 0.0;
                      final contentOpacity =
                          (1 - toolbarOpacity * 1.4).clamp(0.0, 1.0);

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          SafeArea(
                            child: Align(
                              alignment: const Alignment(0, -0.82),
                              child: Opacity(
                                opacity: contentOpacity,
                                child: Text(
                                  l10n.compareTitle,
                                  style: const TextStyle(
                                    fontFamily: AppFonts.light,
                                    color: Colors.white70,
                                    fontSize: 10,
                                    letterSpacing: 1.6,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 56, 16, 56),
                              child: Opacity(
                                opacity: contentOpacity,
                                child: _DuelHeader(
                                  me: widget.me,
                                  opponentName: _opponentName ??
                                      opponentAsync?.valueOrNull?.name ??
                                      l10n.opponentDefaultName,
                                  opponentLeagueIcon: opponentAsync
                                          ?.valueOrNull?.league.iconUrls.medium ??
                                      '',
                                  youColor: youColor,
                                  themColor: themColor,
                                  onOpponentTap: _opponentTag != null
                                      ? () => _openOpponentPicker(
                                            clanMates: myClanMates,
                                            clanLoading: myClanCacheKey != null &&
                                                myClan == null,
                                          )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            bottom: hasComparison
                ? TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white60,
                    labelStyle: const TextStyle(
                      fontFamily: AppFonts.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontFamily: AppFonts.light,
                      fontSize: 11,
                    ),
                    tabs: [
                      Tab(text: l10n.compareTabSummary),
                      Tab(text: l10n.compareTabStats),
                      Tab(text: l10n.compareTabAchievements),
                      Tab(text: l10n.compareTabTroops),
                    ],
                  )
                : null,
          ),
        ],
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TapRegion(
                onTapOutside: (_) => _dismissTagSearch(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _OpponentSearchBar(
                      controller: _tagController,
                      focusNode: _tagFocusNode,
                      onSearch: _loadOpponent,
                      onTapBar: _focusSearch,
                      onClear: _opponentTag != null ? _resetOpponent : null,
                    ),
                    if (_showRecentPanel && _recentTags.isNotEmpty)
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _tagController,
                        builder: (context, value, _) {
                          return _RecentCompareTagsPanel(
                            entries: _filteredRecentTagsFor(value.text),
                            hasAnyHistory: _recentTags.isNotEmpty,
                            onSelect: _selectRecentTag,
                            onRemove: _removeRecentTag,
                            onClearAll: _clearRecentTags,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            opponentAsync?.valueOrNull != null
                ? _OpponentSwitcherBar(
                    opponent: opponent!,
                    clanMates: rivalClanMates,
                    currentOpponentTag: _opponentTag,
                    onChangeOpponent: () => _openOpponentPicker(
                      clanMates: myClanMates,
                      clanLoading: myClanCacheKey != null && myClan == null,
                    ),
                    onSelectClanMate: _selectClanMate,
                  )
                : const SizedBox.shrink(),
            Expanded(
              child: opponentAsync == null
                  ? _ComparePickOpponentPanel(
                      me: widget.me,
                      clanMates: myClanMates,
                      clanLoading: myClanCacheKey != null && myClan == null,
                      onFocusSearch: _focusSearch,
                      onSelectClanMate: _selectClanMate,
                      l10n: l10n,
                    )
                  : opponentAsync.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      error: (error, _) => _CompareError(
                        message: localizedApiError(
                          apiExceptionFromObject(error),
                          l10n,
                        ),
                        onRetry: _loadOpponent,
                        isNotFound: isApiNotFound(error),
                      ),
                      data: (opponent) => TabBarView(
                        controller: _tabController,
                        children: [
                          _SummaryTab(
                            me: widget.me,
                            opponent: opponent,
                            youColor: youColor,
                            themColor: themColor,
                            moodDark: moodDark,
                          ),
                          _StatsTab(
                            me: widget.me,
                            opponent: opponent,
                            youColor: youColor,
                            themColor: themColor,
                          ),
                          _AchievementsTab(
                            me: widget.me,
                            opponent: opponent,
                            youColor: youColor,
                            themColor: themColor,
                          ),
                          _TroopsTab(
                            me: widget.me,
                            opponent: opponent,
                            youColor: youColor,
                            themColor: themColor,
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _DuelHeader extends StatelessWidget {
  final Player me;
  final String opponentName;
  final String opponentLeagueIcon;
  final Color youColor;
  final Color themColor;
  final VoidCallback? onOpponentTap;

  const _DuelHeader({
    required this.me,
    required this.opponentName,
    required this.opponentLeagueIcon,
    required this.youColor,
    required this.themColor,
    this.onOpponentTap,
  });

  String get _meLeague => me.league.iconUrls.medium.isEmpty
      ? 'http://clash-wiki.com/images/progress/leagues/no_league.png'
      : me.league.iconUrls.medium;

  String get _themLeague => opponentLeagueIcon.isEmpty
      ? 'http://clash-wiki.com/images/progress/leagues/no_league.png'
      : opponentLeagueIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PlayerChip(
            name: me.name,
            leagueIcon: _meLeague,
            color: youColor,
            alignEnd: false,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white38),
          ),
          child: Text(
            context.l10n.versus,
            style: const TextStyle(
              fontFamily: AppFonts.primary,
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onOpponentTap,
            behavior: HitTestBehavior.opaque,
            child: _PlayerChip(
              name: opponentName,
              leagueIcon: _themLeague,
              color: themColor,
              alignEnd: true,
              showChangeHint: onOpponentTap != null,
            ),
          ),
        ),
      ],
    );
  }
}

class _PlayerChip extends StatelessWidget {
  final String name;
  final String leagueIcon;
  final Color color;
  final bool alignEnd;
  final bool showChangeHint;

  const _PlayerChip({
    required this.name,
    required this.leagueIcon,
    required this.color,
    required this.alignEnd,
    this.showChangeHint = false,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = CocNetworkAvatar(
      radius: 22,
      url: leagueIcon,
      backgroundColor: Colors.white,
    );
    final label = Expanded(
      child: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        style: const TextStyle(
          fontFamily: AppFonts.primary,
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    return Row(
      mainAxisAlignment:
          alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: alignEnd
          ? [
              if (showChangeHint)
                Icon(
                  Icons.swap_horiz_rounded,
                  size: 14,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              if (showChangeHint) const SizedBox(width: 4),
              label,
              const SizedBox(width: 8),
              avatar,
            ]
          : [avatar, const SizedBox(width: 8), label],
    );
  }
}

class _OpponentSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSearch;
  final VoidCallback onTapBar;
  final VoidCallback? onClear;

  const _OpponentSearchBar({
    required this.controller,
    required this.focusNode,
    required this.onSearch,
    required this.onTapBar,
    this.onClear,
  });

  @override
  State<_OpponentSearchBar> createState() => _OpponentSearchBarState();
}

class _OpponentSearchBarState extends State<_OpponentSearchBar> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChanged);
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant _OpponentSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_onFocusChanged);
      widget.focusNode.addListener(_onFocusChanged);
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);
      widget.controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChanged);
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onFocusChanged() => setState(() {});
  void _onTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTapBar,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.focusNode.hasFocus
                  ? colorScheme.primary.withValues(alpha: 0.45)
                  : Colors.transparent,
              width: 1.5,
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
              Icon(Icons.tag_rounded, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  style: const TextStyle(
                    fontFamily: AppFonts.primary,
                    fontSize: 12,
                    color: Color(0xFF3B3B3B),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.opponentTagHint,
                    hintStyle: TextStyle(
                      fontFamily: AppFonts.primary,
                      fontSize: 12,
                      color: Colors.grey.shade400.withValues(alpha: 0.85),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    const UpperCaseTextFormatter(),
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => widget.onSearch(),
                  onTap: widget.onTapBar,
                ),
              ),
              if (widget.controller.text.isNotEmpty && widget.onClear != null)
                GlassIconButton(
                  icon: Icons.close_rounded,
                  iconSize: 18,
                  onPressed: widget.onClear,
                  tooltip: l10n.changeOpponent,
                ),
              GlassTextButton(
                label: l10n.search,
                onPressed: widget.onSearch,
                style: GlassButtonStyle.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentCompareTagsPanel extends StatelessWidget {
  final List<RecentCompareTag> entries;
  final bool hasAnyHistory;
  final void Function(RecentCompareTag entry) onSelect;
  final void Function(String tag) onRemove;
  final VoidCallback onClearAll;

  const _RecentCompareTagsPanel({
    required this.entries,
    required this.hasAnyHistory,
    required this.onSelect,
    required this.onRemove,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      constraints: const BoxConstraints(maxHeight: 220),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 6),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 4, 4),
            child: Row(
              children: [
                Icon(Icons.history_rounded, size: 16, color: colorScheme.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.compareRecentSearches,
                    style: TextStyle(
                      fontFamily: AppFonts.primary,
                      color: colorScheme.onPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (hasAnyHistory)
                  TextButton(
                    onPressed: onClearAll,
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      l10n.compareClearRecent,
                      style: TextStyle(
                        fontFamily: AppFonts.primary,
                        color: colorScheme.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (entries.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
              child: Text(
                l10n.compareNoRecentMatches,
                style: TextStyle(
                  fontFamily: AppFonts.light,
                  color: Colors.grey.shade600,
                  fontSize: 11,
                ),
              ),
            )
          else
            for (var i = 0; i < entries.length; i++) ...[
              if (i > 0)
                Divider(height: 1, color: Colors.grey.shade200),
              ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Icon(
                  Icons.tag_rounded,
                  size: 18,
                  color: colorScheme.primary,
                ),
                title: Text(
                  entries[i].displayTag,
                  style: TextStyle(
                    fontFamily: AppFonts.primary,
                    color: colorScheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: entries[i].name == null
                    ? null
                    : Text(
                        entries[i].name!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppFonts.light,
                          color: Colors.grey.shade600,
                          fontSize: 10,
                        ),
                      ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: Colors.grey.shade500,
                  ),
                  tooltip: l10n.compareClearRecent,
                  onPressed: () => onRemove(entries[i].tag),
                ),
                onTap: () => onSelect(entries[i]),
              ),
            ],
        ],
      ),
    );
  }
}

class _OpponentSwitcherBar extends StatelessWidget {
  final Player opponent;
  final List<MemberList> clanMates;
  final String? currentOpponentTag;
  final VoidCallback onChangeOpponent;
  final void Function(MemberList member) onSelectClanMate;

  const _OpponentSwitcherBar({
    required this.opponent,
    required this.clanMates,
    required this.currentOpponentTag,
    required this.onChangeOpponent,
    required this.onSelectClanMate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final currentTag = normalizePlayerTag(currentOpponentTag ?? '');
    final quickSwitchMates = clanMates
        .where((m) => normalizePlayerTag(m.tag) != currentTag)
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: onChangeOpponent,
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(14),
                bottom: Radius.circular(quickSwitchMates.isEmpty ? 14 : 0),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.currentOpponent,
                            style: AppFonts.cardLabel(fontSize: 10),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            opponent.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppFonts.primary,
                              color: colorScheme.onPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            playerTagToDisplay(opponent.tag),
                            style: AppFonts.cardLabel(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    GlassTextButton(
                      label: l10n.changeOpponent,
                      icon: Icons.swap_horiz_rounded,
                      onPressed: onChangeOpponent,
                      style: GlassButtonStyle.accent,
                    ),
                  ],
                ),
              ),
            ),
            if (quickSwitchMates.isNotEmpty) ...[
              Divider(
                height: 1,
                thickness: 1,
                indent: 12,
                endIndent: 12,
                color: colorScheme.primary.withValues(alpha: 0.12),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.groups_rounded,
                      size: 14,
                      color: colorScheme.primary.withValues(alpha: 0.75),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l10n.compareQuickSwitch,
                        style: AppFonts.cardLabel(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: quickSwitchMates.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final member = quickSwitchMates[index];
                    final leagueIcon = member.league.iconUrls.medium.isEmpty
                        ? 'http://clash-wiki.com/images/progress/leagues/no_league.png'
                        : member.league.iconUrls.medium;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => onSelectClanMate(member),
                          borderRadius: BorderRadius.circular(18),
                          child: LiquidGlassSurface(
                            borderRadius: BorderRadius.circular(18),
                            tintColor: colorScheme.secondary,
                            tintStrength: 0.32,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CocNetworkAvatar(
                                  radius: 10,
                                  url: leagueIcon,
                                  backgroundColor: Colors.grey.shade100,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  member.name,
                                  style: const TextStyle(
                                    fontFamily: AppFonts.light,
                                    fontSize: 11,
                                    color: Color(0xFF3B3B3B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OpponentPickerSheet extends StatefulWidget {
  final TextEditingController controller;
  final List<MemberList> clanMates;
  final bool clanLoading;
  final String? currentOpponentTag;
  final void Function(MemberList member) onSelectClanMate;
  final VoidCallback onSearch;

  const _OpponentPickerSheet({
    required this.controller,
    required this.clanMates,
    required this.clanLoading,
    required this.currentOpponentTag,
    required this.onSelectClanMate,
    required this.onSearch,
  });

  @override
  State<_OpponentPickerSheet> createState() => _OpponentPickerSheetState();
}

class _OpponentPickerSheetState extends State<_OpponentPickerSheet> {
  late final FocusNode _sheetFocusNode;

  @override
  void initState() {
    super.initState();
    _sheetFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _sheetFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final currentTag = normalizePlayerTag(widget.currentOpponentTag ?? '');
    final mates = widget.clanMates
        .where((m) => normalizePlayerTag(m.tag) != currentTag)
        .toList();
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.45,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppScreenBackgroundColors.base,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.changeOpponent,
                          style: TextStyle(
                            fontFamily: AppFonts.primary,
                            color: colorScheme.onPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GlassIconButton(
                        icon: Icons.close_rounded,
                        iconSize: 22,
                        onPressed: () => Navigator.pop(context),
                        style: GlassButtonStyle.ghostOnDark,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _OpponentSearchBar(
                    controller: widget.controller,
                    focusNode: _sheetFocusNode,
                    onSearch: widget.onSearch,
                    onTapBar: () => _sheetFocusNode.requestFocus(),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: widget.clanLoading
                      ? const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : mates.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Text(
                                  l10n.compareEnterTagPrompt,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppFonts.light,
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            )
                          : ListView(
                              controller: scrollController,
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.clanMates,
                                      style: TextStyle(
                                        fontFamily: AppFonts.primary,
                                        color: colorScheme.onPrimary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ...mates.map(
                                  (member) => _ClanMateCompareTile(
                                    member: member,
                                    onTap: () => widget.onSelectClanMate(member),
                                  ),
                                ),
                              ],
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ComparePickOpponentPanel extends StatelessWidget {
  final Player me;
  final List<MemberList> clanMates;
  final bool clanLoading;
  final VoidCallback onFocusSearch;
  final void Function(MemberList member) onSelectClanMate;
  final AppLocalizations l10n;

  const _ComparePickOpponentPanel({
    required this.me,
    required this.clanMates,
    required this.clanLoading,
    required this.onFocusSearch,
    required this.onSelectClanMate,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
          child: Column(
              children: [
                Icon(Icons.edit_outlined, size: 36, color: colorScheme.primary.withValues(alpha: 0.55)),
                const SizedBox(height: 10),
                Text(
                  l10n.compareEnterTagPrompt,
                  textAlign: TextAlign.center,
                  style: AppFonts.scrimBody(),
                ),
                const SizedBox(height: 14),
                Center(
                  child: GlassButton.compact(
                    label: l10n.compare,
                    icon: Icons.search_rounded,
                    onPressed: onFocusSearch,
                    style: GlassButtonStyle.primary,
                  ),
                ),
              ],
            ),
          ),
        if (clanLoading) ...[
          const SizedBox(height: 28),
          const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ] else if (clanMates.isNotEmpty) ...[
          const SizedBox(height: 28),
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.clanMates,
                style: AppFonts.sectionTitle(fontSize: 11),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${clanMates.length}',
                  style: TextStyle(
                    fontFamily: AppFonts.primary,
                    color: colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...clanMates.map(
            (member) => _ClanMateCompareTile(
              member: member,
              onTap: () => onSelectClanMate(member),
            ),
          ),
        ],
        const SizedBox(height: 20),
        Text(
          me.clan.tag.isEmpty
              ? l10n.compareNoClanHint
              : l10n.compareClanMatesHint(me.clan.name),
          textAlign: TextAlign.center,
          style: AppFonts.scrimCaption(),
        ),
      ],
    );
  }
}

class _ClanMateCompareTile extends StatelessWidget {
  final MemberList member;
  final VoidCallback onTap;

  const _ClanMateCompareTile({
    required this.member,
    required this.onTap,
  });

  String get _leagueIcon => member.league.iconUrls.medium.isEmpty
      ? 'http://clash-wiki.com/images/progress/leagues/no_league.png'
      : member.league.iconUrls.medium;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                CocNetworkAvatar(
                  radius: 18,
                  url: _leagueIcon,
                  backgroundColor: Colors.grey.shade100,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppFonts.primary,
                          color: colorScheme.onPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.clanMateSubtitle(
                          playerTagToDisplay(member.tag),
                          member.townHallLevel,
                          member.trophies,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFonts.cardLabel(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.compare_arrows_rounded,
                  size: 20,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompareError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool isNotFound;

  const _CompareError({
    required this.message,
    required this.onRetry,
    this.isNotFound = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isNotFound
                  ? Icons.person_search_rounded
                  : Icons.error_outline,
              color: isNotFound ? colorScheme.primary : Colors.red,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: AppFonts.light, fontSize: 12),
            ),
            const SizedBox(height: 16),
            GlassButton.compact(
              label: context.l10n.retry,
              onPressed: onRetry,
              style: GlassButtonStyle.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTab extends StatelessWidget {
  final Player me;
  final Player opponent;
  final Color youColor;
  final Color themColor;
  final Color moodDark;

  const _SummaryTab({
    required this.me,
    required this.opponent,
    required this.youColor,
    required this.themColor,
    required this.moodDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final metrics = buildCompareMetrics(me, opponent);
    final summary = buildCompareSummary(metrics);
    final radar = buildRadarAxes(me, opponent);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _ScoreBanner(
          summary: summary,
          meName: me.name,
          opponentName: opponent.name,
          youColor: youColor,
          themColor: themColor,
          moodDark: moodDark,
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                l10n.comparativeProfile,
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              CompareRadarChart(
                axes: radar,
                youColor: youColor,
                themColor: themColor,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CompareLegend(
                    youColor: youColor,
                    themColor: themColor,
                    youLabel: me.name,
                    themLabel: opponent.name,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _HighlightsCard(
          metrics: metrics,
          youColor: youColor,
          themColor: themColor,
          youLabel: me.name,
          themLabel: opponent.name,
        ),
      ],
    );
  }
}

class _ScoreBanner extends StatelessWidget {
  final CompareSummary summary;
  final String meName;
  final String opponentName;
  final Color youColor;
  final Color themColor;
  final Color moodDark;

  const _ScoreBanner({
    required this.summary,
    required this.meName,
    required this.opponentName,
    required this.youColor,
    required this.themColor,
    required this.moodDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            moodDark.withValues(alpha: 0.95),
            moodDark.withValues(alpha: 0.82),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ScoreColumn(
              label: meName,
              wins: summary.youWins,
              color: youColor,
            ),
          ),
          Column(
            children: [
              Text(
                '${summary.youWins} - ${summary.themWins}',
                style: const TextStyle(
                  fontFamily: AppFonts.primary,
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                l10n.tiesCount(summary.ties),
                style: const TextStyle(
                  fontFamily: AppFonts.light,
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          Expanded(
            child: _ScoreColumn(
              label: opponentName,
              wins: summary.themWins,
              color: themColor,
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreColumn extends StatelessWidget {
  final String label;
  final int wins;
  final Color color;
  final bool alignEnd;

  const _ScoreColumn({
    required this.label,
    required this.wins,
    required this.color,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: AppFonts.light,
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
        Text(
          '$wins victorias',
          style: TextStyle(
            fontFamily: AppFonts.primary,
            color: color.withValues(alpha: 0.95),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _HighlightsCard extends StatelessWidget {
  final List<CompareMetric> metrics;
  final Color youColor;
  final Color themColor;
  final String youLabel;
  final String themLabel;

  const _HighlightsCard({
    required this.metrics,
    required this.youColor,
    required this.themColor,
    required this.youLabel,
    required this.themLabel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final youLeading =
        metrics.where((m) => m.winner == CompareWinner.you).take(4);
    final themLeading =
        metrics.where((m) => m.winner == CompareWinner.them).take(4);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CompareCardTitle(
            title: l10n.whereYouLead,
            youColor: youColor,
            themColor: themColor,
            youLabel: youLabel,
            themLabel: themLabel,
          ),
          const SizedBox(height: 10),
          for (final m in youLeading)
            _HighlightRow(metric: m, color: youColor, isYou: true),
          if (youLeading.isEmpty)
            Text(
              l10n.noClearAdvantages,
              style: TextStyle(
                fontFamily: AppFonts.light,
                color: Colors.grey.shade600,
                fontSize: 10,
              ),
            ),
          const SizedBox(height: 12),
          Text(
            l10n.whereTheyLead,
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          for (final m in themLeading)
            _HighlightRow(metric: m, color: themColor, isYou: false),
        ],
      ),
    );
  }
}

class _HighlightRow extends StatelessWidget {
  final CompareMetric metric;
  final Color color;
  final bool isYou;

  const _HighlightRow({
    required this.metric,
    required this.color,
    required this.isYou,
  });

  @override
  Widget build(BuildContext context) {
    final value = isYou ? metric.you : metric.them;
    final other = isYou ? metric.them : metric.you;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.trending_up_rounded, size: 14, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              metric.label,
              style: TextStyle(
                fontFamily: AppFonts.light,
                color: Colors.grey.shade700,
                fontSize: 10,
              ),
            ),
          ),
          Text(
            '$value vs $other',
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsTab extends StatelessWidget {
  final Player me;
  final Player opponent;
  final Color youColor;
  final Color themColor;

  const _StatsTab({
    required this.me,
    required this.opponent,
    required this.youColor,
    required this.themColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final metrics = buildCompareMetrics(me, opponent);
    const groupKeys = ['Ayuntamiento', 'Constructor', 'Clan'];
    final groupTitles = [
      l10n.compareGroupTownHall,
      l10n.compareGroupBuilder,
      l10n.compareGroupClan,
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        for (var i = 0; i < groupKeys.length; i++) ...[
          _GroupCard(
            title: groupTitles[i],
            metrics: metrics.where((m) => m.group == groupKeys[i]).toList(),
            youColor: youColor,
            themColor: themColor,
            youLabel: me.name,
            themLabel: opponent.name,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _GroupCard extends StatelessWidget {
  final String title;
  final List<CompareMetric> metrics;
  final Color youColor;
  final Color themColor;
  final String youLabel;
  final String themLabel;

  const _GroupCard({
    required this.title,
    required this.metrics,
    required this.youColor,
    required this.themColor,
    required this.youLabel,
    required this.themLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontFamily: AppFonts.primary,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CompareLegend(
                youColor: youColor,
                themColor: themColor,
                youLabel: youLabel,
                themLabel: themLabel,
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final metric in metrics)
            CompareDualBar(
              label: metric.label,
              you: metric.you,
              them: metric.them,
              youColor: youColor,
              themColor: themColor,
            ),
        ],
      ),
    );
  }
}

class _AchievementsTab extends StatelessWidget {
  final Player me;
  final Player opponent;
  final Color youColor;
  final Color themColor;

  const _AchievementsTab({
    required this.me,
    required this.opponent,
    required this.youColor,
    required this.themColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final homeYou = homeStats(me);
    final homeThem = homeStats(opponent);
    final bbYou = builderStats(me);
    final bbThem = builderStats(opponent);
    final matches = buildAchievementMatches(me, opponent);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        CompareAchievementSummaryCard(
          title: l10n.homeVillageAchievements,
          you: homeYou,
          them: homeThem,
          youColor: youColor,
          themColor: themColor,
          youLabel: me.name,
          themLabel: opponent.name,
        ),
        const SizedBox(height: 12),
        CompareAchievementSummaryCard(
          title: l10n.builderVillageAchievements,
          you: bbYou,
          them: bbThem,
          youColor: youColor,
          themColor: themColor,
          youLabel: me.name,
          themLabel: opponent.name,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.headToHeadCount(matches.length),
          style: TextStyle(
            fontFamily: AppFonts.primary,
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        for (final match in matches)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CompareAchievementMatchTile(
              match: match,
              youColor: youColor,
              themColor: themColor,
              youLabel: me.name,
              themLabel: opponent.name,
            ),
          ),
      ],
    );
  }
}

class _TroopsTab extends StatefulWidget {
  final Player me;
  final Player opponent;
  final Color youColor;
  final Color themColor;

  const _TroopsTab({
    required this.me,
    required this.opponent,
    required this.youColor,
    required this.themColor,
  });

  @override
  State<_TroopsTab> createState() => _TroopsTabState();
}

class _TroopsTabState extends State<_TroopsTab> {
  /// Section keys that are expanded. Empty set = all collapsed.
  late final Set<String> _expanded;

  late List<TroopGroupSummary> _summaries;
  late Map<TroopGroup, List<TroopMatch>> _grouped;
  late List<TroopGroup> _troopSections;
  late List<TroopMatch> _heroes;
  late Map<SpellGroup, List<TroopMatch>> _spellGrouped;
  late List<SpellGroup> _spellSections;
  late List<TroopMatch> _equipment;
  late bool _hasAny;

  @override
  void initState() {
    super.initState();
    _expanded = {'cat-troops'};
    _recomputeMatches();
  }

  @override
  void didUpdateWidget(covariant _TroopsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.me != widget.me || oldWidget.opponent != widget.opponent) {
      _recomputeMatches();
    }
  }

  void _recomputeMatches() {
    final me = widget.me;
    final opponent = widget.opponent;

    _summaries = buildTroopGroupSummaries(me, opponent);
    _grouped = troopMatchesGrouped(me, opponent);
    _troopSections = TroopCatalog.troopDisplayOrder
        .where((g) => _grouped[g]?.isNotEmpty ?? false)
        .toList();
    _heroes = buildHeroMatches(me, opponent);
    _spellGrouped = spellMatchesGrouped(me, opponent);
    _spellSections = TroopCatalog.spellDisplayOrder
        .where((g) => _spellGrouped[g]?.isNotEmpty ?? false)
        .toList();
    _equipment = buildEquipmentMatches(me, opponent);
    _hasAny = _troopSections.isNotEmpty ||
        _heroes.isNotEmpty ||
        _spellSections.isNotEmpty ||
        _equipment.isNotEmpty;
  }

  bool _isOpen(String key) => _expanded.contains(key);

  void _toggle(String key) {
    setState(() {
      if (_expanded.contains(key)) {
        _expanded.remove(key);
      } else {
        _expanded.add(key);
      }
    });
  }

  List<_TroopsListEntry> _buildEntries(AppLocalizations l10n) {
    final items = <_TroopsListEntry>[];

    for (final summary in _summaries) {
      items.add(_TroopsListEntry.summary(summary));
    }

    if (!_hasAny) {
      items.add(const _TroopsListEntry.empty());
      return items;
    }

    items.add(const _TroopsListEntry.levelHeader());

    if (_troopSections.isNotEmpty) {
      items.add(
        _TroopsListEntry.section(
          sectionKey: 'cat-troops',
          title: l10n.categoryTroops,
          count: _troopSections.fold<int>(
            0,
            (sum, g) => sum + _grouped[g]!.length,
          ),
        ),
      );
      if (_isOpen('cat-troops')) {
        for (final group in _troopSections) {
          final sectionKey = 'troop-${group.name}';
          items.add(
            _TroopsListEntry.section(
              sectionKey: sectionKey,
              title: l10n.troopGroupLabel(group),
              count: _grouped[group]!.length,
              accent: TroopCatalog.troopGroupColor(group),
              nested: true,
            ),
          );
          if (_isOpen(sectionKey)) {
            for (final match in _grouped[group]!) {
              items.add(_TroopsListEntry.match(match, nested: true));
            }
          }
        }
      }
    }

    if (_heroes.isNotEmpty) {
      items.add(
        _TroopsListEntry.section(
          sectionKey: 'cat-heroes',
          title: l10n.categoryHeroes,
          count: _heroes.length,
        ),
      );
      if (_isOpen('cat-heroes')) {
        for (final match in _heroes) {
          items.add(_TroopsListEntry.match(match));
        }
      }
    }

    if (_spellSections.isNotEmpty) {
      items.add(
        _TroopsListEntry.section(
          sectionKey: 'cat-spells',
          title: l10n.categorySpells,
          count: _spellSections.fold<int>(
            0,
            (sum, g) => sum + _spellGrouped[g]!.length,
          ),
        ),
      );
      if (_isOpen('cat-spells')) {
        for (final group in _spellSections) {
          final sectionKey = 'spell-${group.name}';
          items.add(
            _TroopsListEntry.section(
              sectionKey: sectionKey,
              title: l10n.spellGroupLabel(group),
              count: _spellGrouped[group]!.length,
              accent: TroopCatalog.spellGroupColor(group),
              nested: true,
            ),
          );
          if (_isOpen(sectionKey)) {
            for (final match in _spellGrouped[group]!) {
              items.add(_TroopsListEntry.match(match, nested: true));
            }
          }
        }
      }
    }

    if (_equipment.isNotEmpty) {
      items.add(
        _TroopsListEntry.section(
          sectionKey: 'cat-equipment',
          title: l10n.equipment,
          count: _equipment.length,
        ),
      );
      if (_isOpen('cat-equipment')) {
        for (final match in _equipment) {
          items.add(_TroopsListEntry.match(match));
        }
      }
    }

    return items;
  }

  Widget _buildEntry(BuildContext context, _TroopsListEntry entry) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final me = widget.me;
    final opponent = widget.opponent;
    final youColor = widget.youColor;
    final themColor = widget.themColor;

    return switch (entry.kind) {
      _TroopsListEntryKind.summary => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CompareTroopGroupSummaryCard(
            summary: entry.summary!,
            youColor: youColor,
            themColor: themColor,
            youLabel: me.name,
            themLabel: opponent.name,
          ),
        ),
      _TroopsListEntryKind.empty => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            l10n.noUnitsToCompare,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.light,
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
          ),
        ),
      _TroopsListEntryKind.levelHeader => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            l10n.levelPerUnit,
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: colorScheme.onPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      _TroopsListEntryKind.section => Padding(
          padding: EdgeInsets.only(bottom: entry.nested ? 8 : 10),
          child: _CompareSectionHeader(
            title: entry.title!,
            count: entry.count!,
            expanded: _isOpen(entry.sectionKey!),
            onToggle: () => _toggle(entry.sectionKey!),
            accent: entry.accent,
            nested: entry.nested,
          ),
        ),
      _TroopsListEntryKind.match => Padding(
          padding: EdgeInsets.fromLTRB(
            entry.nested ? 18 : 10,
            0,
            10,
            8,
          ),
          child: CompareTroopMatchTile(
            match: entry.match!,
            youColor: youColor,
            themColor: themColor,
            youLabel: me.name,
            themLabel: opponent.name,
          ),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final entries = _buildEntries(context.l10n);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildEntry(context, entries[index]),
              childCount: entries.length,
            ),
          ),
        ),
      ],
    );
  }
}

enum _TroopsListEntryKind { summary, empty, levelHeader, section, match }

class _TroopsListEntry {
  final _TroopsListEntryKind kind;
  final TroopGroupSummary? summary;
  final String? sectionKey;
  final String? title;
  final int? count;
  final Color? accent;
  final bool nested;
  final TroopMatch? match;

  const _TroopsListEntry._({
    required this.kind,
    this.summary,
    this.sectionKey,
    this.title,
    this.count,
    this.accent,
    this.nested = false,
    this.match,
  });

  const _TroopsListEntry.empty()
      : this._(kind: _TroopsListEntryKind.empty);

  const _TroopsListEntry.levelHeader()
      : this._(kind: _TroopsListEntryKind.levelHeader);

  factory _TroopsListEntry.summary(TroopGroupSummary summary) =>
      _TroopsListEntry._(
        kind: _TroopsListEntryKind.summary,
        summary: summary,
      );

  factory _TroopsListEntry.section({
    required String sectionKey,
    required String title,
    required int count,
    Color? accent,
    bool nested = false,
  }) =>
      _TroopsListEntry._(
        kind: _TroopsListEntryKind.section,
        sectionKey: sectionKey,
        title: title,
        count: count,
        accent: accent,
        nested: nested,
      );

  factory _TroopsListEntry.match(TroopMatch match, {bool nested = false}) =>
      _TroopsListEntry._(
        kind: _TroopsListEntryKind.match,
        match: match,
        nested: nested,
      );
}

class _CompareSectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final bool expanded;
  final VoidCallback onToggle;
  final Color? accent;
  final bool nested;

  const _CompareSectionHeader({
    required this.title,
    required this.count,
    required this.expanded,
    required this.onToggle,
    this.accent,
    this.nested = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: nested ? colorScheme.secondary.withValues(alpha: 0.12) : Colors.white,
        borderRadius: BorderRadius.circular(nested ? 12 : 14),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: nested ? 0.12 : 0.18),
        ),
      ),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(nested ? 12 : 14),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: nested ? 10 : 12,
            vertical: nested ? 10 : 12,
          ),
          child: Row(
            children: [
              if (accent != null) ...[
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontFamily: AppFonts.primary,
                    color: colorScheme.onPrimary,
                    fontSize: nested ? 10 : 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontFamily: AppFonts.primary,
                    color: colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                expanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                size: 20,
                color: colorScheme.onPrimary.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

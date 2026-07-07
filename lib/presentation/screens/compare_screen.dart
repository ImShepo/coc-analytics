import 'package:coc/config/helpers/clan_tag.dart';
import 'package:coc/config/helpers/player_compare.dart';
import 'package:coc/config/helpers/player_tag.dart';
import 'package:coc/config/helpers/troop_catalog.dart';
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
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tagFocusNode = FocusNode();
    _opponentTag = widget.initialOpponentTag != null
        ? normalizePlayerTag(widget.initialOpponentTag!)
        : null;
    _opponentName = widget.initialOpponentName;
    _tagController = TextEditingController(
      text: _opponentTag != null ? playerTagToDisplay(_opponentTag!) : '',
    );

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

  @override
  void dispose() {
    _tabController.dispose();
    _tagController.dispose();
    _tagFocusNode.dispose();
    super.dispose();
  }

  void _focusSearch() {
    _tagFocusNode.requestFocus();
  }

  void _selectClanMate(MemberList member) {
    final tag = normalizePlayerTag(member.tag);
    if (tag == _opponentTag) return;
    _tagController.text = playerTagToDisplay(member.tag);
    setState(() => _opponentName = member.name);
    _loadOpponent();
  }

  void _resetOpponent() {
    setState(() {
      _opponentTag = null;
      _opponentName = null;
      _tagController.clear();
    });
    _tagFocusNode.requestFocus();
  }

  Future<void> _openOpponentPicker({
    required List<MemberList> clanMates,
    required bool clanLoading,
  }) async {
    FocusScope.of(context).unfocus();
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
    });
    ref.read(playerProvider.notifier).loadPlayer(tag, force: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final youColor = colorScheme.primary;
    const themColor = Color(0xFF6B4E71);

    final opponentAsync = _opponentTag == null
        ? null
        : ref.watch(playerProvider.select((m) => m[_opponentTag!]));

    final clanCacheKey = widget.me.clan.tag.isEmpty
        ? null
        : normalizeClanTag(widget.me.clan.tag);
    final clan = clanCacheKey == null
        ? null
        : ref.watch(clanInfoProvider.select((m) => m[clanCacheKey]));
    final clanMates = clan?.memberList
            .where(
              (m) =>
                  normalizePlayerTag(m.tag) !=
                  normalizePlayerTag(widget.me.tag),
            )
            .toList() ??
        const <MemberList>[];

    final opponent = opponentAsync?.valueOrNull;
    final hasComparison = opponent != null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppScreenStack(
        variant: AppScreenBackgroundVariant.compare,
        child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 210,
            pinned: true,
            backgroundColor: colorScheme.onPrimary,
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
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorScheme.primary.withValues(alpha: 0.4),
                          colorScheme.onPrimary.withValues(alpha: 0.92),
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
                                            clanMates: clanMates,
                                            clanLoading: clanCacheKey != null &&
                                                clan == null,
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
              child: _OpponentSearchBar(
                controller: _tagController,
                focusNode: _tagFocusNode,
                onSearch: _loadOpponent,
                onTapBar: _focusSearch,
                onClear: _opponentTag != null ? _resetOpponent : null,
              ),
            ),
            opponentAsync?.valueOrNull != null
                ? _OpponentSwitcherBar(
                    opponent: opponent!,
                    clanMates: clanMates,
                    currentOpponentTag: _opponentTag,
                    onChangeOpponent: () => _openOpponentPicker(
                      clanMates: clanMates,
                      clanLoading: clanCacheKey != null && clan == null,
                    ),
                    onSelectClanMate: _selectClanMate,
                  )
                : const SizedBox.shrink(),
            Expanded(
              child: opponentAsync == null
                  ? _ComparePickOpponentPanel(
                      me: widget.me,
                      clanMates: clanMates,
                      clanLoading: clanCacheKey != null && clan == null,
                      onFocusSearch: _focusSearch,
                      onSelectClanMate: _selectClanMate,
                      l10n: l10n,
                    )
                  : opponentAsync.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      error: (error, _) => _CompareError(
                        message: error.toString(),
                        onRetry: _loadOpponent,
                      ),
                      data: (opponent) => TabBarView(
                        controller: _tabController,
                        children: [
                          _SummaryTab(
                            me: widget.me,
                            opponent: opponent,
                            youColor: youColor,
                            themColor: themColor,
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
        style: TextStyle(
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
                    fontFamily: AppFonts.light,
                    fontSize: 12,
                    color: Color(0xFF3B3B3B),
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.opponentTagHint,
                    hintStyle: TextStyle(
                      fontFamily: AppFonts.light,
                      fontSize: 12,
                      color: Colors.grey.shade400.withValues(alpha: 0.85),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
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

  const _CompareError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
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

  const _SummaryTab({
    required this.me,
    required this.opponent,
    required this.youColor,
    required this.themColor,
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
                  _LegendDot(color: youColor, label: me.name),
                  const SizedBox(width: 16),
                  _LegendDot(color: themColor, label: opponent.name),
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

  const _ScoreBanner({
    required this.summary,
    required this.meName,
    required this.opponentName,
    required this.youColor,
    required this.themColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.95),
            Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.82),
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

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: AppFonts.light,
            color: Colors.grey.shade700,
            fontSize: 10,
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

  const _HighlightsCard({
    required this.metrics,
    required this.youColor,
    required this.themColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final youLeading = metrics.where((m) => m.winner == CompareWinner.you).take(4);
    final themLeading = metrics.where((m) => m.winner == CompareWinner.them).take(4);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.whereYouLead,
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
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
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              _LegendDot(color: youColor, label: youLabel),
              const SizedBox(width: 8),
              _LegendDot(color: themColor, label: themLabel),
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
        ),
        const SizedBox(height: 12),
        CompareAchievementSummaryCard(
          title: l10n.builderVillageAchievements,
          you: bbYou,
          them: bbThem,
          youColor: youColor,
          themColor: themColor,
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
            ),
          ),
      ],
    );
  }
}

class _TroopsTab extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final summaries = buildTroopGroupSummaries(me, opponent);
    final grouped = troopMatchesGrouped(me, opponent);
    final sections = TroopCatalog.troopDisplayOrder
        .where((g) => grouped[g]?.isNotEmpty ?? false)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        for (final summary in summaries) ...[
          CompareTroopGroupSummaryCard(
            summary: summary,
            youColor: youColor,
            themColor: themColor,
          ),
          const SizedBox(height: 10),
        ],
        if (sections.isNotEmpty) ...[
          Text(
            l10n.levelPerTroop,
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          for (final group in sections) ...[
            Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: TroopCatalog.troopGroupColor(group),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.troopGroupLabel(group).toUpperCase(),
                  style: TextStyle(
                    fontFamily: AppFonts.primary,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final match in grouped[group]!)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CompareTroopMatchTile(
                  match: match,
                  youColor: youColor,
                  themColor: themColor,
                ),
              ),
            const SizedBox(height: 8),
          ],
        ] else
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              l10n.noSharedTroops,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.light,
                color: Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
          ),
      ],
    );
  }
}

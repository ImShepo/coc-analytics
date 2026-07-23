import 'package:coc/config/helpers/upper_case_formatter.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/domain/entities/clan.dart';
import 'package:coc/domain/entities/player_by_clan.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/providers/auth/auth_provider.dart';
import 'package:coc/presentation/providers/players/players_repository_provider.dart';
import 'package:coc/presentation/providers/search/search_clans_provider.dart';
import 'package:coc/presentation/widgets/floating_language_fab.dart';
import 'package:coc/presentation/widgets/login/auto_clear_error.dart';
import 'package:coc/presentation/widgets/login/custom_input.dart';
import 'package:coc/presentation/widgets/login/guide_image_dialog.dart';
import 'package:coc/presentation/widgets/login/link_player_background_painter.dart';
import 'package:coc/presentation/widgets/login/login_button.dart';
import 'package:coc/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _LinkMode { tag, clan }

const _tagGuideAsset = 'assets/images/guides/player_tag_guide.png';
const _tokenGuideAsset = 'assets/images/guides/api_token_guide.png';

class LinkPlayerScreen extends ConsumerStatefulWidget {
  static const name = 'link-player-screen';

  const LinkPlayerScreen({super.key});

  @override
  ConsumerState<LinkPlayerScreen> createState() => _LinkPlayerScreenState();
}

class _LinkPlayerScreenState extends ConsumerState<LinkPlayerScreen>
    with AutoClearErrorMixin {
  final _tagCtrl = TextEditingController();
  final _tokenCtrl = TextEditingController();
  final _clanQueryCtrl = TextEditingController();
  final _pageScrollCtrl = ScrollController();
  final _membersSectionKey = GlobalKey();
  final _verifySectionKey = GlobalKey();

  _LinkMode _mode = _LinkMode.tag;
  bool _loading = false;
  bool _searchingClans = false;
  bool _loadingMembers = false;
  List<Clan> _clans = const [];
  List<PlayerByClan> _members = const [];
  Clan? _selectedClan;
  PlayerByClan? _selectedMember;

  @override
  void dispose() {
    _tagCtrl.dispose();
    _tokenCtrl.dispose();
    _clanQueryCtrl.dispose();
    _pageScrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    final target = key.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      alignment: 0.0,
      alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
    );
  }

  Future<void> _submitTagMode() async {
    final l10n = context.l10n;
    final raw = _tagCtrl.text.trim();
    final token = _tokenCtrl.text.trim();
    if (raw.isEmpty) {
      showAuthError(l10n.linkPlayerTagRequired);
      return;
    }
    if (token.isEmpty) {
      showAuthError(l10n.linkPlayerTokenRequired);
      return;
    }
    await _verifyAndLink(raw, token);
  }

  Future<void> _submitClanMember() async {
    final l10n = context.l10n;
    final member = _selectedMember;
    if (member == null) {
      showAuthError(l10n.linkPlayerPickMemberFirst);
      return;
    }
    final token = _tokenCtrl.text.trim();
    if (token.isEmpty) {
      showAuthError(l10n.linkPlayerTokenRequired);
      return;
    }
    await _verifyAndLink(member.tag, token);
  }

  Future<void> _verifyAndLink(String rawTag, String apiToken) async {
    clearAuthError();
    setState(() => _loading = true);
    final invalidTokenMsg = context.l10n.linkPlayerTokenInvalid;
    try {
      final routeTag = AuthService.playerTagForRoute(rawTag);
      final ok = await ref
          .read(playersRepositoryProvider)
          .verifyPlayerToken(routeTag, apiToken);
      if (!ok) {
        showAuthError(invalidTokenMsg);
        return;
      }
      await ref.read(playersRepositoryProvider).getPlayerById(routeTag);
      await ref.read(linkedPlayerTagProvider.notifier).setTag(rawTag);
      await ref.read(linkDeferredProvider.notifier).clear();
      if (!mounted) return;
      context.go('/player/$routeTag');
    } catch (e) {
      showAuthError(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _skipLinking() async {
    clearAuthError();
    await ref.read(linkDeferredProvider.notifier).defer();
    if (!mounted) return;
    context.go('/home');
  }

  Future<void> _searchClans() async {
    final query = _clanQueryCtrl.text.trim();
    if (query.length < 3) {
      showAuthError(context.l10n.linkPlayerClanQueryHint);
      return;
    }

    clearAuthError();
    setState(() {
      _searchingClans = true;
      _clans = const [];
      _members = const [];
      _selectedClan = null;
      _selectedMember = null;
      _tokenCtrl.clear();
    });

    try {
      final clans = await ref
          .read(searchedClansProvider.notifier)
          .searchClansByQuery(query);
      if (!mounted) return;
      setState(() => _clans = clans);
      if (clans.isEmpty) {
        showAuthError(context.l10n.searchClanNoResults);
      }
    } catch (e) {
      showAuthError(e.toString());
    } finally {
      if (mounted) setState(() => _searchingClans = false);
    }
  }

  Future<void> _selectClan(Clan clan) async {
    clearAuthError();
    setState(() {
      _selectedClan = clan;
      _selectedMember = null;
      _tokenCtrl.clear();
      _loadingMembers = true;
      _members = const [];
    });

    try {
      final members = await ref
          .read(playersRepositoryProvider)
          .getPlayersByClan(AuthService.playerTagForRoute(clan.tag));
      if (!mounted) return;
      setState(() => _members = members);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _scrollToKey(_membersSectionKey);
        });
      });
    } catch (e) {
      showAuthError(e.toString());
    } finally {
      if (mounted) setState(() => _loadingMembers = false);
    }
  }

  void _selectMember(PlayerByClan member) {
    clearAuthError();
    setState(() => _selectedMember = member);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scrollToKey(_verifySectionKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final titleSize = MediaQuery.sizeOf(context).width >= 390 ? 22.0 : 20.0;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF3EA),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: LinkPlayerBackgroundPainter(
                primary: colorScheme.primary,
                secondary: colorScheme.secondary,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              controller: _pageScrollCtrl,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.linkPlayerTitle,
                    maxLines: 2,
                    softWrap: true,
                    style: TextStyle(
                      fontFamily: AppFonts.primary,
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.linkPlayerSubtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SegmentedButton<_LinkMode>(
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      textStyle: WidgetStatePropertyAll(
                        Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontFamily: AppFonts.primary,
                              fontSize: MediaQuery.sizeOf(context).width >= 390
                                  ? 12
                                  : 11,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      iconSize: const WidgetStatePropertyAll(15),
                    ),
                    segments: [
                      ButtonSegment(
                        value: _LinkMode.tag,
                        label: Text(l10n.linkPlayerModeTag),
                        icon: const Icon(Icons.tag),
                      ),
                      ButtonSegment(
                        value: _LinkMode.clan,
                        label: Text(l10n.linkPlayerModeClan),
                        icon: const Icon(Icons.groups_outlined),
                      ),
                    ],
                    selected: {_mode},
                    onSelectionChanged: (value) {
                      setState(() {
                        _mode = value.first;
                        clearAuthError();
                        _selectedMember = null;
                        _tokenCtrl.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_mode == _LinkMode.tag) ...[
                    CustomInput(
                      icon: Icons.tag,
                      placeholder: l10n.linkPlayerTagPlaceholder,
                      textController: _tagCtrl,
                      keyboardType: TextInputType.visiblePassword,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: const [UpperCaseTextFormatter()],
                    ),
                    _GuideHint(
                      text: l10n.linkPlayerTagHelp,
                      buttonLabel: l10n.linkPlayerSeeGuide,
                      onSeeGuide: () => showGuideImageDialog(
                        context,
                        assetPath: _tagGuideAsset,
                      ),
                    ),
                    const SizedBox(height: 14),
                    CustomInput(
                      icon: Icons.vpn_key_outlined,
                      placeholder: l10n.linkPlayerTokenPlaceholder,
                      textController: _tokenCtrl,
                      keyboardType: TextInputType.visiblePassword,
                      textCapitalization: TextCapitalization.none,
                    ),
                    _GuideHint(
                      text: l10n.linkPlayerTokenHelp,
                      buttonLabel: l10n.linkPlayerSeeGuide,
                      onSeeGuide: () => showGuideImageDialog(
                        context,
                        assetPath: _tokenGuideAsset,
                      ),
                    ),
                    if (authError != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        authError!,
                        style: TextStyle(
                          color: colorScheme.error,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    LoginButton(
                      text: _loading
                          ? l10n.linkingPlayer
                          : l10n.linkPlayerButton,
                      onPressed: _loading ? null : _submitTagMode,
                    ),
                  ] else ...[
                    CustomInput(
                      icon: Icons.search,
                      placeholder: l10n.searchClanQueryHint,
                      textController: _clanQueryCtrl,
                      keyboardType: TextInputType.text,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 4),
                      child: Text(
                        l10n.linkPlayerClanQueryHint,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.35,
                          color: Colors.black.withValues(alpha: 0.58),
                        ),
                      ),
                    ),
                    LoginButton(
                      text: _searchingClans
                          ? l10n.linkingPlayer
                          : l10n.linkPlayerSearchClan,
                      onPressed: _searchingClans ? null : _searchClans,
                    ),
                    if (authError != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        authError!,
                        style: TextStyle(
                          color: colorScheme.error,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    if (_clans.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.linkPlayerPickClan,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          Text(
                            l10n.linkPlayerClanCount(_clans.length),
                            style: TextStyle(
                              fontFamily: AppFonts.primary,
                              fontSize: 11,
                              color: colorScheme.primary.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _ScrollableClanList(
                        clans: _clans,
                        selectedTag: _selectedClan?.tag,
                        onSelect: _selectClan,
                        backgroundColor: const Color(0xFFEEF3EA),
                      ),
                    ],
                    if (_loadingMembers)
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    if (_members.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        key: _membersSectionKey,
                        children: [
                          Expanded(
                            child: Text(
                              l10n.linkPlayerPickMember,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          Text(
                            l10n.linkPlayerMemberCount(_members.length),
                            style: TextStyle(
                              fontFamily: AppFonts.primary,
                              fontSize: 11,
                              color: colorScheme.primary.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ..._members.map(
                        (member) => _MemberTile(
                          member: member,
                          selected: _selectedMember?.tag == member.tag,
                          busy: _loading,
                          onTap: () => _selectMember(member),
                        ),
                      ),
                    ],
                    if (_selectedMember != null) ...[
                      const SizedBox(height: 16),
                      KeyedSubtree(
                        key: _verifySectionKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.linkPlayerVerifySelected(
                                _selectedMember!.name,
                                _selectedMember!.tag,
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomInput(
                              icon: Icons.vpn_key_outlined,
                              placeholder: l10n.linkPlayerTokenPlaceholder,
                              textController: _tokenCtrl,
                              keyboardType: TextInputType.visiblePassword,
                            ),
                            _GuideHint(
                              text: l10n.linkPlayerTokenHelp,
                              buttonLabel: l10n.linkPlayerSeeGuide,
                              onSeeGuide: () => showGuideImageDialog(
                                context,
                                assetPath: _tokenGuideAsset,
                              ),
                            ),
                            const SizedBox(height: 12),
                            LoginButton(
                              text: _loading
                                  ? l10n.linkingPlayer
                                  : l10n.linkPlayerButton,
                              onPressed: _loading ? null : _submitClanMember,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _loading ? null : _skipLinking,
                    child: Text(l10n.linkPlayerSkip),
                  ),
                ],
              ),
            ),
          ),
          const FloatingLanguageFab.topTrailing(),
        ],
      ),
    );
  }
}

class _GuideHint extends StatelessWidget {
  final String text;
  final String buttonLabel;
  final VoidCallback onSeeGuide;

  const _GuideHint({
    required this.text,
    required this.buttonLabel,
    required this.onSeeGuide,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 12.5,
            height: 1.35,
            color: Colors.black.withValues(alpha: 0.58),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: onSeeGuide,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              buttonLabel,
              style: TextStyle(
                fontFamily: AppFonts.primary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class _ScrollableClanList extends StatefulWidget {
  /// Tall enough for ~3.4 tiles so the next clan peeks below the fold.
  static const double listHeight = 232;

  final List<Clan> clans;
  final String? selectedTag;
  final ValueChanged<Clan> onSelect;
  final Color backgroundColor;

  const _ScrollableClanList({
    required this.clans,
    required this.selectedTag,
    required this.onSelect,
    required this.backgroundColor,
  });

  @override
  State<_ScrollableClanList> createState() => _ScrollableClanListState();
}

class _ScrollableClanListState extends State<_ScrollableClanList> {
  final _scrollCtrl = ScrollController();
  bool _canScrollDown = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_updateScrollAffordance);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollAffordance());
  }

  @override
  void didUpdateWidget(covariant _ScrollableClanList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.clans.length != widget.clans.length) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _updateScrollAffordance());
    }
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_updateScrollAffordance);
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _updateScrollAffordance() {
    if (!_scrollCtrl.hasClients) return;
    final position = _scrollCtrl.position;
    final canScrollDown = position.maxScrollExtent > 8 &&
        position.pixels < position.maxScrollExtent - 8;
    if (canScrollDown != _canScrollDown) {
      setState(() => _canScrollDown = canScrollDown);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _ScrollableClanList.listHeight,
      child: Stack(
        children: [
          ListView.builder(
            controller: _scrollCtrl,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: EdgeInsets.only(bottom: _canScrollDown ? 28 : 4),
            itemCount: widget.clans.length,
            itemBuilder: (context, index) {
              final clan = widget.clans[index];
              return _ClanTile(
                clan: clan,
                selected: widget.selectedTag == clan.tag,
                onTap: () => widget.onSelect(clan),
              );
            },
          ),
          if (_canScrollDown)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        widget.backgroundColor.withValues(alpha: 0),
                        widget.backgroundColor.withValues(alpha: 0.92),
                        widget.backgroundColor,
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ClanTile extends StatelessWidget {
  final Clan clan;
  final bool selected;
  final VoidCallback onTap;

  const _ClanTile({
    required this.clan,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final nameColor = selected ? Colors.white : Colors.black87;
    final tagColor = selected
        ? Colors.white.withValues(alpha: 0.85)
        : Colors.black54;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? primary : Colors.white,
        elevation: selected ? 3 : 0,
        shadowColor: primary.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? primary : Colors.transparent,
                width: selected ? 2 : 0,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clan.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: nameColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              clan.tag,
                              style: TextStyle(
                                fontSize: 12,
                                color: tagColor,
                                fontWeight:
                                    selected ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.groups_rounded,
                            size: 14,
                            color: tagColor,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${clan.members}',
                            style: TextStyle(
                              fontSize: 12,
                              color: tagColor,
                              fontWeight:
                                  selected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  selected ? Icons.check_circle : Icons.chevron_right,
                  color: selected ? Colors.white : Colors.black45,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  final PlayerByClan member;
  final bool selected;
  final bool busy;
  final VoidCallback onTap;

  const _MemberTile({
    required this.member,
    required this.selected,
    required this.busy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? primary : Colors.white,
        elevation: selected ? 2 : 0,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: busy ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: selected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${member.tag} · TH${member.townHallLevel} · ${member.trophies}',
                        style: TextStyle(
                          fontSize: 12,
                          color: selected
                              ? Colors.white.withValues(alpha: 0.85)
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  selected ? Icons.check_circle : Icons.person_outline,
                  color: selected ? Colors.white : Colors.black45,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

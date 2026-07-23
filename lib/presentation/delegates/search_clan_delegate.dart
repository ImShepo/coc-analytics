import 'dart:async';

import 'package:coc/config/helpers/clan_tag.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/domain/entities/clan.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/widgets/coc_network_image.dart';
import 'package:flutter/material.dart';

typedef SearchClansCallback = Future<List<Clan>> Function(String query);

/// Opens a lightweight clan search page (avoids Material [showSearch] jank).
Future<Clan?> openClanSearch(
  BuildContext context, {
  required String searchFieldLabel,
  required SearchClansCallback searchClans,
  // Kept for call-site compatibility; ignored so the first frame stays empty.
  List<Clan> initialClans = const [],
  String query = '',
}) {
  return Navigator.of(context).push<Clan?>(
    PageRouteBuilder<Clan?>(
      opaque: true,
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 160),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ClanSearchScreen(
          searchFieldLabel: searchFieldLabel,
          searchClans: searchClans,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    ),
  );
}

class ClanSearchScreen extends StatefulWidget {
  final String searchFieldLabel;
  final SearchClansCallback searchClans;

  const ClanSearchScreen({
    super.key,
    required this.searchFieldLabel,
    required this.searchClans,
  });

  @override
  State<ClanSearchScreen> createState() => _ClanSearchScreenState();
}

class _ClanSearchScreenState extends State<ClanSearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  Timer? _debounce;
  List<Clan> _clans = const [];
  bool _loading = false;
  String _lastSubmitted = '';

  @override
  void initState() {
    super.initState();
    // Focus after first paint so open stays cheap.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();

    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      setState(() {
        _clans = const [];
        _loading = false;
        _lastSubmitted = '';
      });
      return;
    }

    if (trimmed == _lastSubmitted) {
      setState(() {}); // refresh clear button / chrome
      return;
    }

    setState(() => _loading = true);

    _debounce = Timer(const Duration(milliseconds: 450), () async {
      _lastSubmitted = trimmed;
      try {
        final clans = await widget.searchClans(trimmed);
        if (!mounted || _lastSubmitted != trimmed) return;
        setState(() {
          _clans = clans;
          _loading = false;
        });
      } catch (_) {
        if (!mounted || _lastSubmitted != trimmed) return;
        setState(() {
          _clans = const [];
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final query = _controller.text.trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F7F1),
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 44,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: colorScheme.onPrimary,
          ),
        ),
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          textInputAction: TextInputAction.search,
          onChanged: _onChanged,
          style: TextStyle(
            fontFamily: AppFonts.primary,
            fontSize: 14,
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.searchFieldLabel,
            hintStyle: TextStyle(
              fontFamily: AppFonts.light,
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.45),
                width: 1.5,
              ),
            ),
            suffixIcon: query.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      _controller.clear();
                      _onChanged('');
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: colorScheme.onPrimary.withValues(alpha: 0.55),
                    ),
                  ),
          ),
        ),
      ),
      body: _buildBody(colorScheme, l10n.searchClanQueryHint, l10n.searchClanNoResults),
    );
  }

  Widget _buildBody(
    ColorScheme colorScheme,
    String emptyHint,
    String noResults,
  ) {
    final query = _controller.text.trim();

    if (query.isEmpty) {
      return _Message(
        icon: Icons.groups_rounded,
        message: emptyHint,
        color: colorScheme.primary,
      );
    }

    if (_loading && _clans.isEmpty) {
      return const Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
    }

    if (!_loading && _clans.isEmpty) {
      return _Message(
        icon: Icons.search_off_rounded,
        message: noResults,
        color: colorScheme.primary,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      // Keep decode work low while scrolling.
      cacheExtent: 240,
      itemCount: _clans.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final clan = _clans[index];
        return _ClanTile(
          clan: clan,
          onTap: () => Navigator.of(context).pop(clan),
        );
      },
    );
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;

  const _Message({
    required this.icon,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color.withValues(alpha: 0.45)),
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

class _ClanTile extends StatelessWidget {
  final Clan clan;
  final VoidCallback onTap;

  const _ClanTile({
    required this.clan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayTag = normalizeClanTag(clan.tag);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.16),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CocNetworkImage(
                  url: clan.badgeUrls.medium.isNotEmpty
                      ? clan.badgeUrls.medium
                      : clan.badgeUrls.small,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  cacheWidth: 96,
                  filterQuality: FilterQuality.low,
                  animatedPlaceholder: false,
                  fadeIn: false,
                  borderRadius: BorderRadius.circular(12),
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
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            displayTag,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppFonts.cardLabel(fontSize: 10),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.groups_rounded,
                          size: 13,
                          color: colorScheme.onPrimary.withValues(alpha: 0.45),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${clan.members}',
                          style: AppFonts.cardLabel(fontSize: 10),
                        ),
                      ],
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

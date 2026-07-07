import 'dart:ui';

import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:coc/l10n/app_localizations.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/l10n/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Floating language control with liquid-glass styling.
/// When [scrollController] is set, hides on scroll-down and reappears on scroll-up
/// (Pinterest-style).
class FloatingLanguageFab extends ConsumerStatefulWidget {
  final ScrollController? scrollController;
  final Alignment alignment;
  final EdgeInsets margin;

  const FloatingLanguageFab({
    super.key,
    this.scrollController,
    this.alignment = Alignment.bottomRight,
    this.margin = const EdgeInsets.only(right: 18, bottom: 22),
  });

  const FloatingLanguageFab.topTrailing({
    super.key,
    this.scrollController,
  })  : alignment = Alignment.topRight,
        margin = const EdgeInsets.only(top: 12, right: 16);

  @override
  ConsumerState<FloatingLanguageFab> createState() =>
      _FloatingLanguageFabState();
}

class _FloatingLanguageFabState extends ConsumerState<FloatingLanguageFab> {
  static const _hideThreshold = 6.0;

  bool _visible = true;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(covariant FloatingLanguageFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController?.removeListener(_handleScroll);
      widget.scrollController?.addListener(_handleScroll);
      _lastOffset = widget.scrollController?.offset ?? 0;
      _visible = true;
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    final controller = widget.scrollController;
    if (controller == null || !controller.hasClients) return;

    final offset = controller.offset;
    final delta = offset - _lastOffset;

    if (offset <= 8) {
      _setVisible(true);
    } else if (delta > _hideThreshold) {
      _setVisible(false);
    } else if (delta < -_hideThreshold) {
      _setVisible(true);
    }

    _lastOffset = offset;
  }

  void _setVisible(bool value) {
    if (_visible == value || !mounted) return;
    setState(() => _visible = value);
  }

  void _openSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        final l10n = sheetContext.l10n;
        final current = ref.read(localeProvider);

        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              color: Colors.white.withValues(alpha: 0.92),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        l10n.language,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: AppFonts.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3B3B3B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final locale in supportedAppLocales)
                        _LanguageSheetTile(
                          locale: locale,
                          label: _localeLabel(l10n, locale),
                          flag: localeFlagEmoji(locale),
                          selected:
                              current.languageCode == locale.languageCode,
                          onTap: () {
                            ref
                                .read(localeProvider.notifier)
                                .setLocale(locale);
                            Navigator.pop(sheetContext);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _localeLabel(AppLocalizations l10n, Locale locale) {
    return switch (locale.languageCode) {
      'es' => l10n.languageEs,
      'en' => l10n.languageEn,
      'pt' => l10n.languagePt,
      'fr' => l10n.languageFr,
      'it' => l10n.languageIt,
      _ => locale.languageCode,
    };
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final topInset = MediaQuery.paddingOf(context).top;

    final isBottomRight = widget.alignment == Alignment.bottomRight;
    final resolvedRight = widget.margin.right;
    final resolvedBottom =
        isBottomRight ? widget.margin.bottom + bottomInset : null;
    final resolvedTop =
        !isBottomRight ? widget.margin.top + topInset : null;

    return Positioned(
      right: resolvedRight,
      bottom: resolvedBottom,
      top: resolvedTop,
      child: IgnorePointer(
        ignoring: !_visible,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          offset: _visible ? Offset.zero : const Offset(0, 1.4),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _visible ? 1 : 0,
            child: _GlassLanguageButton(
              flag: localeFlagEmoji(locale),
              onTap: _openSheet,
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassLanguageButton extends StatefulWidget {
  final String flag;
  final VoidCallback onTap;

  const _GlassLanguageButton({
    required this.flag,
    required this.onTap,
  });

  @override
  State<_GlassLanguageButton> createState() => _GlassLanguageButtonState();
}

class _GlassLanguageButtonState extends State<_GlassLanguageButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(22),
          splashColor: Colors.white24,
          highlightColor: Colors.white10,
          child: LiquidGlassSurface(
            borderRadius: BorderRadius.circular(22),
            padding: EdgeInsets.symmetric(
              horizontal: _hovered ? 12 : 10,
              vertical: 9,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.centerRight,
                  clipBehavior: Clip.hardEdge,
                  child: _hovered
                      ? Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Text(
                            widget.flag,
                            style: const TextStyle(fontSize: 18, height: 1),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                Icon(
                  Icons.language_rounded,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.95),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageSheetTile extends StatelessWidget {
  final Locale locale;
  final String label;
  final String flag;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageSheetTile({
    required this.locale,
    required this.label,
    required this.flag,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: selected
            ? colorScheme.primary.withValues(alpha: 0.1)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Text(flag, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: AppFonts.primary,
                      fontSize: 13,
                      fontWeight:
                          selected ? FontWeight.w500 : FontWeight.w400,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
                if (selected)
                  Icon(Icons.check_circle_rounded,
                      size: 20, color: colorScheme.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

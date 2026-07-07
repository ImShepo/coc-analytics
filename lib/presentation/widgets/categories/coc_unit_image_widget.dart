import 'package:coc/config/helpers/building_catalog.dart';
import 'package:coc/config/helpers/coc_unit_image.dart';
import 'package:coc/config/helpers/troop_catalog.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/presentation/widgets/coc_network_image.dart';
import 'package:flutter/material.dart';

class CocUnitImageWidget extends StatefulWidget {
  final String name;
  final UnitCategory category;
  final String? localAssetPath;
  final String? imageName;
  final int level;
  final int maxLevel;
  final String village;
  final TroopGroup? troopGroup;
  final BuildingGroup? buildingGroup;
  final bool showLevelBadge;
  final int? levelBadgeValue;
  final BoxFit fit;
  final double? width;
  final double? height;
  final bool performanceMode;

  const CocUnitImageWidget({
    super.key,
    required this.name,
    required this.category,
    this.localAssetPath,
    this.imageName,
    this.level = 1,
    this.maxLevel = 1,
    this.village = 'home',
    this.troopGroup,
    this.buildingGroup,
    this.showLevelBadge = false,
    this.levelBadgeValue,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.performanceMode = false,
  });

  bool get _isCompact => height != null && height! <= 52;

  @override
  State<CocUnitImageWidget> createState() => _CocUnitImageWidgetState();
}

class _CocUnitImageWidgetState extends State<CocUnitImageWidget> {
  late List<String> _urls;
  int _urlIndex = 0;

  @override
  void initState() {
    super.initState();
    _urls = _resolveUrls();
  }

  @override
  void didUpdateWidget(covariant CocUnitImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.name != widget.name ||
        oldWidget.level != widget.level ||
        oldWidget.maxLevel != widget.maxLevel ||
        oldWidget.category != widget.category ||
        oldWidget.imageName != widget.imageName ||
        oldWidget.village != widget.village) {
      _urls = _resolveUrls();
      _urlIndex = 0;
    }
  }

  List<String> _resolveUrls() {
    if (widget.localAssetPath != null) return [];
    return CocUnitImage.urlsFor(
      name: widget.name,
      category: widget.category,
      imageName: widget.imageName,
      level: widget.level,
      maxLevel: widget.maxLevel,
      village: widget.village,
      troopGroup: widget.troopGroup,
      buildingGroup: widget.buildingGroup,
    );
  }

  void _tryNextUrl() {
    if (!mounted || _urlIndex >= _urls.length - 1) return;
    setState(() => _urlIndex++);
  }

  Widget _clipChild(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: child,
      ),
    );
  }

  Widget _withLevelBadge(Widget child) {
    if (!widget.showLevelBadge || (widget.levelBadgeValue ?? 0) <= 0) {
      return child;
    }

    final badgeValue = widget.levelBadgeValue!;
    final isMaxed = widget.maxLevel > 0 &&
        badgeValue >= widget.maxLevel &&
        widget.maxLevel > 1;
    final badgeColor = isMaxed
        ? const Color(0xFFC9A227)
        : Theme.of(context).colorScheme.primary;

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.hardEdge,
      children: [
        child,
        Positioned(
          right: widget._isCompact ? 2 : 4,
          bottom: widget._isCompact ? 2 : 4,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget._isCompact ? 4 : 6,
              vertical: widget._isCompact ? 1 : 2,
            ),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              '$badgeValue',
              style: TextStyle(
                fontFamily: AppFonts.primary,
                color: Colors.white,
                fontSize: widget._isCompact ? 7 : 9,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.localAssetPath != null) {
      return _clipChild(
        _withLevelBadge(
          Image.asset(
            widget.localAssetPath!,
            fit: widget.fit,
            width: widget.width,
            height: widget.height,
            errorBuilder: (_, __, ___) => _Fallback(
              name: widget.name,
              category: widget.category,
              width: widget.width,
              height: widget.height,
              compact: widget._isCompact,
            ),
          ),
        ),
      );
    }

    if (_urls.isEmpty || _urlIndex >= _urls.length) {
      return _clipChild(
        _withLevelBadge(
          _Fallback(
            name: widget.name,
            category: widget.category,
            width: widget.width,
            height: widget.height,
            compact: widget._isCompact,
          ),
        ),
      );
    }

    final currentUrl = _urls[_urlIndex];
    final cacheSize = _decodeCacheSize(context);

    return _clipChild(
      _withLevelBadge(
        CocNetworkImage(
          key: ValueKey(currentUrl),
          url: currentUrl,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          cacheWidth: cacheSize,
          cacheHeight: cacheSize,
          filterQuality:
              widget.performanceMode ? FilterQuality.low : FilterQuality.medium,
          animatedPlaceholder: !widget.performanceMode,
          fadeIn: !widget.performanceMode,
          borderRadius: BorderRadius.circular(6),
          onImageError: () {
            WidgetsBinding.instance.addPostFrameCallback((_) => _tryNextUrl());
          },
          errorWidget: _urlIndex >= _urls.length - 1
              ? _Fallback(
                  name: widget.name,
                  category: widget.category,
                  width: widget.width,
                  height: widget.height,
                  compact: widget._isCompact,
                )
              : CocImageLoadingPlaceholder(
                  width: widget.width,
                  height: widget.height,
                  animated: !widget.performanceMode,
                ),
        ),
      ),
    );
  }

  int? _decodeCacheSize(BuildContext context) {
    final edge = widget.width ?? widget.height;
    if (edge == null) return null;
    final pixels = (edge * MediaQuery.devicePixelRatioOf(context)).round();
    return pixels.clamp(48, 160);
  }
}

class _Fallback extends StatelessWidget {
  final String name;
  final UnitCategory category;
  final double? width;
  final double? height;
  final bool compact;

  const _Fallback({
    required this.name,
    required this.category,
    this.width,
    this.height,
    this.compact = false,
  });

  IconData get _icon => switch (category) {
        UnitCategory.troop => Icons.groups_rounded,
        UnitCategory.hero => Icons.shield_rounded,
        UnitCategory.spell => Icons.auto_fix_high_rounded,
        UnitCategory.equipment => Icons.hardware_rounded,
        UnitCategory.building => Icons.account_balance_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconSize = height != null ? (height! * 0.5).clamp(14.0, 28.0) : 28.0;

    if (compact) {
      return Container(
        width: width,
        height: height,
        color: colorScheme.secondary.withValues(alpha: 0.2),
        alignment: Alignment.center,
        child: Icon(_icon, color: colorScheme.primary, size: iconSize),
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.18),
            colorScheme.onPrimary.withValues(alpha: 0.12),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_icon, color: colorScheme.primary, size: iconSize),
          if (height == null || height! > 64) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.light,
                  color: colorScheme.onPrimary,
                  fontSize: 9,
                  height: 1.15,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

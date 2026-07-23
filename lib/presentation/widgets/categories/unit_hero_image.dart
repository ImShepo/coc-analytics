import 'package:coc/domain/entities/player.dart';
import 'package:coc/presentation/models/category_unit.dart';
import 'package:coc/presentation/widgets/categories/coc_unit_image_widget.dart';
import 'package:flutter/material.dart';

/// Imagen compartida entre la tarjeta y el detalle para la transición Hero.
class UnitHeroImage extends StatelessWidget {
  final CategoryUnit unit;
  final Player player;
  final double size;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final EdgeInsets padding;
  final bool performanceMode;

  const UnitHeroImage({
    super.key,
    required this.unit,
    required this.player,
    required this.size,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.backgroundColor = const Color(0x2E000000),
    this.padding = const EdgeInsets.all(6),
    this.performanceMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final image = _ImageBody(
      unit: unit,
      player: player,
      size: size,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      padding: padding,
      performanceMode: performanceMode,
    );

    if (performanceMode) {
      return Material(
        color: Colors.transparent,
        child: SizedBox(width: size, height: size, child: image),
      );
    }

    return Hero(
      tag: unit.heroTag,
      flightShuttleBuilder: (
        flightContext,
        animation,
        flightDirection,
        fromHeroContext,
        toHeroContext,
      ) {
        return Material(
          color: Colors.transparent,
          child: SizedBox(
            width: size,
            height: size,
            child: _ImageBody(
              unit: unit,
              player: player,
              size: size,
              borderRadius: borderRadius,
              backgroundColor: backgroundColor,
              padding: padding,
              performanceMode: performanceMode,
            ),
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: size,
          height: size,
          child: _ImageBody(
            unit: unit,
            player: player,
            size: size,
            borderRadius: borderRadius,
            backgroundColor: backgroundColor,
            padding: padding,
            performanceMode: performanceMode,
          ),
        ),
      ),
    );
  }
}

class _ImageBody extends StatelessWidget {
  final CategoryUnit unit;
  final Player player;
  final double size;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final EdgeInsets padding;
  final bool performanceMode;

  const _ImageBody({
    required this.unit,
    required this.player,
    required this.size,
    required this.borderRadius,
    required this.backgroundColor,
    required this.padding,
    this.performanceMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final innerSize = size - padding.horizontal;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: CocUnitImageWidget(
          name: unit.name,
          category: unit.category,
          imageName: unit.displayImageName,
          level: unit.displayImageLevel(player),
          maxLevel: unit.maxLevel,
          village: unit.village,
          troopGroup: unit.troopGroup,
          buildingGroup: unit.buildingGroup,
          localAssetPath: unit.localAssetPath,
          showLevelBadge: unit.showLevelBadge,
          levelBadgeValue: unit.levelBadgeValue(player),
          fit: BoxFit.contain,
          width: innerSize,
          height: innerSize,
          performanceMode: performanceMode,
        ),
      ),
    );
  }
}

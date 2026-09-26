import 'package:coc/domain/entities/player.dart';
import 'package:coc/presentation/models/category_unit.dart';
import 'package:coc/presentation/screens/unit_detail_screen.dart';
import 'package:flutter/material.dart';

/// Opaque detail route: the Hero flight lives in the navigator overlay, so the
/// previous screen must stop painting once the transition settles.
class UnitDetailRoute extends PageRoute<void> {
  final CategoryUnit unit;
  final Player player;

  UnitDetailRoute({required this.unit, required this.player});

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 240);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return UnitDetailScreen(unit: unit, player: player);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation.drive(CurveTween(curve: Curves.fastOutSlowIn)),
      child: child,
    );
  }
}

void openUnitDetail(
  BuildContext context,
  CategoryUnit unit, {
  required Player player,
}) {
  Navigator.of(context).push(UnitDetailRoute(unit: unit, player: player));
}

import 'package:coc/domain/entities/player.dart';
import 'package:coc/presentation/models/category_unit.dart';
import 'package:coc/presentation/screens/unit_detail_screen.dart';
import 'package:flutter/material.dart';

/// Ruta que mantiene la pantalla anterior y deja volar el Hero al volver.
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
  Duration get transitionDuration => const Duration(milliseconds: 380);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 340);

  @override
  bool get opaque => false;

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
    final fade = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return FadeTransition(
      opacity: fade,
      child: child,
    );
  }
}

void openUnitDetail(BuildContext context, CategoryUnit unit, {required Player player}) {
  final cardContext = context;
  Scrollable.ensureVisible(
    cardContext,
    duration: const Duration(milliseconds: 1),
    alignment: 0.35,
  );

  Navigator.of(context).push(UnitDetailRoute(unit: unit, player: player));
}

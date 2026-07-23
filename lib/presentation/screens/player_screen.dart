import 'package:flutter/material.dart';
import 'package:coc/presentation/views/player_view.dart';

class PlayerScreen extends StatelessWidget {
  static const name = 'home-screen';

  /// When null/empty, shows Inicio without a linked Clash player.
  final String? playerId;

  const PlayerScreen({super.key, this.playerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlayerView(
        playerId: playerId,
      ),
    );
  }
}

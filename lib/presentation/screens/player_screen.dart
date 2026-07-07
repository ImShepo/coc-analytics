import 'package:flutter/material.dart';
import 'package:coc/presentation/views/player_view.dart';

class PlayerScreen extends StatelessWidget {
  static const name = 'home-screen';

  final String playerId;

  const PlayerScreen({super.key, required this.playerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlayerView(
        playerId: playerId,
      ),
    );
  }
}

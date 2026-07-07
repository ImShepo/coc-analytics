import 'package:coc/presentation/widgets/troop_card.dart';
import 'package:flutter/material.dart';

class Troops extends StatelessWidget {
  const Troops({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: TroopCard(
              imagePath: 'assets/images/COC.jpeg',
              title: 'Elixir Troops',
              description: 'Elixir troops are trained in the regular Barracks...',
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TroopCard(
              imagePath: 'assets/images/COC.jpeg',
              title: 'Dark Elixir Troops',
              description: 'Dark Elixir troops are troops that require Dark Elixir to...',
            ),
          ),
        ],
      ),
    );
  }
}
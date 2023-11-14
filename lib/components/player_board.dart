import 'package:flutter/material.dart';
import 'package:flutter_battleships/components/grid.dart';
import 'package:flutter_battleships/components/ships.dart';

class PlayerBoard extends StatefulWidget {
  final String player;

  const PlayerBoard({super.key, required this.player});

  @override
  State<PlayerBoard> createState() => _PlayerBoardState();
}

class _PlayerBoardState extends State<PlayerBoard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 8.0,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            widget.player == 'enemy'
                ? 'assets/images/opponent.jpg'
                : 'assets/images/player.jpg',
          ),
          fit: BoxFit.fill,
          opacity: 0.25,
          // colorFilter: ColorFilter.mode(
          //   Colors.red.withOpacity(0.25),
          //   BlendMode.darken,
          // ),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Enemy',
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ShipsWidget(),
              ),
              Expanded(
                flex: 2,
                child: GridWidget(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

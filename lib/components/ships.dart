import 'package:flutter/material.dart';
import 'package:flutter_battleships/models/ship.dart';

class ShipsWidget extends StatefulWidget {
  const ShipsWidget({super.key});

  @override
  State<ShipsWidget> createState() => _ShipsWidgetState();
}

class _ShipsWidgetState extends State<ShipsWidget> {
  final List<Ship> ships = [
    Ship(
      path: 'assets/images/carrier.png',
      name: 'Carrier',
      length: 5,
    ),
    Ship(
      path: 'assets/images/battleship.png',
      name: 'Battleship',
      length: 4,
    ),
    Ship(
      path: 'assets/images/cruiser.png',
      name: 'Cruiser',
      length: 3,
      isDestroyed: true,
    ),
    Ship(
      path: 'assets/images/destroyer.png',
      name: 'Destroyer',
      length: 2,
      isDestroyed: true,
    ),
    Ship(
      path: 'assets/images/submarine.png',
      name: 'Submarine',
      length: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ships inventory',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(),
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: 8.0,
                    ),
                    child: Image(
                      image: AssetImage(
                        ships[index].path,
                      ),
                      width: 16,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ships[index].name,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${ships[index].length.toString()} cells",
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: Image(
                      image: AssetImage(
                        ships[index].isDestroyed
                            ? 'assets/images/exploded.png'
                            : 'assets/images/alive.png',
                      ),
                      width: 16,
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: ships.length,
        ),
      ],
    );
  }
}

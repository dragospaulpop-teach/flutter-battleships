import 'package:flutter/material.dart';
import 'package:flutter_battleships/components/player_board.dart';
import 'package:flutter_battleships/components/appbar_widget.dart';

class BattleScreen extends StatelessWidget {
  const BattleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (
      BuildContext context,
      BoxConstraints constraints,
    ) {
      bool isLandscape = constraints.maxWidth > constraints.maxHeight;
      double? height = isLandscape
          ? null
          : MediaQuery.of(context).size.height - kToolbarHeight * 1.5;
      double? width = isLandscape ? MediaQuery.of(context).size.width : null;
      Widget mainLayout;

      if (isLandscape) {
        mainLayout = Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: width! / 2,
              child: const PlayerBoard(player: 'enemy'),
            ),
            // Divider(thickness: 2),
            SizedBox(
              width: width / 2,
              child: const PlayerBoard(player: 'owner'),
            ),
          ],
        );
      } else {
        mainLayout = const Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            PlayerBoard(player: 'enemy'),
            Divider(thickness: 2),
            PlayerBoard(player: 'owner'),
          ],
        );
      }

      return Scaffold(
        appBar: const AppbarWidget(title: 'BattleScreen'),
        body: SafeArea(
          child: SizedBox(
            height: height,
            width: width,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: mainLayout,
            ),
          ),
        ),
      );
    });
  }
}

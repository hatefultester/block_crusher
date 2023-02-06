import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/screens/main_screen/moving_button.dart';
import 'package:flutter/material.dart';

class MainMenuArea extends StatelessWidget {
  const MainMenuArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const <Widget>[
          MainMovingButton(title: 'p l a y', route : '/play', millisecondSpeed: 7, x: Direction.right),
          MainMovingButton(title: 's e t t i n g s', route : '/settings', millisecondSpeed: 13,),
        ],
      );
  }
}

import 'package:block_crusher/src/screens/levels/level_screen_state.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackgroundGamePart extends StatelessWidget {
  const BackgroundGamePart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelScreenState = context.read<LevelScreenState>();

    return GameWidget(game: levelScreenState.backgroundGame);
  }
}

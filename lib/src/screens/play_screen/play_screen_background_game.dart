import 'package:block_crusher/src/screens/play_screen/play_screen_provider.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayScreenBackgroundGame extends StatelessWidget {
  const PlayScreenBackgroundGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelScreenState = context.read<PlayScreenProvider>();

    return GameWidget(game: levelScreenState.backgroundGame);
  }
}

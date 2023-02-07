
import 'package:block_crusher/src/screens/play_screen/widgets/level_selection_background.dart';
import 'package:flutter/material.dart';

class PlayScreenProvider extends ChangeNotifier {

  final PageController pageController;

  final LevelSelectionBackground backgroundGame;

  PlayScreenProvider({required this.pageController, required this.backgroundGame});

  pageSwitched(int page) {
    backgroundGame.map.changeBackground(page);
  }

}
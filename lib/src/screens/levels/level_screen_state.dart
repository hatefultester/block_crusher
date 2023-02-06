import 'package:block_crusher/src/screens/levels/widgets/level_selection_background.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LevelScreenState extends ChangeNotifier {

  final PageController pageController;

  final LevelSelectionBackground backgroundGame;

  LevelScreenState({required this.pageController, required this.backgroundGame});

  pageSwitched(int page) {
    backgroundGame.map.changeBackground(page);
  }
}
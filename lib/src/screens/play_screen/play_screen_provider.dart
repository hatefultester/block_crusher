
import 'package:block_crusher/src/screens/play_screen/widgets/level_selection_background.dart';
import 'package:flutter/material.dart';

import '../../style/custom_snackbars/error_message_snackbar.dart';

class PlayScreenProvider extends ChangeNotifier {

  final PageController pageController;

  final LevelSelectionBackground backgroundGame;

  final GlobalKey<ScaffoldMessengerState> key;

  PlayScreenProvider({required this.pageController, required this.backgroundGame, required this.key});

  pageSwitched(int page) {
    backgroundGame.map.changeBackground(page);
  }

}
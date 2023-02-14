
import 'package:block_crusher/src/screens/play_screen/widgets/level_selection_background.dart';
import 'package:flutter/material.dart';

class PlayScreenProvider extends ChangeNotifier {

  int _page = 0;
  int get page => _page;

  final PageController pageController;

  final LevelSelectionBackground backgroundGame;

  PlayScreenProvider({required this.pageController, required this.backgroundGame});

  pageSwitched(int page) {
    // if(page < 0) return;
    // if(page >= pageController.positions.length) return;
    _page = page;
    backgroundGame.map.changeBackground(page);
    print(_page.toString());
  }

  nextPage() {
    if(!canGoToNextPage()) return;
    pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    pageSwitched(_page + 1);
  }

  previousPage() {
    if(!canGoToPreviousPage()) return;
    pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOutBack);
    pageSwitched(_page - 1);
  }

  bool canGoToNextPage() {

    // natvrdo
    return _page != 5;
  }

  bool canGoToPreviousPage() {
    return _page != 0;
  }
}
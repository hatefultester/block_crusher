
import 'package:block_crusher/src/screens/levels/pages/alien_land_levels.dart';
import 'package:block_crusher/src/screens/levels/pages/city_land_levels.dart';
import 'package:block_crusher/src/screens/levels/pages/purple_land_levels.dart';
import 'package:block_crusher/src/screens/levels/pages/shark_land_levels.dart';
import 'package:block_crusher/src/screens/levels/pages/soomy_land_levels.dart';
import 'package:block_crusher/src/screens/levels/widgets/level_selection_background.dart';
import 'package:block_crusher/src/storage/level_statistics/level_statistics.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/hoomy_land_levels.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final levelStatistics = context.watch<LevelStatistics>();

    int initPage = levelStatistics.highestLevelReached ~/ 6;

    if (levelStatistics.highestLevelReached == 23) initPage++;

    if (levelStatistics.highestLevelReached > 23) initPage = 5;

    final LevelSelectionBackground game =
        LevelSelectionBackground(initPage.toInt());

    bool jumperDone = false;

    ///
    /// GAME WIDGET
    ///
    gameWidget() {
      return GameWidget(game: game);
    }

    /// PAGE JUMPER
    /// method for jumping to last selected level
    ///
    pageJumper(int page, PageController controller) async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        game.map.jumperLoaded = true;
        if (controller.hasClients) {
          controller.jumpToPage(page);
        }
        Future.delayed(const Duration(milliseconds: 300));
        game.addMap();
        jumperDone = true;
      });
    }

    /// LEVELS PAGE VIEW
    /// returns page view with all level types
    ///
    levelsPageView() {
      final controller = PageController();
      pageJumper(initPage, controller);

      return PageView(
        onPageChanged: (page) => {
          if (jumperDone)
            {
              game.map.changeBackground(page),
            }
        },
        controller: controller,
        children: const [
          SoomyLandLevels(),
          HoomyLandLevels(),
          SharkLandLevels(),
          CityLandLevels(),
           PurpleLandLevels(),
           AlienLandLevels(),
        ],
      );
    }


    /// return method
    return Scaffold(
      body: Stack(
        children: [
          gameWidget(),
          levelsPageView(),
        ],
      ),
    );
  }
}

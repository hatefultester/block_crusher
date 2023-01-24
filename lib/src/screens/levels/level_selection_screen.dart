

import 'dart:io';
import 'package:block_crusher/src/game_internals/level_logic/levels.dart';
import 'package:block_crusher/src/game_internals/player_progress/player_progress.dart';
import 'package:block_crusher/src/screens/levels/pages/alien_land_levels.dart';
import 'package:block_crusher/src/screens/levels/pages/city_land_levels.dart';
import 'package:block_crusher/src/screens/levels/pages/shark_land_levels.dart';
import 'package:block_crusher/src/screens/levels/pages/soomy_land_levels.dart';
import 'package:block_crusher/src/screens/levels/widgets/level_selection_background.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';


import 'pages/purple_land_levels.dart';
import 'pages/hoomy_land_levels.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final playerProgress = context.watch<PlayerProgress>();

    int initPage = playerProgress.highestLevelReached ~/ 6;
    if (playerProgress.highestLevelReached == 23) initPage++;
    if(playerProgress.highestLevelReached > 23) initPage = 5;

    final LevelSelectionBackground game =
        LevelSelectionBackground(initPage.toInt());

    bool jumperDone = false;


    ///
    /// TOP APP LAYER WIDGET
    ///
    topAppLayer() {
      Widget content = Container(
        decoration: const BoxDecoration(color: Colors.black),
        height: 50,
        width: double.infinity,
        child: Stack(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 25,
                    ),
                    onPressed: (() => {
                          Navigator.pop(context),
                        }),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Center(
              child: Text(
                'L E V E L S',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
          ],
        ),
      );

      if (Platform.isIOS) {
        return Column(
          children: [
            Container(
              color: Colors.black,
              height: 40,
            ),
            content
          ],
        );
      } else {
        return content;
      }
    }

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
      int initPage = playerProgress.highestLevelReached ~/ 6;
      if (playerProgress.highestLevelReached == 23) initPage++;
      if(playerProgress.highestLevelReached > 23) initPage = 5;
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

    /// BOTTOM WIDGET PART
    /// HAS STATISTICS, IS BOTTOMSHEET
    ///
    bottomWidget() {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
            height: 60,
            color: Colors.black,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Your progress',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  width: 200,
                  child: LinearPercentIndicator(
                    percent:
                        playerProgress.highestLevelReached / gameLevels.length,
                    lineHeight: 20,
                    width: 200,
                    backgroundColor: Colors.white,
                    linearGradient: LinearGradient(
                      end: Alignment.centerLeft,
                      begin: Alignment.centerRight,
                      colors: [
                        Colors.red,
                        Colors.red.shade400,
                        Colors.yellow.shade200,
                        Colors.yellow,
                      ],
                    ),
                    barRadius: const Radius.circular(8),
                    center: Text('${playerProgress.highestLevelReached} / ${gameLevels.length}'),
                  ),
                ),
                Text(playerProgress.coinCount.toString()),
              ],
            )),
      );
    }

    /// return method
    return Scaffold(
      body: Stack(
        children: [
          gameWidget(),
          levelsPageView(),
          topAppLayer(),
          bottomWidget(),
        ],
      ),
    );
  }
}

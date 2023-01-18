// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'package:block_crusher/src/screens/levels/level_selection_background.dart';
import 'package:block_crusher/src/screens/levels/level_selection_data.dart';
import 'package:block_crusher/src/utils/characters.dart';
import 'package:block_crusher/src/game_internals/collector_game/components/sprite_block_component.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../audio/audio_controller.dart';
import '../../audio/sounds.dart';
import '../../player_progress/player_progress.dart';
import '../../level_selection/levels.dart';

import 'level_page.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    final playerProgress = context.watch<PlayerProgress>();

    var highestScore = playerProgress.highestLevelReached;

    int initPage = playerProgress.highestLevelReached ~/ 6;
    if (playerProgress.highestLevelReached == 23) initPage++;

    final LevelSelectionBackground game =
        LevelSelectionBackground(initPage.toInt());

    bool jumperDone = false;

    ///
    /// SINGLE LINE WIDGET FOR BUILDING ROAD'S
    ///

    line(Direction direction, int lineId, int offset) {
      final lineColor = playerProgress.highestLevelReached > lineId
          ? Colors.yellow.shade600
          : playerProgress.highestLevelReached == lineId
              ? Colors.white
              : Colors.grey;

      final borderColor = playerProgress.highestLevelReached > lineId
          ? Colors.black
          : playerProgress.highestLevelReached == lineId
              ? Colors.black
              : Colors.blueGrey;

      final double lineThickness = playerProgress.highestLevelReached > lineId
          ? 8
          : playerProgress.highestLevelReached == lineId
              ? 8
              : 5;

      final BoxDecoration borderDecoration = BoxDecoration(
          color: lineColor, border: Border.all(color: borderColor, width: 0.5));

      if (direction == Direction.down) {
        return Transform.rotate(
          angle: -0.1,
          child: Column(
            children: [
              const Spacer(),
              Container(
                decoration: borderDecoration,
                height: lineThickness,
                width: 4,
              ),
              SizedBox(
                height: boxSize / 2 + offset,
              )
            ],
          ),
        );
      }

      if (direction == Direction.up) {
        return Transform.rotate(
          angle: -0.1,
          child: Column(
            children: [
              SizedBox(
                height: boxSize / 2 + offset,
              ),
              Container(
                decoration: borderDecoration,
                height: lineThickness,
                width: 4,
              ),
              const Spacer(),
            ],
          ),
        );
      }

      if (direction == Direction.right) {
        return Row(
          children: [
            const Spacer(),
            Transform.rotate(
              angle: -0.05,
              child: Container(
                decoration: borderDecoration,
                height: 5,
                width: lineThickness,
              ),
            ),
            SizedBox(width: (boxSize / 2 + padding) + offset)
          ],
        );
      }

      if (direction == Direction.left) {
        return Row(
          children: [
            SizedBox(width: (boxSize / 2 + padding) + offset),
            Transform.rotate(
              angle: -0.05,
              child: Container(
                decoration: borderDecoration,
                height: 5,
                width: lineThickness,
              ),
            ),
            const Spacer(),
          ],
        );
      }

      return const SizedBox.shrink();
    }

    ///
    /// TOP APP LAYER WIDGET
    ///
    topAppLayer() {
      Widget content = Container(
        decoration: const BoxDecoration(color: Colors.black),
        height: 60,
        width: double.infinity,
        child: Stack(
          children: [
            SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
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
                style: TextStyle(fontSize: 35, color: Colors.white),
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

    ///
    /// MINI BOX AND DIALOG FOR FUTURE IMPROVMENT MAYBE :Shrug: ?
    ///
    miniBox(int levelId, int gameId) {
      return InkWell(
        onTap: () =>
            {GoRouter.of(context).go('/play/session/$levelId/$gameId')},
        child: SizedBox(
          width: double.infinity,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('CoinPicker'),
            ],
          ),
        ),
      );
    }

    ///
    /// BONUS LEVELS DIALOG
    ///
    // ignore: unused_element
    bonusLevelsDialog(int levelId) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                    colors: [Colors.white, Colors.yellow.shade200],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
              margin: const EdgeInsets.symmetric(vertical: 150, horizontal: 50),
              width: double.infinity,
              height: double.infinity,
              child: Material(
                child: Column(children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Bonus Games',
                        style: TextStyle(
                            fontFamily: 'Quikhand',
                            color: Colors.black,
                            fontSize: 35,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black26,
                            decorationStyle: TextDecorationStyle.wavy),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          miniBox(levelId, 0),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: ElevatedButton(
                          child: const Text('Close'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      )),
                ]),
              ),
            ),
          );
        },
      );
    }

    ///
    /// BOX WIDGET
    ///
    box(int levelId) {
      final level = gameLevels[levelId];
      final bool enabled = highestScore >= level.levelId - 1;

      final bool won = highestScore > level.levelId - 1;

      final audioController = context.read<AudioController>();

      final Widget child = Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: won
              ? LinearGradient(
                  begin:
                      levelId.isEven ? Alignment.topRight : Alignment.topLeft,
                  end: levelId.isEven
                      ? Alignment.bottomLeft
                      : Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.yellow.shade200,
                    Colors.white,
                  ],
                )
              : null,
          border: Border.all(
            color: won ? Colors.yellow.shade600 : Colors.black,
            width: won ? 3 : 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        width: enabled && !won ? boxSize : boxSize - 20,
        height: enabled && !won ? boxSize : boxSize - 20,
        child: Image.asset(
            'assets/images/${imageSource[level.levelDifficulty.index][level.characterId]['source']}'),
      );

      if (enabled) {
        return Material(
          color: const Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    audioController.playSfx(SfxType.buttonTap);

                    GoRouter.of(context).go('/play/session/${level.levelId}/0');
                  },
                  child: child),
              won
                  ? SizedBox(
                      width: boxSize - 20,
                      height: boxSize - 20,
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.check,
                                color: Colors.yellow.shade800),
                          )))
                  : const SizedBox.shrink()
            ],
          ),
        );
      } else {
        return ColorFiltered(
          colorFilter: greyscale,
          child: Material(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
              child: child),
        );
      }
    }

//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//
//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//
//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//

    /// SOOMY PAGE
    /// PAGE1
    ///
    soomyPage() {
      var soomyPageTopSectionFlex = 1;
      var soomyPageMiddleSectionFlex = 1;
      var soomyPageBottomSectionFlex = 1;

      List<Widget> soomyPageTopSection = [
        Expanded(
            child: Column(
          children: [
            for (int i = 0; i < 30; i++)
              i.isEven ? const Spacer() : line(Direction.left, 0, 0),
          ],
        )),
        SizedBox(
          height: playerProgress.highestLevelReached == 0 ||
                  playerProgress.highestLevelReached == 1
              ? boxSize
              : boxSize - 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: padding,
              ),
              box(0),
              for (int i = 0; i < 30; i++)
                i.isEven ? const Spacer() : line(Direction.down, 1, 0),
              box(1),
              SizedBox(
                width: padding,
              ),
            ],
          ),
        ),
      ];

      List<Widget> soomyPageMiddleSection = [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < 26; i++)
                i.isEven ? const Spacer() : line(Direction.right, 2, 0),
            ],
          ),
        ),
        SizedBox(
          height: playerProgress.highestLevelReached == 3 ||
                  playerProgress.highestLevelReached == 2
              ? boxSize
              : boxSize - 20,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: padding + 15),
              box(3),
              for (int i = 0; i < 30; i++)
                i.isEven ? const Spacer() : line(Direction.up, 3, 0),
              box(2),
              SizedBox(
                width: padding + 10,
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              for (int i = 0; i < 25; i++)
                i.isEven ? const Spacer() : line(Direction.left, 4, 0),
            ],
          ),
        ),
      ];

      List<Widget> soomyPageBottomSection = [
        SizedBox(
          height: playerProgress.highestLevelReached == 4 ||
                  playerProgress.highestLevelReached == 5
              ? boxSize
              : boxSize - 20,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: padding + 10,
              ),
              box(4),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(-5, -40),
                  child: Transform.rotate(
                    angle: -0.15,
                    child: Row(
                      children: [
                        for (int i = 0; i < 35; i++)
                          i.isEven ? const Spacer() : line(Direction.up, 5, 0),
                        box(5),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: padding + 10,
                child: Transform.translate(
                    offset: Offset(-8, -boxSize / 2 - 10),
                    child: Transform.rotate(
                      angle: -0.2,
                      child: Row(
                        children: [
                          for (int i = 0; i < 10; i++)
                            i.isEven
                                ? const Spacer()
                                : line(Direction.up, 6, 0),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ];

      return LevelPage(
          topSection: soomyPageTopSection,
          middleSection: soomyPageMiddleSection,
          bottomSection: soomyPageBottomSection,
          topSectionFlex: soomyPageTopSectionFlex,
          middleSectionFlex: soomyPageMiddleSectionFlex,
          bottomSectionFlex: soomyPageBottomSectionFlex);
    }

//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//
//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//
//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//

    /// HOOMY PAGE
    /// PAGE2
    ///
    hoomyPage() {
      var hoomyPageTopSectionFlex = 3;
      var hoomyPageMiddleSectionFlex = 4;
      var hoomyPageBottomSectionFlex = 5;

      List<Widget> hoomyPageTopSection = [
        SizedBox(
          height: playerProgress.highestLevelReached == 4 ||
                  playerProgress.highestLevelReached == 5
              ? boxSize
              : boxSize - 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(width: padding + 20),
              box(10),
              for (int i = 0; i < 30; i++)
                i.isEven ? const Spacer() : line(Direction.down, 11, 0),
              box(11),
              for (int i = 0; i < 15; i++)
                i.isEven ? const Spacer() : line(Direction.down, 12, 0),
            ],
          ),
        ),
      ];

      List<Widget> hoomyPageMiddleSection = [
        Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < 30; i++)
                  i.isEven ? const Spacer() : line(Direction.left, 10, 0),
              ]),
        ),
        SizedBox(
          height: playerProgress.highestLevelReached == 3 ||
                  playerProgress.highestLevelReached == 2
              ? boxSize
              : boxSize - 20,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: padding + 15),
              box(8),
              for (int i = 0; i < 30; i++)
                i.isEven ? const Spacer() : line(Direction.up, 9, 0),
              box(9),
              SizedBox(
                width: padding + 10,
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < 30; i++)
                  i.isEven ? const Spacer() : line(Direction.left, 8, 0),
              ]),
        ),
      ];

      List<Widget> hoomyPageBottomSection = [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: padding,
              height: boxSize,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Spacer(),
                  line(Direction.up, 6, 0),
                  const Spacer(),
                  line(Direction.up, 6, 0),
                ],
              ),
            ),
            box(6),
            Expanded(
              child: Transform.translate(
                offset: const Offset(-10, -20),
                child: Transform.rotate(
                  angle: -0.3,
                  child: SizedBox(
                    height: playerProgress.highestLevelReached == 7
                        ? boxSize
                        : boxSize - 20,
                    child: Row(
                      children: [
                        for (int i = 0; i < 35; i++)
                          i.isEven ? const Spacer() : line(Direction.up, 7, 0),
                        box(7),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: padding),
          ],
        )
      ];

      return LevelPage(
          topSection: hoomyPageTopSection,
          middleSection: hoomyPageMiddleSection,
          bottomSection: hoomyPageBottomSection,
          topSectionFlex: hoomyPageTopSectionFlex,
          middleSectionFlex: hoomyPageMiddleSectionFlex,
          bottomSectionFlex: hoomyPageBottomSectionFlex);
    }

//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//
//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//
//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//

    /// SEA PAGE
    /// PAGE3
    ///
    seaPage() {
      var seaPageTopSectionFlex = 6;
      var seaPageMiddleSectionFlex = 9;
      var seaPageBottomSectionFlex = 9;

      List<Widget> seaPageTopSection = [
        SizedBox(
          height: boxSize,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: padding,
                height: boxSize,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    line(Direction.down, 12, 0),
                    const Spacer(),
                    line(Direction.down, 12, 0),
                    const Spacer()
                  ],
                ),
              ),
              box(12),
              const Spacer(),
            ],
          ),
        ),
      ];

      List<Widget> seaPageMiddleSection = [
        Expanded(
          child: Column(
            children: [
              for (int i = 0; i < 10; i++)
                i.isEven ? const Spacer() : line(Direction.left, 13, 0),
            ],
          ),
        ),
        SizedBox(
          height:
              playerProgress.highestLevelReached == 13 ? boxSize : boxSize - 20,
          child: Row(
            children: [
              SizedBox(
                width: padding + 15,
              ),
              box(13),
              const Spacer(),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              for (int i = 0; i < 10; i++)
                i.isEven ? const Spacer() : line(Direction.left, 14, 0),
            ],
          ),
        ),
        SizedBox(
          height:
              playerProgress.highestLevelReached == 13 ? boxSize : boxSize - 20,
          child: Row(
            children: [
              SizedBox(
                width: padding + 5,
              ),
              box(14),
              for (int i = 0; i < 30; i++)
                i.isEven ? const Spacer() : line(Direction.up, 17, 0),
              box(17),
              SizedBox(
                height: boxSize,
                width: padding + boxSize / 2 + 10,
                child: Row(
                  children: [
                    for (int i = 0; i < 20; i++)
                      i.isEven ? const Spacer() : line(Direction.up, 18, 0),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              for (int i = 0; i < 10; i++)
                i.isEven ? const Spacer() : line(Direction.left, 15, 0),
            ],
          ),
        ),
      ];

      List<Widget> seaPageBottomSection = [
        SizedBox(
          height:
              playerProgress.highestLevelReached == 15 ? boxSize : boxSize - 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: padding),
              box(15),
              Expanded(
                child: SizedBox(
                  height: boxSize,
                  child: Transform.translate(
                    offset: const Offset(-40, 120),
                    child: Transform.rotate(
                      angle: 0.8,
                      child: Row(children: [
                        for (int i = 0; i < 30; i++)
                          i.isEven ? const Spacer() : line(Direction.up, 16, 0),
                        box(16),
                        SizedBox(width: padding + boxSize / 2),
                      ]),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ];

      return LevelPage(
          topSection: seaPageTopSection,
          middleSection: seaPageMiddleSection,
          bottomSection: seaPageBottomSection,
          topSectionFlex: seaPageTopSectionFlex,
          middleSectionFlex: seaPageMiddleSectionFlex,
          bottomSectionFlex: seaPageBottomSectionFlex);
    }

//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//
//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//
//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//

    /// CITY PAGE
    /// PAGE4
    ///
    cityPage() {
      var cityPageTopSectionFlex = 6;
      var cityPageMiddleSectionFlex = 9;
      var cityPageBottomSectionFlex = 9;

      List<Widget> cityPageTopSection = [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            box(22),
            SizedBox(
              width: padding + 150,
              height: boxSize,
              child: Row(
                children: [
                  for (int i = 0; i < 20; i++)
                    i.isEven ? const Spacer() : line(Direction.up, 22, 0),
                ],
              ),
            ),
          ],
        ),
      ];

      List<Widget> cityPageMiddleSection = [
        Expanded(
          child: Column(
            children: [
              for (int i = 0; i < 20; i++)
                i.isEven ? const Spacer() : line(Direction.right, 22, 100),
            ],
          ),
        ),
        SizedBox(
          height:
              playerProgress.highestLevelReached == 13 ? boxSize : boxSize - 20,
          child: Row(
            children: [
              const Spacer(),
              box(21),
              SizedBox(
                height: boxSize,
                width: padding + 120,
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: padding,
                    height: boxSize,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        line(Direction.down, 18, 8),
                        const Spacer(),
                        line(Direction.down, 18, 6),
                        const Spacer()
                      ],
                    ),
                  ),
                  box(18),
                ],
              ),
              Column(
                children: [
                  for (int i = 0; i < 15; i++)
                    i.isEven ? line(Direction.right, 21, 65) : const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ];

      List<Widget> cityPageBottomSection = [
        Expanded(
          child: Stack(
            children: [
              Column(
                children: [
                  for (int i = 0; i < 15; i++)
                    i.isEven ? const Spacer() : line(Direction.left, 19, 0),
                ],
              ),
              Column(
                children: [
                  for (int i = 0; i < 15; i++)
                    i.isEven ? const Spacer() : line(Direction.right, 21, 65),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height:
              playerProgress.highestLevelReached == 15 ? boxSize : boxSize - 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: padding),
              box(19),
              Expanded(
                child: SizedBox(
                  height: boxSize,
                  child: Row(children: [
                    for (int i = 0; i < 30; i++)
                      i.isEven ? const Spacer() : line(Direction.up, 20, 0),
                    box(20),
                    SizedBox(width: padding + 40),
                  ]),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: bottomsheetHeight + 5 * padding),
      ];

      return LevelPage(
          topSection: cityPageTopSection,
          middleSection: cityPageMiddleSection,
          bottomSection: cityPageBottomSection,
          topSectionFlex: cityPageTopSectionFlex,
          middleSectionFlex: cityPageMiddleSectionFlex,
          bottomSectionFlex: cityPageBottomSectionFlex);
    }

//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//
//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//
//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//

    /// PURPLE WORLD PAGE
    /// PAGE5
    ///
    alianPage() {
      var alianPageTopSectionFlex = 6;
      var alianPageMiddleSectionFlex = 9;
      var alianPageBottomSectionFlex = 9;

      List<Widget> alianPageTopSection = [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            box(22),
            SizedBox(
              width: padding + 150,
              height: boxSize,
              child: Row(
                children: [
                  for (int i = 0; i < 20; i++)
                    i.isEven ? const Spacer() : line(Direction.up, 22, 0),
                ],
              ),
            ),
          ],
        ),
      ];

      List<Widget> alianPageMiddleSection = [
        Expanded(
          child: Column(
            children: [
              for (int i = 0; i < 20; i++)
                i.isEven ? const Spacer() : line(Direction.right, 22, 100),
            ],
          ),
        ),
        SizedBox(
          height:
              playerProgress.highestLevelReached == 13 ? boxSize : boxSize - 20,
          child: Row(
            children: [
              const Spacer(),
              box(21),
              SizedBox(
                height: boxSize,
                width: padding + 120,
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: padding,
                    height: boxSize,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        line(Direction.down, 18, 8),
                        const Spacer(),
                        line(Direction.down, 18, 6),
                        const Spacer()
                      ],
                    ),
                  ),
                  box(18),
                ],
              ),
              Column(
                children: [
                  for (int i = 0; i < 15; i++)
                    i.isEven ? line(Direction.right, 21, 65) : const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ];

      List<Widget> alianPageBottomSection = [
        Expanded(
          child: Stack(
            children: [
              Column(
                children: [
                  for (int i = 0; i < 15; i++)
                    i.isEven ? const Spacer() : line(Direction.left, 19, 0),
                ],
              ),
              Column(
                children: [
                  for (int i = 0; i < 15; i++)
                    i.isEven ? const Spacer() : line(Direction.right, 21, 65),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height:
              playerProgress.highestLevelReached == 15 ? boxSize : boxSize - 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: padding),
              box(19),
              Expanded(
                child: SizedBox(
                  height: boxSize,
                  child: Row(children: [
                    for (int i = 0; i < 30; i++)
                      i.isEven ? const Spacer() : line(Direction.up, 20, 0),
                    box(20),
                    SizedBox(width: padding + 40),
                  ]),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: bottomsheetHeight + 5 * padding),
      ];

      return LevelPage(
          topSection: alianPageTopSection,
          middleSection: alianPageMiddleSection,
          bottomSection: alianPageBottomSection,
          topSectionFlex: alianPageTopSectionFlex,
          middleSectionFlex: alianPageMiddleSectionFlex,
          bottomSectionFlex: alianPageBottomSectionFlex);
    }
//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//
//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//
//*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*//

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
        children: [
          soomyPage(),
          hoomyPage(),
          seaPage(),
          cityPage(),
          alianPage(),
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
            height: bottomsheetHeight,
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
                    center: Text('${playerProgress.highestLevelReached} / 15'),
                  ),
                ),
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



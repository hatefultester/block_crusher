// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:math';

import 'package:block_crusher/src/utils/characters.dart';
import 'package:block_crusher/src/game_internals/collector_game/components/sprite_block_component.dart';
import 'package:block_crusher/src/utils/maps.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../player_progress/player_progress.dart';
import '../level_selection/levels.dart';

import 'dart:async' as dart_async;

const ColorFilter greyscale = ColorFilter.matrix(<double>[
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
]);

double boxSize = 120;
double padding = 15;

double bottomsheetHeight = 60;

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    final playerProgress = context.watch<PlayerProgress>();

    var highestScore = playerProgress.highestLevelReached;

    var initialPage = playerProgress.highestLevelReached ~/ 6;

    final LevelSelectionBackground game =
        LevelSelectionBackground(initialPage.toInt());

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

    /// SOOMY PAGE
    /// PAGE1
    ///
    soomyPage() {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
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
                          i.isEven
                              ? const Spacer()
                              : line(Direction.down, 1, 0),
                        box(1),
                        SizedBox(
                          width: padding,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(children: [
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
                ))
              ]),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                                    i.isEven
                                        ? const Spacer()
                                        : line(Direction.up, 5, 0),
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
                ],
              ),
            ),
          ],
        ),
      );
    }

    /// HOOMY PAGE
    /// PAGE2
    ///
    hoomyPage() {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                          i.isEven
                              ? const Spacer()
                              : line(Direction.down, 11, 0),
                        box(11),
                        for (int i = 0; i < 15; i++)
                          i.isEven
                              ? const Spacer()
                              : line(Direction.down, 12, 0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          for (int i = 0; i < 30; i++)
                            i.isEven
                                ? const Spacer()
                                : line(Direction.left, 10, 0),
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
                            i.isEven
                                ? const Spacer()
                                : line(Direction.left, 8, 0),
                        ]),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Row(
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
                                i.isEven
                                    ? const Spacer()
                                    : line(Direction.up, 7, 0),
                              box(7),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: padding),
                ],
              ),
            ),
          ],
        ),
      );
    }

    /// SEA PAGE
    /// PAGE3
    ///
    seaPage() {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 0; i < 10; i++)
                          i.isEven
                              ? const Spacer()
                              : line(Direction.left, 13, 0),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: playerProgress.highestLevelReached == 13
                        ? boxSize
                        : boxSize - 20,
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
                          i.isEven
                              ? const Spacer()
                              : line(Direction.left, 14, 0),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: playerProgress.highestLevelReached == 13
                        ? boxSize
                        : boxSize - 20,
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
                                i.isEven
                                    ? const Spacer()
                                    : line(Direction.up, 18, 0),
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
                          i.isEven
                              ? const Spacer()
                              : line(Direction.left, 15, 0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: playerProgress.highestLevelReached == 15
                        ? boxSize
                        : boxSize - 20,
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
                                    i.isEven
                                        ? const Spacer()
                                        : line(Direction.up, 16, 0),
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
                ],
              ),
            ),
          ],
        ),
      );
    }

    /// CITY PAGE
    /// PAGE4
    ///
    cityPage() {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: boxSize,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Spacer(),
                        box(23),
                        SizedBox(
                          width: padding + 150,
                          height: boxSize,
                          child: Row(
                            children: [
                              for (int i = 0; i < 30; i++)
                                i.isEven
                                    ? const Spacer()
                                    : line(Direction.up, 24, 0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 0; i < 10; i++)
                          i.isEven
                              ? const Spacer()
                              : line(Direction.right, 23, 130),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: playerProgress.highestLevelReached == 22
                        ? boxSize
                        : boxSize - 20,
                    child: Row(
                      children: [
                        const Spacer(),
                        box(22),
                        SizedBox(
                          width: padding + 130,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 0; i < 10; i++)
                          i.isEven
                              ? const Spacer()
                              : line(Direction.right, 22, 100),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: playerProgress.highestLevelReached == 13
                        ? boxSize
                        : boxSize - 20,
                    child: Row(
                      children: [
                        SizedBox(
                          width: padding,
                          height: boxSize,
                          child: 
                          
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              line(Direction.up, 18, 0),
                              const Spacer(),
                              line(Direction.up, 18,0),
                              const Spacer()
                            ],
                          ),
                        ),
                        box(18),
                        const Spacer(),
                        box(21),
                        SizedBox(
                          height: boxSize,
                          width: padding + 80,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            for (int i = 0; i < 10; i++)
                              i.isEven
                                  ? const Spacer()
                                  : line(Direction.left, 19, 0),
                          ],
                        ),
                        Column(
                          children: [
                            for (int i = 0; i < 10; i++)
                              i.isEven
                                  ? const Spacer()
                                  : line(Direction.right, 21, 50),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            for (int i = 0; i < 30; i++)
                              i.isEven
                                  ? const Spacer()
                                  : line(Direction.left, 19, 0),
                          ],
                        ),
                        Column(
                          children: [
                            for (int i = 0; i < 30; i++)
                              i.isEven
                                  ? const Spacer()
                                  : line(Direction.right, 21, 50),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: playerProgress.highestLevelReached == 15
                        ? boxSize
                        : boxSize - 20,
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
                                i.isEven
                                    ? const Spacer()
                                    : line(Direction.up, 20, 0),
                              box(20),
                              SizedBox(width: padding + 30),
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: bottomsheetHeight + 5 * padding),
                ],
              ),
            ),
          ],
        ),
      );
    }

    /// PURPLE WORLD PAGE
    /// PAGE5
    ///
    purpleWorldPage() {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: padding,
                          height: boxSize,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Spacer(),
                              line(Direction.down, 12, 0),
                              const Spacer(),
                              line(Direction.down, 12, 0),
                            ],
                          ),
                        ),
                        box(12),
                        const Spacer(),
                      ]),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < 60; i++)
                    i.isEven ? const Spacer() : line(Direction.left, 13, 0),
                ],
              ),
            ),
            Expanded(
              child: Transform.rotate(
                angle: 0.45,
                child: Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.rotate(
                        angle: -0.45,
                        child: box(13),
                      ),
                      for (int i = 0; i < 30; i++)
                        i.isEven ? const Spacer() : line(Direction.up, 14, 0),
                      Transform.rotate(
                        angle: -0.45,
                        child: box(14),
                      ),
                      SizedBox(
                        width: padding,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
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
      final initPage = playerProgress.highestLevelReached ~/ 6;

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
          purpleWorldPage(),
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

//// GAME ON THE BACKGROUND, SIMPLE JUST IMAGES
///
///

class LevelSelectionBackground extends FlameGame {
  //late DartAsync.Timer _timer;

  final int initialPage;
  late MapSpriteComponent map;

  LevelSelectionBackground(this.initialPage) {
    map = MapSpriteComponent(initialPage);
  }

  addMap() async {
    await add(map);
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    _startTimer();
  }

  _startTimer() async {
    //int counter = 0;
    // _timer = DartAsync.Timer.periodic(const Duration(milliseconds: 500),
    //     (timer) async {
    //   if (!(AppLifecycleObserver.appState == AppLifecycleState.paused)) {
    //     counter++;
    //     await add(MiniSpriteComponent());
    //     await Future.delayed(Duration(milliseconds: 100));
    //     await add(MiniSpriteComponent());
    //     await Future.delayed(Duration(milliseconds: 250));
    //     await add(MiniSpriteComponent());
    //   }
    // });
  }
}

class MapSpriteComponent extends SpriteComponent
    with HasGameRef<LevelSelectionBackground> {
  final int initialMap;

  bool jumperLoaded = false;

  String selectedMap = '';

  MapSpriteComponent(this.initialMap);

  @override
  dart_async.Future<void>? onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(pageViewMaps[initialMap]);
    size = Vector2(gameRef.size.x, gameRef.size.y);
  }

  changeBackground(int a) async {
    // await Future.delayed(const Duration(milliseconds: 500));
    // final effect = OpacityEffect.to(
    //   0.1,
    //   EffectController(duration: 0.7),
    // );
    // final oppacityBack = OpacityEffect.to(
    //   1,
    //   EffectController(duration: 0.4),
    // );
    // await add(effect);

    if (selectedMap == pageViewMaps[a] && jumperLoaded) {
      return;
    }

    selectedMap == pageViewMaps[a];

    sprite = await gameRef.loadSprite(pageViewMaps[a]);
    // await add(oppacityBack);
  }
}

class MiniSpriteComponent extends SpriteComponent
    with HasGameRef<LevelSelectionBackground> {
  final double _scale = 6;

  MiniSpriteComponent();

  @override
  dart_async.Future<void>? onLoad() async {
    await super.onLoad();

    int xMax = (gameRef.size.x - size.x - 250).toInt();
    int yMax = (gameRef.size.y).toInt();

    position = Vector2(
      (Random().nextInt(xMax) + 100),
      (Random().nextInt(yMax) + 0),
    );

    await _sprite();
    await Future.delayed(const Duration(milliseconds: 300));
    final effect = OpacityEffect.to(
      0.1,
      EffectController(duration: 1.5),
      onComplete: (() {
        removeFromParent();
      }),
    );
    final sizeEffect =
        ScaleEffect.by(Vector2(1.2, 1.2), EffectController(duration: 1.5));
    final randomNum = Random().nextInt(10);
    final rotationEffect = RotateEffect.by(
        randomNum.isEven ? tau / 4 : -tau / 4, EffectController(duration: 1.5));
    await add(sizeEffect);
    await add(rotationEffect);
    await add(effect);
  }

  _sprite() async {
    sprite = await gameRef.loadSprite(imageSource[0]['source']);
    size = imageSource[0]['size'] * _scale;
  }

  double increasment = 1;
}

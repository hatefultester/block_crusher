// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:math';

import 'package:block_crusher/src/app_lifecycle/app_lifecycle.dart';
import 'package:block_crusher/src/game_internals/characters.dart';
import 'package:block_crusher/src/game_internals/collector_game/components/sprite_block_component.dart';
import 'package:block_crusher/src/game_internals/maps.dart';
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
import '../style/palette.dart';
import 'levels.dart';

import 'dart:async' as DartAsync;

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

    final palette = context.watch<Palette>();
    final playerProgress = context.watch<PlayerProgress>();

    var highestScore = playerProgress.highestLevelReached;
    var initialPage = playerProgress.highestLevelReached ~/ 3;

    final LevelSelectionBackground game =
        LevelSelectionBackground(initialPage.toInt());

    double boxSize = 120;
    double padding = 15;

    line(Direction direction, int lineId) {
      final lineColor = playerProgress.highestLevelReached > lineId
          ? Colors.yellow.shade600
          : playerProgress.highestLevelReached == lineId
              ? Colors.white70
              : Colors.white24;

      final double lineThickness = playerProgress.highestLevelReached > lineId
          ? 5
          : playerProgress.highestLevelReached == lineId
              ? 3
              : 2;

      if (direction == Direction.down) {
        return Column(
          children: [
            const Spacer(),
            Container(
              color: lineColor,
              height: lineThickness,
              width: 4,
            ),
            SizedBox(
              height: boxSize / 2,
            )
          ],
        );
      }

      if (direction == Direction.up) {
        return Column(
          children: [
            SizedBox(
              height: boxSize / 2,
            ),
            Container(
              color: lineColor,
              height: lineThickness,
              width: 4,
            ),
            const Spacer(),
          ],
        );
      }

      if (direction == Direction.right) {
        return Row(
          children: [
            const Spacer(),
            Container(
              color: lineColor,
              height: 5,
              width: lineThickness,
            ),
            SizedBox(width: (boxSize / 2 + padding))
          ],
        );
      }

      if (direction == Direction.left) {
        return Row(
          children: [
            SizedBox(width: (boxSize / 2 + padding)),
            Container(
              color: lineColor,
              height: 5,
              width: lineThickness,
            ),
            const Spacer(),
          ],
        );
      }

      return const SizedBox.shrink();
    }

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

    background() {
      return GameWidget(game: game);
    }

    miniBox(int levelId, int gameId) {
      return InkWell(
        onTap: () =>
            {GoRouter.of(context).go('/play/session/${levelId}/${gameId}')},
        child: SizedBox(
          width: double.infinity,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text('CoinPicker'),
              ),
            ],
          ),
        ),
      );
    }

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
          width: boxSize,
          height: boxSize,
          child: Image.asset(
              'assets/images/${imageSource[level.levelId]['source']}'));
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

                    // todo tohle kdyz ten level vyhraje...
                    if (false) {
                      // bonusLevelsDialog(levelId);
                    } else {
                      GoRouter.of(context)
                          .go('/play/session/${level.levelId}/0');
                    }
                  },
                  child: child),
              won
                  ? SizedBox(
                      width: boxSize,
                      height: boxSize,
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

    learningPage() {
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
                        i.isEven ? const Spacer() : line(Direction.left, 0),
                    ],
                  )),
                  SizedBox(
                    height: boxSize,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: padding,
                        ),
                        box(0),
                        for (int i = 0; i < 30; i++)
                          i.isEven ? const Spacer() : line(Direction.down, 1),
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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (int i = 0; i < 60; i++)
                      i.isEven ? const Spacer() : line(Direction.right, 2),
                  ]),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      box(2),
                      SizedBox(
                        width: padding,
                        height: boxSize,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Spacer(),
                            line(Direction.up, 3),
                            const Spacer(),
                            line(Direction.up, 3),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    beginnerPage() {
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
                        const Spacer(),
                        box(5),
                        SizedBox(
                          width: padding,
                          height: boxSize,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              line(Direction.down, 6),
                              const Spacer(),
                              line(Direction.down, 6),
                              const Spacer()
                            ],
                          ),
                        )
                      ]),
                ],
              ),
            ),
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (int i = 0; i < 60; i++)
                      i.isEven ? const Spacer() : line(Direction.right, 5),
                  ]),
            ),
            Expanded(
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
                        line(Direction.up, 3),
                        const Spacer(),
                        line(Direction.up, 3),
                      ],
                    ),
                  ),
                  box(3),
                  for (int i = 0; i < 30; i++)
                    i.isEven ? const Spacer() : line(Direction.up, 4),
                  box(4),
                  SizedBox(
                    width: padding,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    intermediatePage() {
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              line(Direction.down, 6),
                              const Spacer(),
                              line(Direction.down, 6),
                              const Spacer()
                            ],
                          ),
                        ),
                        box(6),
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
                      i.isEven ? const Spacer() : line(Direction.left, 7),
                  ]),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: padding,
                  ),
                  box(7),
                  for (int i = 0; i < 30; i++)
                    i.isEven ? const Spacer() : line(Direction.up, 8),
                  box(8),
                  SizedBox(
                    width: padding,
                    height: boxSize,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        line(Direction.up, 9),
                        const Spacer(),
                        line(Direction.up, 9),
                        const Spacer()
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

    advancedPage() {
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
                        const Spacer(),
                        box(9),
                        SizedBox(
                          width: padding,
                          height: boxSize,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Spacer(),
                              line(Direction.down, 12),
                              const Spacer(),
                              line(Direction.down, 12),
                            ],
                          ),
                        ),
                      ]),
                ],
              ),
            ),
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (int i = 0; i < 60; i++)
                      i.isEven ? const Spacer() : line(Direction.right, 11),
                  ]),
            ),
            Expanded(
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
                        line(Direction.up, 9),
                        const Spacer(),
                        line(Direction.up, 9),
                      ],
                    ),
                  ),
                  box(10),
                  for (int i = 0; i < 30; i++)
                    i.isEven ? const Spacer() : line(Direction.up, 10),
                  box(11),
                  SizedBox(
                    width: padding,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    jediPage() {
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
                              line(Direction.down, 12),
                              const Spacer(),
                              line(Direction.down, 12),
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
                      i.isEven ? const Spacer() : line(Direction.left, 13),
                  ]),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: padding,
                  ),
                  box(13),
                  for (int i = 0; i < 30; i++)
                    i.isEven ? const Spacer() : line(Direction.up, 14),
                  box(14),
                  SizedBox(
                    width: padding,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    levelsPageView() {
      final initPage = playerProgress.highestLevelReached ~/ 3;

      final controller = PageController(initialPage: initPage, keepPage: false);

      pageJumper(initPage, controller);

      return PageView(
        onPageChanged: (page) => {
          game.map.changeBackground(page),
        },
        controller: controller,
        children: [
          learningPage(),
          beginnerPage(),
          intermediatePage(),
          advancedPage(),
          jediPage(),
        ],
      );
    }

    infoBox() {
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
                    percent: playerProgress.highestLevelReached / 15,
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

    return Scaffold(
      body: Stack(
        children: [
          background(),
          levelsPageView(),
          topAppLayer(),
          infoBox(),
        ],
      ),
    );
  }

  pageJumper(int page, PageController controller) async {
    await Future.delayed(const Duration(milliseconds: 500));
    controller.jumpToPage(page);
  }
}

class LevelSelectionBackground extends FlameGame {
  late DartAsync.Timer _timer;

  final int initialPage;
  late MapSpriteComponent map;

  LevelSelectionBackground(this.initialPage) {
    map = MapSpriteComponent(initialPage);
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    _startTimer();

    await add(map);
  }

  _startTimer() async {
    int counter = 0;
    _timer = DartAsync.Timer.periodic(const Duration(milliseconds: 500),
        (timer) async {
      if (!(AppLifecycleObserver.appState == AppLifecycleState.paused)) {
        counter++;
        await add(MiniSpriteComponent());
        await Future.delayed(Duration(milliseconds: 100));
        await add(MiniSpriteComponent());
        await Future.delayed(Duration(milliseconds: 250));
        await add(MiniSpriteComponent());
      }
    });
  }
}

class MapSpriteComponent extends SpriteComponent
    with HasGameRef<LevelSelectionBackground> {
  @override
  final int initialMap;

  MapSpriteComponent(this.initialMap);

  @override
  DartAsync.Future<void>? onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(maps[initialMap]);
    size = Vector2(gameRef.size.x, gameRef.size.y);
  }

  changeBackground(int a) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final effect = OpacityEffect.to(
      0.1,
      EffectController(duration: 0.7),
    );
    final oppacityBack = OpacityEffect.to(
      1,
      EffectController(duration: 0.4),
    );
    await add(effect);

    await Future.delayed(const Duration(milliseconds: 300));
    sprite = await gameRef.loadSprite(maps[a]);
    await add(oppacityBack);
  }
}

class MiniSpriteComponent extends SpriteComponent
    with HasGameRef<LevelSelectionBackground> {
  final double _scale = 6;

  MiniSpriteComponent();

  @override
  DartAsync.Future<void>? onLoad() async {
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

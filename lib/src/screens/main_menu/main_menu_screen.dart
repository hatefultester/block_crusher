// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/google_play/games_services/games_services.dart';
import 'package:block_crusher/src/screens/main_menu/button.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/settings/audio/sounds.dart';
import 'package:block_crusher/src/utils/maps.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../settings/settings.dart';
import '../../style/palette.dart';
import '../../style/responsive_screen.dart';

import 'dart:async' as dart_async;

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final gamesServicesController = context.watch<GamesServicesController?>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    mainArea() {
      return Center(
        child: Transform.rotate(
          angle: -0.45,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black, Colors.transparent],
              ),
            ),
            child: Text(
              'Hoomy Hoo advantures'.toUpperCase(),
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
              textWidthBasis: TextWidthBasis.longestLine,
            ),
          ),
        ),
      );
    }


    menuArea() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [


          MovingButton(title: 'p l a y', route : '/play', millisecondSpeed: 7, x: Direction.right),

          const SizedBox(
            height: 20,
          ),

          MovingButton(title: 's e t t i n g s', route : '/settings', millisecondSpeed: 13,),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ValueListenableBuilder<bool>(
                valueListenable: settingsController.muted,
                builder: (context, muted, child) {
                  return IconButton(
                    onPressed: () => settingsController.toggleMuted(),
                    icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
                    iconSize: 30,
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),

        ],
      );
    }

    // ignore: unused_element
    gradientWidget() {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.red,
            Colors.red.shade300,
            Colors.yellow,
            Colors.lime,
            Colors.orange,
            Colors.green,
            Colors.blue,
            Colors.white
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
      );
    }

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: Stack(
        children: [
          GameWidget(game: MainBackgroundGame()),
          //gradientWidget(),
          ResponsiveScreen(
            mainAreaProminence: 0.35,
            squarishMainArea: mainArea(),
            rectangularMenuArea: menuArea(),
          ),
        ],
      ),
    );
  }
}



class MainBackgroundGame extends FlameGame {
  //late dart_async.Timer _timer;

  //int _counter = 0;

  final MapSpriteComponent map = MapSpriteComponent(7);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    _startTimer();

    await add(map);
  }

  _startTimer() async {

  }
}

class MapSpriteComponent extends SpriteComponent
    with HasGameRef<MainBackgroundGame> {
  final int initialMap;

  MapSpriteComponent(this.initialMap);

  @override
  dart_async.Future<void>? onLoad() async {
    await super.onLoad();

// natvrdo
    sprite = await gameRef.loadSprite('backgrounds/sea_background.png');
    size = Vector2(gameRef.size.x, gameRef.size.y);
  }

  changeBackground(int a) async {
    if (a == 1) {
      a = 5;
    }

    await Future.delayed(const Duration(milliseconds: 300));
    final effect = OpacityEffect.to(
      0,
      EffectController(duration: 2),
    );
    final oppacityBack = OpacityEffect.to(
      1,
      EffectController(duration: 1),
    );

    await add(effect);

    await Future.delayed(const Duration(seconds: 2));
    sprite = await gameRef.loadSprite(maps[a]);
    await add(oppacityBack);
    await Future.delayed(const Duration(seconds: 1));
  }
}
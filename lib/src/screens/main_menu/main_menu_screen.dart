// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/google_play/games_services/games_services.dart';
import 'package:block_crusher/src/screens/main_menu/background.dart';
import 'package:block_crusher/src/screens/main_menu/button.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/style/snack_bar.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
                'H o o m y   H o o'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                ),
                textWidthBasis: TextWidthBasis.longestLine,
              ),
            ),Container(
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
                'A d v a n t u r e s'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 38,
                  color: Colors.white,
                ),
                textWidthBasis: TextWidthBasis.longestLine,
              ),
            ),
          ],
        ),
      );
    }


    menuArea() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [


          const MovingButton(title: 'p l a y', route : '/play', millisecondSpeed: 7, x: Direction.right),

          const SizedBox(
            height: 20,
          ),

          const MovingButton(title: 's e t t i n g s', route : '/settings', millisecondSpeed: 13,),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ValueListenableBuilder<bool>(
                valueListenable: settingsController.muted,
                builder: (context, muted, child) {
                  return IconButton(
                    onPressed: () => {settingsController.toggleMuted(),
                    if (!muted) showSnackBar('Sounds muted') else showSnackBar('Sounds activated')
                    },
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


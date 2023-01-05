// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:animated_background/animated_background.dart';
import 'package:block_crusher/src/app_lifecycle/app_lifecycle.dart';
import 'package:block_crusher/src/game_internals/maps.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../games_services/games_services.dart';
import '../settings/settings.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

import 'dart:async' as DartAsync;

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  final ParticleOptions _particles = const ParticleOptions(
    image: Image(
      image: AssetImage('assets/images/characters_skill_game/5_1000x1000.png'),
      width: 50,
      height: 100,
    ),
    spawnOpacity: 0.0,
    opacityChangeRate: 0.25,
    minOpacity: 0.3,
    maxOpacity: 0.4,
    particleCount: 10,
    spawnMaxRadius: 20.0,
    spawnMaxSpeed: 15.0,
    spawnMinSpeed: 10,
    spawnMinRadius: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final gamesServicesController = context.watch<GamesServicesController?>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    TickerProvider tickerProvider = this;

    mainArea() {
      return Center(
        child: Transform.rotate(
          angle: -0.45,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black, Colors.transparent],
              ),
            ),
            child: Text(
              'Erratic connector'.toUpperCase(),
              style: const TextStyle(
                fontSize: 45,
                color: Colors.white,
              ),
              textWidthBasis: TextWidthBasis.longestLine,
            ),
          ),
        ),
      );
    }

    List<Widget> leaderBoards() {
      if (gamesServicesController != null) {
        return [
          const SizedBox(
            height: 20,
          ),
          _hideUntilReady(
            ready: gamesServicesController.signedIn,
            child: ElevatedButton(
              onPressed: () => gamesServicesController.showAchievements(),
              child: const Text('A C H I E V M E N T S'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _hideUntilReady(
            ready: gamesServicesController.signedIn,
            child: ElevatedButton(
              onPressed: () => gamesServicesController.showLeaderboard(),
              child: const Text('L E A D E R B O A R D'),
            ),
          ),
        ];
      } else {
        return [];
      }
    }

    menuArea() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              audioController.playSfx(SfxType.buttonTap);
              GoRouter.of(context).go('/play');
            },
            child: Center(child: Text('p l a y'.toUpperCase())),
          ),
          Column(
            children: leaderBoards(),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              audioController.playSfx(SfxType.buttonTap);
              GoRouter.of(context).go('/settings');
            },
            child: Center(child: Text('s e t t i n g s'.toUpperCase())),
          ),
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

  Widget _hideUntilReady({required Widget child, required Future<bool> ready}) {
    return FutureBuilder<bool>(
      future: ready,
      builder: (context, snapshot) {
        return Visibility(
          visible: snapshot.data ?? false,
          maintainState: true,
          maintainSize: true,
          maintainAnimation: true,
          child: child,
        );
      },
    );
  }
}

class MainBackgroundGame extends FlameGame {
  late DartAsync.Timer _timer;

  int _counter = 0;

  final MapSpriteComponent map = MapSpriteComponent(0);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    _startTimer();

    await add(map);
  }

  _startTimer() async {
    _timer =
        DartAsync.Timer.periodic(const Duration(seconds: 7), (timer) async {
      if (_counter == 2) {
        _counter = 0;
      } else {
        _counter++;
      }
      if (!(AppLifecycleObserver.appState == AppLifecycleState.paused)) {
        map.changeBackground(_counter);
      }
    });
  }
}

class MapSpriteComponent extends SpriteComponent
    with HasGameRef<MainBackgroundGame> {
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

/// Prevents the game from showing game-services-related menu items
/// until we're sure the player is signed in.
///
/// This normally happens immediately after game start, so players will not
/// see any flash. The exception is folks who decline to use Game Center
/// or Google Play Game Services, or who haven't yet set it up.

/*
ResponsiveScreen(
        mainAreaProminence: 0.45,
        squarishMainArea: Center(
          child: Transform.rotate(
            angle: -0.1,
            child: const Text(
              'Flutter Game Template!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 55,
                height: 1,
              ),
            ),
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                audioController.playSfx(SfxType.buttonTap);
                GoRouter.of(context).go('/play');
              },
              child: const Text('Play'),
            ),
            _gap,
            if (gamesServicesController != null) ...[
              _hideUntilReady(
                ready: gamesServicesController.signedIn,
                child: ElevatedButton(
                  onPressed: () => gamesServicesController.showAchievements(),
                  child: const Text('Achievements'),
                ),
              ),
              _gap,
              _hideUntilReady(
                ready: gamesServicesController.signedIn,
                child: ElevatedButton(
                  onPressed: () => gamesServicesController.showLeaderboard(),
                  child: const Text('Leaderboard'),
                ),
              ),
              _gap,
            ],
            ElevatedButton(
              onPressed: () => GoRouter.of(context).push('/settings'),
              child: const Text('Settings'),
            ),
            _gap,
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: ValueListenableBuilder<bool>(
                valueListenable: settingsController.muted,
                builder: (context, muted, child) {
                  return IconButton(
                    onPressed: () => settingsController.toggleMuted(),
                    icon: Icon(muted ? Icons.volume_off : Icons.volume_up),
                  );
                },
              ),
            ),
            _gap,
            const Text('Music by Mr Smith'),
            _gap,
          ],
        ),
      ),
      */

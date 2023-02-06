
import 'dart:math';

import 'package:block_crusher/src/utils/in_game_characters.dart';
import 'package:block_crusher/src/utils/maps.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';

//// GAME ON THE BACKGROUND, SIMPLE JUST IMAGES
///
///

class LevelSelectionBackground extends FlameGame {
  //late DartAsync.Timer _timer;

  final int initialPage;
  late MapSpriteComponent map;

  LevelSelectionBackground(this.initialPage) {
    map = MapSpriteComponent(initialPage);
    addMap();
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
  Future<void>? onLoad() async {
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
  Future<void>? onLoad() async {
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
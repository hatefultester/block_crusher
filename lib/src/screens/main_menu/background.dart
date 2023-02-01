
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';

import 'dart:async' as dart_async;

class MainBackgroundGame extends FlameGame {
  late dart_async.Timer _timer;

  int _counter = 0;

  final MapSpriteComponent map = MapSpriteComponent(7);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    _startTimer();

    await add(map);
  }

  _startTimer() async {
    _timer = dart_async.Timer.periodic(const Duration(seconds: 10), (timer) async {
      _counter++;
      if(_counter == map.myMaps.length) _counter = 0;
      await map.changeBackground(_counter);
    });
  }

  @override
  void onRemove() {
    super.onRemove();

    _timer.cancel();
  }
}

class MapSpriteComponent extends SpriteComponent
    with HasGameRef<MainBackgroundGame> {
  final int initialMap;

  List<String> myMaps = [
    'backgrounds/sea_background.png',
    'backgrounds/sahara_background.png',
    'backgrounds/dragon_backgroud.png',
    'backgrounds/palm_background.png',
  ];

  MapSpriteComponent(this.initialMap);

  @override
  dart_async.Future<void>? onLoad() async {
    await super.onLoad();

// natvrdo
    sprite = await gameRef.loadSprite(myMaps[0]);
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
    sprite = await gameRef.loadSprite(myMaps[a]);
    await add(oppacityBack);
    await Future.delayed(const Duration(seconds: 1));
  }

}

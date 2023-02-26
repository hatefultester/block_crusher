import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';

import 'dart:async' as dart_async;

import '../../game/collector_game_helper.dart';
import '../../services/app_lifecycle.dart';

class MainBackgroundGame extends FlameGame {
  late dart_async.Timer _timer;

  int _counter = 0;
  int _setCount = 0;

  final MapSpriteComponent map = MapSpriteComponent(7);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    _startTimer();

    await add(map);
  }

  _startTimer() async {
    await add(AnimatedCharacter(_setCount.toString()));

    if(AppLifecycleObserver.appState == AppLifecycleState.paused) return;

    _setCount++;
    _timer =
        dart_async.Timer.periodic(const Duration(seconds: 5), (timer) async {
      await add(AnimatedCharacter(_setCount.toString()));
      _setCount++;
      if(_setCount == 7) _setCount = 0;
      if (_setCount.isEven) {
        _counter++;
        if (_counter == map.myMaps.length) _counter = 0;
        await map.changeBackground(_counter);
      }
    });
  }

  @override
  void onRemove() {
    super.onRemove();

    _timer.cancel();
  }
}

Map<String, dynamic> _animatedCharactersAssets = {
  '0': {
    'source': 'in_app/final_win_character.png',
    'size': Vector2(10 * 3, 11.4 * 3),
  },
  '1': {
    'source': 'characters/object/1000x1000/satisfied_bag.png',
    'size': Vector2(10 * 3, 10 * 3),
  },
  '2': {
    'goal': 8,
    'source': 'food/300x275/mufin.png',
    'winCharacterReferenceNameId': 'city3',
    'size': Vector2(3 * 3 * 2.3, 2.75 * 3 * 2.3),
  },
  '3': {
    'source': 'characters/hoomy_with_weapon/1000x666/pink_hoomy_with_flail.png',
    'size': Vector2(10 * 4.3, 6.66 * 4.3),
  },
  '4': {
    'source': 'characters/fish/1300x928_octopus.png',
    'size': Vector2(13*2, 9.28*2),
  },
  '5': {
    'source': 'characters/1000x600/soomy-3.png',
    'size': Vector2(12*2, 8.4*2),
  },
  '6': {
    'source': 'characters/hoomy/1000x666/pirate_hoomy.png',
    'size': Vector2(10 * 3.3, 6.66 * 3.3),
  },
};

class AnimatedCharacter extends SpriteComponent
    with HasGameRef<MainBackgroundGame> {
  late String _animatedCharacterPath;
  late Vector2 _animatedCharacterSize;

  late double _yOffset;
  late double _yOriginalPosition;

  Direction _yDirection;

  final String stringdex;

  AnimatedCharacter(this.stringdex, {Direction yDirection = Direction.down}) : _yDirection = yDirection {

    _animatedCharacterPath = _animatedCharactersAssets[stringdex]['source'];
    _animatedCharacterSize =  _animatedCharactersAssets[stringdex]['size'];
  }

  @override
  onLoad() async {
    sprite = await gameRef.loadSprite(_animatedCharacterPath);
    size = _animatedCharacterSize * 5;
    position = Vector2(-20, gameRef.size.y / 2 - size.y);
    _yOffset = 10;
    _yOriginalPosition = position.y;
  }

  @override
  update(double dt) {
    x += 3;

    if (_yDirection == Direction.down) {
      y+= 5;
    }
    if (_yDirection == Direction.up) {
      y-= 5;
    }

    if(y > _yOriginalPosition + _yOffset) {
      _yDirection = Direction.up;
      _yOffset*=2;
    }
    if(y < _yOriginalPosition - _yOffset) {
      _yDirection = Direction.down;
      _yOffset*=2;
    }

    if(x > (gameRef.size.x + size.x)) {
      removeFromParent();
    }
  }
}

class MapSpriteComponent extends SpriteComponent
    with HasGameRef<MainBackgroundGame> {
  final int initialMap;

  List<String> myMaps = [
    'backgrounds/sea_background.png',
    'backgrounds/sahara_background.png',
    //'backgrounds/dragon_backgroud.png',
    //'backgrounds/palm_background.png',
  ];

  MapSpriteComponent(this.initialMap);

  @override
  dart_async.Future<void>? onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(myMaps[0]);
    size = Vector2(gameRef.size.x, gameRef.size.y);
  }

  changeBackground(int a) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final effect = OpacityEffect.to(
      0,
      EffectController(duration: 1.5),
    );

    final opacityBack = OpacityEffect.to(
      1,
      EffectController(duration: 1),
    );

    await add(effect);

    await Future.delayed(const Duration(seconds: 2));

    sprite = await gameRef.loadSprite(myMaps[a]);

    await add(opacityBack);

    await Future.delayed(const Duration(seconds: 1));
  }
}

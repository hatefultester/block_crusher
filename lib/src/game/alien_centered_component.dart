
import 'package:block_crusher/src/game/sprite_block_component.dart';
import 'package:block_crusher/src/game/collector_game_helper.dart';
import 'package:block_crusher/src/database/in_game_characters.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'world_type.dart';
import 'collector_game.dart';

import 'dart:async' as async_dart;

class AlienCenteredComponent extends SpriteComponent
    with HasGameRef<BlockCrusherGame>, CollisionCallbacks,  Tappable {


  final double _scale = 15.0;

  final WorldType difficulty = WorldType.alien;

  int characterId = 0;

  int tapCounter = 0;

  late GameMode gameMode;

  Direction direction = Direction.down;

  async_dart.Timer? timer;

  AlienCenteredComponent();

  _sprite() async {
    if(gameRef.gameMode == GameMode.alien)
    {
      final isAnimated = imageSource[difficulty.index][characterId]['isAnimated'];
      if (isAnimated == true) {
        _toggleAnimation();
      } else {
        timer?.cancel();
      }
    }

    if (imageSource[difficulty.index][characterId] != null) {
      sprite = await gameRef
          .loadSprite(imageSource[difficulty.index][characterId]['source']);
      size = imageSource[difficulty.index][characterId]['size']* _scale;
    }

    position = Vector2(gameRef.size.x/2 - size.x/2, gameRef.size.y/2 + 30);
  }

  bool tapped = false;


  _toggleAnimation() {
    if (timer != null) {
      if (timer!.isActive) {
        timer!.cancel();
      }
    }

    int counter = 0;

    timer = async_dart.Timer.periodic(const Duration(milliseconds: 300), (timer){
      final previousSize = size;
      if (counter.isEven) {
        loadAssetOne();
      } else {
        loadAssetTwo();
      }
      move(previousSize);
      counter++;
    },);
  }

  move(Vector2 previous) {
    position = Vector2(gameRef.size.x/2 - size.x/2, gameRef.size.y/2);
  }

  loadAssetOne() async {
    sprite = await gameRef.loadSprite(imageSource[difficulty.index][characterId]['animationAssets'][0]['source']);
    size = imageSource[difficulty.index][characterId]['animationAssets'][0]['size'] * _scale;
  }

  loadAssetTwo() async {
    sprite = await gameRef.loadSprite(imageSource[difficulty.index][characterId]['animationAssets'][1]['source']);
    size = imageSource[difficulty.index][characterId]['animationAssets'][1]['size'] * _scale;

  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    gameMode = gameRef.gameMode;
    await _sprite();
    await add(CircleHitbox()..shouldFillParent);
  }

  Future<void> setLevel(int id) async {
    characterId = id;
    await _sprite();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is SpriteBlockComponent) {
      if(!other.isDragging) return;
      if(other.characterId != characterId) return;

      characterId++;
      OpacityEffect opacityBack = OpacityEffect.to(1, EffectController(duration: 0.1));
      OpacityEffect effect = OpacityEffect.to(0.2, EffectController(duration: 0.5), onComplete: () => {
        _sprite(), add(opacityBack),
      });
      add(effect);
      other.removeFromParent();
    }
  }


}

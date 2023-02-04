
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/soomy_land/sprite_block_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/levels.dart';
import 'package:block_crusher/src/utils/in_game_characters.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import '../../../../level_logic/level_states/collector_game/world_type.dart';
import '../../collector_game.dart';

class AlienCenteredComponent extends SpriteComponent
    with HasGameRef<BlockCrusherGame>, CollisionCallbacks,  Tappable {


  final double _scale = 15.0;

  final WorldType difficulty = WorldType.alien;

  int characterId = 0;

  int tapCounter = 0;

  late GameMode gameMode;

  Direction direction = Direction.down;

  AlienCenteredComponent();

  _sprite() async {
    if (imageSource[difficulty.index][characterId] != null) {
      sprite = await gameRef
          .loadSprite(imageSource[difficulty.index][characterId]['source']);
      size = imageSource[difficulty.index][characterId]['size']* _scale;
    }

    position = Vector2(gameRef.size.x/2 - size.x/2, gameRef.size.y/2 + 30);
  }

  bool tapped = false;

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
  //    if(other.characterId != characterId) return;

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

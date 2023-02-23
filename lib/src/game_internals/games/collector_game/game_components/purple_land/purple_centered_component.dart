
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/purple_land/purple_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/util/collision_detector.dart';
import 'package:block_crusher/src/utils/in_game_characters.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../../../level_logic/level_states/collector_game/world_type.dart';
import '../../collector_game.dart';

class PurpleCenteredComponent extends SpriteComponent
    with HasGameRef<BlockCrusherGame>, CollisionCallbacks,  Tappable {


  final double _scale = 15.0;

  final WorldType difficulty = WorldType.purpleWorld;

  int characterId = 0;

  int tapCounter = 0;

  late GameMode gameMode;

  Direction direction = Direction.down;

  PurpleCenteredComponent();

  _sprite() async {
      if (imageSource[difficulty.index][characterId] != null) {
        sprite = await gameRef
            .loadSprite('enemy/trippie/1000x850/trippie_closed_mouth.png');
        size = Vector2(10,8.5)* _scale;
      }


    position = Vector2(gameRef.size.x/2 - size.x/2, gameRef.size.y/2 + size.y);
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

    if (other is PurpleWorldComponent) {
      if(!other.isDragging) return;

          // characterId++;
          // _sprite();
          //gameRef.collectedToTray(other.characterId);
          other.removeFromParent();

          gameRef.purpleComponentDestroyed(other);

          _startAnimation();
    }
  }

  _startAnimation() async {
    sprite = await gameRef
        .loadSprite('enemy/trippie/1000x850/trippie_open_mouth.png');
    await Future.delayed(const Duration(milliseconds: 150));
    sprite = await gameRef
        .loadSprite('enemy/trippie/1000x850/trippie_closed_mouth.png');
    await Future.delayed(const Duration(milliseconds: 150));
    sprite = await gameRef
        .loadSprite('enemy/trippie/1000x850/trippie_open_mouth.png');
    await Future.delayed(const Duration(milliseconds: 150));
    sprite = await gameRef
        .loadSprite('enemy/trippie/1000x850/trippie_closed_mouth.png');
  }

}

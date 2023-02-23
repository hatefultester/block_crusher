import 'package:block_crusher/src/game/collector_game.dart';
import 'package:block_crusher/src/game/alien_centered_component.dart';
import 'package:block_crusher/src/game/eye_enemy_component.dart';
import 'package:block_crusher/src/game/tray_component.dart';
import 'package:block_crusher/src/game/hoomy_weapon_component.dart';
import 'package:block_crusher/src/game/purple_centered_component.dart';
import 'package:block_crusher/src/game/sprite_block_component.dart';
import 'package:block_crusher/src/game/collector_game_helper.dart';
import 'package:block_crusher/src/game/world_type.dart';

extension OnLoadCreaturesHelper on BlockCrusherGame {
  addOnLoadCreatures() async {

    if (gameMode == GameMode.hoomy) {
      enemyHoomyComponent = EnemyHoomyComponent();
      await add(enemyHoomyComponent);
    }

    if (gameMode == GameMode.cityFood) {
      await add(TrayComponent());
    }

    if (gameMode == GameMode.cityFood) {
      if (state.characterId > 3) {
        await add(
            EyeEnemyComponent.withScaleAndDirection(
                Direction.up, Direction.left, 0.7, 0.65),
        );
        await add(
            EyeEnemyComponent.withScaleAndDirection(
                Direction.down, Direction.right, 0.65, 0.7),
        );
      } else {
        await add(
            EyeEnemyComponent(),
        );
      }
    }

    if(gameMode == GameMode.purpleWorld) {
      if(purpleMode == PurpleMode.trippie) {
        await add(PurpleCenteredComponent());
      }
    }

    if(gameMode == GameMode.alien) {
      await add(AlienCenteredComponent());
    }

    //debugCheating();

    if(generateCharacterFromLastLevel) {
      await addDefaultBlock();
    }
  }

  addDefaultBlock() async {
    if (difficulty == WorldType.soomyLand) {
      if (state.goal - 1 > 0) {
        await add(SpriteBlockComponent.withLevelSet(
            state.characterId - 1, difficulty));
      }
    }
  }
}
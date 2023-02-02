import 'package:block_crusher/src/game_internals/games/collector_game/collector_game.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/alien_world/alien_centered_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/city_land/eye_enemy_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/city_land/tray_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/hoomy_land/hoomy_weapon_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/purple_land/purple_centered_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/soomy_land/sprite_block_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/world_type.dart';

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
import 'package:block_crusher/src/game_internals/games/collector_game/collector_game.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/world_type.dart';
import 'package:block_crusher/src/utils/maps.dart';

extension MapPathHelper on BlockCrusherGame {
  String setMapBasedOnDifficulty() {

    String mapPath;

    switch (difficulty) {
      case WorldType.soomyLand:
        mapPath = gameMaps['brick']!;
        break;
      case WorldType.hoomyLand:
        gameMode = GameMode.hoomy;
        mapPath = gameMaps['hoomy']!;
        break;
      case WorldType.seaLand:
        gameMode = GameMode.sharks;
        mapPath = gameMaps['water']!;
        break;
      case WorldType.cityLand:
        gameMode = GameMode.cityFood;
        mapPath = gameMaps['city']!;
        break;
      case WorldType.purpleWorld:
        gameMode = GameMode.purpleWorld;
        mapPath = gameMaps['purple']!;
        break;
      case WorldType.alien:
        gameMode = GameMode.alien;
        mapPath = gameMaps['mimon']!;
        break;
    }

    return mapPath;
  }
}
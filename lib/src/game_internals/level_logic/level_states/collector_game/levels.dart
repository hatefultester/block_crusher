import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/level.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/world_type.dart';

const gameLevels = [
  /// SOOMY LEVELS
  /// BRICK WALL
  ///
  GameLevel(
      levelId: 1, characterId: 1, worldType: WorldType.soomyLand),
  GameLevel(
      levelId: 2, characterId: 2, worldType: WorldType.soomyLand),
  GameLevel(
      levelId: 3, characterId: 3, worldType: WorldType.soomyLand),
  GameLevel(
      levelId: 4, characterId: 4, worldType: WorldType.soomyLand),
  GameLevel(
      levelId: 5, characterId: 5, worldType: WorldType.soomyLand),
  GameLevel(
      levelId: 6, characterId: 6, worldType: WorldType.soomyLand),



  /// SEA LEVELS
  /// SEA CHARACTERS
  ///
  GameLevel(
      levelId: 7, characterId: 1, worldType: WorldType.seaLand),
  GameLevel(
      levelId: 8, characterId: 2, worldType: WorldType.seaLand),
  GameLevel(
      levelId: 9, characterId: 3, worldType: WorldType.seaLand),
  GameLevel(
      levelId: 10, characterId: 4, worldType: WorldType.seaLand),
  GameLevel(
      levelId: 11, characterId: 5, worldType: WorldType.seaLand),
  GameLevel(
      levelId: 12, characterId: 6, worldType: WorldType.seaLand),

  /// HOOMY LAND LEVELS
  /// RED BACKGROUND
  ///
  GameLevel(
      levelId: 13, characterId: 1, worldType: WorldType.hoomyLand),
  GameLevel(
      levelId: 14, characterId: 2, worldType: WorldType.hoomyLand),
  GameLevel(
      levelId: 15, characterId: 3, worldType: WorldType.hoomyLand),
  GameLevel(
      levelId: 16, characterId: 4, worldType: WorldType.hoomyLand),
  GameLevel(
      levelId: 17, characterId: 5, worldType: WorldType.hoomyLand),
  GameLevel(
      levelId: 18, characterId: 6, worldType: WorldType.hoomyLand),

  /// CITY LEVEL
  /// CITY CHARACTERS
  ///
  GameLevel(
      levelId: 19, characterId: 1, worldType: WorldType.cityLand),
  GameLevel(
      levelId: 20, characterId: 2, worldType: WorldType.cityLand),
  GameLevel(
      levelId: 21, characterId: 3, worldType: WorldType.cityLand),
  GameLevel(
      levelId: 22, characterId: 4, worldType: WorldType.cityLand),
  GameLevel(
      levelId: 23, characterId: 5, worldType: WorldType.cityLand),

  /// ALIEN SHOOTER LEVEL
  ///
  ///
  GameLevel(
      levelId: 24,
      characterId: 1,
      worldType: WorldType.purpleWorld),

  GameLevel(
    levelId: 25,
    characterId: 2,
    worldType: WorldType.purpleWorld),

  GameLevel(
      levelId: 26,
      characterId: 1,
      worldType: WorldType.alien),
];

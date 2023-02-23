import 'package:block_crusher/src/database/model/level.dart';
import 'package:block_crusher/src/game/world_type.dart';

import '../game/purple_component.dart';
import '../game/purple_math_component.dart';
import '../game/collector_game_helper.dart';

const gameLevels = [
  /// SOOMY LEVELS
  /// BRICK WALL
  ///
  GameLevel(
      winningCharacterReference: 'soomy1',
      levelId: 1, characterId: 1, worldType: WorldType.soomyLand),
  GameLevel(
      winningCharacterReference: 'soomy2',
      levelId: 2, characterId: 2, worldType: WorldType.soomyLand),
  GameLevel(
      winningCharacterReference: 'soomy3',
      levelId: 3, characterId: 3, worldType: WorldType.soomyLand),
  GameLevel(
      winningCharacterReference: 'soomy4',
      levelId: 4, characterId: 4, worldType: WorldType.soomyLand),
  GameLevel(
      winningCharacterReference: 'soomy5',
      levelId: 5, characterId: 5, worldType: WorldType.soomyLand),
  GameLevel(
      winningCharacterReference: 'soomy6',
      levelId: 6, characterId: 6, worldType: WorldType.soomyLand),

  /// SEA LEVELS
  /// SEA CHARACTERS
  ///
  GameLevel(
      winningCharacterReference: 'sea1',
      levelId: 7, characterId: 1, worldType: WorldType.seaLand),
  GameLevel(
      winningCharacterReference: 'sea2',
      levelId: 8, characterId: 2, worldType: WorldType.seaLand),
  GameLevel(
      winningCharacterReference: 'sea3',
      levelId: 9, characterId: 3, worldType: WorldType.seaLand),
  GameLevel(
      winningCharacterReference: 'sea4',
      levelId: 10, characterId: 4, worldType: WorldType.seaLand),
  GameLevel(
      winningCharacterReference: 'sea5',
      levelId: 11, characterId: 5, worldType: WorldType.seaLand),
  GameLevel(
      winningCharacterReference: 'sea6',
      levelId: 12, characterId: 6, worldType: WorldType.seaLand),

  /// HOOMY LAND LEVELS
  /// RED BACKGROUND
  ///
  GameLevel(
      winningCharacterReference: 'hoomy1',
      levelId: 13, characterId: 1, worldType: WorldType.hoomyLand),
  GameLevel(
      winningCharacterReference: 'hoomy2',
      levelId: 14, characterId: 2, worldType: WorldType.hoomyLand),
  GameLevel(
      winningCharacterReference: 'hoomy3',
      levelId: 15, characterId: 3, worldType: WorldType.hoomyLand),
  GameLevel(
      winningCharacterReference: 'hoomy4',
      levelId: 16, characterId: 4, worldType: WorldType.hoomyLand),
  GameLevel(
      winningCharacterReference: 'hoomy5',
      levelId: 17, characterId: 5, worldType: WorldType.hoomyLand),
  GameLevel(
      winningCharacterReference: 'hoomy6',
      levelId: 18, characterId: 6, worldType: WorldType.hoomyLand),

  /// CITY LEVEL
  /// CITY CHARACTERS
  ///
  GameLevel(
      winningCharacterReference: 'city1',
      levelId: 19, characterId: 1, worldType: WorldType.cityLand),
  GameLevel(
      winningCharacterReference: 'city2',
      levelId: 20, characterId: 2, worldType: WorldType.cityLand),
  GameLevel(
      winningCharacterReference: 'city3',
      levelId: 21, characterId: 3, worldType: WorldType.cityLand),
  GameLevel(
      winningCharacterReference: 'city4',
      levelId: 22, characterId: 4, worldType: WorldType.cityLand),
  GameLevel(
      winningCharacterReference: 'city5',
      levelId: 23, characterId: 5, worldType: WorldType.cityLand),

  /// Purple world levels
  ///
  ///
  GameLevel(
      levelId: 24,
      characterId: 0,
      worldType: WorldType.purpleWorld,
      purpleMode: PurpleMode.trippie,
    trippieCharacterType: TrippieCharacterType.number,
    gameGoal: 10,
    winningCharacterReference: "purple1",
  ), GameLevel(
    levelId: 25,
    characterId: 4,
    worldType: WorldType.purpleWorld,
    purpleMode: PurpleMode.counterToFive,
    mathCharacterType: MathCharacterType.cube,
    winningCharacterReference: "purple2",
    gameGoal: 25,
  ),
  GameLevel(
    levelId: 26,
    characterId: 1,
    worldType: WorldType.purpleWorld,
    purpleMode: PurpleMode.trippie,
    trippieCharacterType: TrippieCharacterType.vacuum,
    winningCharacterReference: "purple3",
    gameGoal: 25,
  ),GameLevel(
    levelId: 27,
    characterId: 4,
    worldType: WorldType.purpleWorld,
    purpleMode: PurpleMode.counterToFive,
    mathCharacterType: MathCharacterType.cube,
    winningCharacterReference: "purple4",
    gameGoal: 50,
  ),
  GameLevel(
    levelId: 28,
    characterId: 2,
    worldType: WorldType.purpleWorld,
    purpleMode: PurpleMode.trippie,
    trippieCharacterType: TrippieCharacterType.number,
    winningCharacterReference: "purple5",
    gameGoal: 50,
  ),GameLevel(
    levelId: 29,
    characterId: 2,
    worldType: WorldType.purpleWorld,
    purpleMode: PurpleMode.counterToFive,
    mathCharacterType: MathCharacterType.faraon,
    winningCharacterReference: "purple6",
    gameGoal: 100,
  ),
  GameLevel(
    levelId: 30,
    characterId: 3,
    worldType: WorldType.purpleWorld,
    purpleMode: PurpleMode.trippie,
    trippieCharacterType: TrippieCharacterType.vacuum,
    winningCharacterReference: "purple7",
    gameGoal: 100,
  ),GameLevel(
    levelId: 31,
    characterId: 2,
    worldType: WorldType.purpleWorld,
    purpleMode: PurpleMode.counterToFive,
    mathCharacterType: MathCharacterType.faraon,
    winningCharacterReference: "purple8",
    gameGoal: 150,
  ),

/// counter to five

  GameLevel(
      levelId: 32,
      characterId: 1,
      worldType: WorldType.alien,
      winningCharacterReference: 'alien0'
  ),
];

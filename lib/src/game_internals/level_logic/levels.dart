// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

const gameLevels = [
  /// SOOMY LEVELS
  /// BRICK WALL
  ///
  GameLevel(
      levelId: 1, characterId: 1, levelDifficulty: LevelDifficulty.soomyLand),
  GameLevel(
      levelId: 2, characterId: 2, levelDifficulty: LevelDifficulty.soomyLand),
  GameLevel(
      levelId: 3, characterId: 3, levelDifficulty: LevelDifficulty.soomyLand),
  GameLevel(
      levelId: 4, characterId: 4, levelDifficulty: LevelDifficulty.soomyLand),
  GameLevel(
      levelId: 5, characterId: 5, levelDifficulty: LevelDifficulty.soomyLand),
  GameLevel(
      levelId: 6, characterId: 6, levelDifficulty: LevelDifficulty.soomyLand),

  /// HOOMY LAND LEVELS
  /// RED BACKGROUND
  ///
  GameLevel(
      levelId: 7, characterId: 1, levelDifficulty: LevelDifficulty.hoomyLand),
  GameLevel(
      levelId: 8, characterId: 2, levelDifficulty: LevelDifficulty.hoomyLand),
  GameLevel(
      levelId: 9, characterId: 3, levelDifficulty: LevelDifficulty.hoomyLand),
  GameLevel(
      levelId: 10, characterId: 4, levelDifficulty: LevelDifficulty.hoomyLand),
  GameLevel(
      levelId: 11, characterId: 5, levelDifficulty: LevelDifficulty.hoomyLand),
  GameLevel(
      levelId: 12, characterId: 6, levelDifficulty: LevelDifficulty.hoomyLand),

  /// SEA LEVELS
  /// SEA CHARACTERS
  ///
  GameLevel(
      levelId: 13, characterId: 1, levelDifficulty: LevelDifficulty.seaLand),
  GameLevel(
      levelId: 14, characterId: 2, levelDifficulty: LevelDifficulty.seaLand),
  GameLevel(
      levelId: 15, characterId: 3, levelDifficulty: LevelDifficulty.seaLand),
  GameLevel(
      levelId: 16, characterId: 4, levelDifficulty: LevelDifficulty.seaLand),
  GameLevel(
      levelId: 17, characterId: 5, levelDifficulty: LevelDifficulty.seaLand),
  GameLevel(
      levelId: 18, characterId: 6, levelDifficulty: LevelDifficulty.seaLand),

  /// CITY LEVEL
  /// CITY CHARACTERS
  ///
  GameLevel(
      levelId: 19, characterId: 1, levelDifficulty: LevelDifficulty.cityLand),
  GameLevel(
      levelId: 20, characterId: 2, levelDifficulty: LevelDifficulty.cityLand),
  GameLevel(
      levelId: 21, characterId: 3, levelDifficulty: LevelDifficulty.cityLand),
  GameLevel(
      levelId: 22, characterId: 4, levelDifficulty: LevelDifficulty.cityLand),
  GameLevel(
      levelId: 23, characterId: 5, levelDifficulty: LevelDifficulty.cityLand),

  /// ALIEN SHOOTER LEVEL
  ///
  ///
  GameLevel(
      levelId: 24,
      characterId: 1,
      levelDifficulty: LevelDifficulty.purpleWorld),

  GameLevel(
    levelId: 25,
    characterId: 2,
    levelDifficulty: LevelDifficulty.purpleWorld),

  GameLevel(
      levelId: 26,
      characterId: 1,
      levelDifficulty: LevelDifficulty.alien),
  // /// BLUE LEVEL
  // /// BLUE CHARACTERS
  // ///
  // GameLevel(
  //     levelId: 24, characterId: 3, levelDifficulty: LevelDifficulty.blueWorld),
  // GameLevel(
  //     levelId: 25, characterId: 4, levelDifficulty: LevelDifficulty.blueWorld),
  // GameLevel(
  //     levelId: 26, characterId: 5, levelDifficulty: LevelDifficulty.blueWorld),
  // GameLevel(
  //     levelId: 27, characterId: 6, levelDifficulty: LevelDifficulty.blueWorld),
  // GameLevel(
  //     levelId: 28, characterId: 7, levelDifficulty: LevelDifficulty.blueWorld),
  // GameLevel(
  //     levelId: 29, characterId: 8, levelDifficulty: LevelDifficulty.blueWorld),
];

enum LevelDifficulty {
  soomyLand,
  hoomyLand,
  seaLand,
  cityLand,
  purpleWorld,
  alien,
  blueWorld;

  bool atLeast(LevelDifficulty difficulty) {
    return false;

    // switch (difficulty) {
    //   case LevelDifficulty.learning:
    //     return false;
    //   case LevelDifficulty.beginner:
    //     return this == LevelDifficulty.jedi ||
    //         this == LevelDifficulty.master ||
    //         this == LevelDifficulty.intermediate ||
    //         this == LevelDifficulty.beginner;
    //   case LevelDifficulty.intermediate:
    //     return this == LevelDifficulty.jedi ||
    //         this == LevelDifficulty.master ||
    //         this == LevelDifficulty.intermediate;
    //   case LevelDifficulty.master:
    //     return this == LevelDifficulty.jedi || this == LevelDifficulty.master;
    //   case LevelDifficulty.jedi:
    //     return this == LevelDifficulty.jedi;
    // }
  }

  additionalLives(LevelType type) {
    switch (type) {
      case LevelType.collector:
        switch (this) {
          case LevelDifficulty.soomyLand:
            return 0;
          case LevelDifficulty.hoomyLand:
            return 0;
          case LevelDifficulty.seaLand:
            return 50;
          case LevelDifficulty.cityLand:
            return 100;
          case LevelDifficulty.blueWorld:
            return 200;
          case LevelDifficulty.purpleWorld:
            return 100;
          case LevelDifficulty.alien:
            return 0;
        }
      default:
        return 0;
    }
  }
}

enum LevelType {
  coinPicker,
  collector,
  ;

  defaultLives() {
    switch (this) {
      case LevelType.coinPicker:
        return 5;
      case LevelType.collector:
        return 100;
    }
  }
}

class GameLevel {
  final LevelDifficulty levelDifficulty;

  final LevelType levelType;

  final int levelId;

  final int characterId;

  final int? miniGameId;

  final int coinCount;

  final int price;
  bool get openByDefault => price == 0 ? true : false;

  int get lives =>
      levelType.defaultLives() + levelDifficulty.additionalLives(levelType);

  final String? achievementIdIOS;

  final String? achievementIdAndroid;

  bool get awardsAchievement => achievementIdAndroid != null;

  const GameLevel(
      {required this.levelDifficulty,
      required this.levelId,
      required this.characterId,
      this.achievementIdIOS,
      this.achievementIdAndroid,
      this.levelType = LevelType.collector,
      this.miniGameId = 0,
      this.coinCount = 50,
      this.price = 0,})
      : assert(
            (achievementIdAndroid != null && achievementIdIOS != null) ||
                (achievementIdAndroid == null && achievementIdIOS == null),
            'Either both iOS and Android achievement ID must be provided, '
            'or none');
}

// GameLevel(
//   number: 1,
//   difficulty: 5,
//   // TODO: When ready, change these achievement IDs.
//   // You configure this in App Store Connect.
//   achievementIdIOS: 'first_win',
//   // You get this string when you configure an achievement in Play Console.
//   achievementIdAndroid: 'NhkIwB69ejkMAOOLDb',
// ),
// GameLevel(
//   number: 2,
//   difficulty: 42,
// ),
// GameLevel(
//   number: 3,
//   difficulty: 100,
//   achievementIdIOS: 'finished',
//   achievementIdAndroid: 'CdfIhE96aspNWLGSQg',
// ),

const bonusLevels = [
  [
    GameLevel(
        levelId: 1,
        miniGameId: 1,
        characterId: 1,
        levelDifficulty: LevelDifficulty.soomyLand,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 2,
        miniGameId: 1,
        characterId: 1,
        levelDifficulty: LevelDifficulty.soomyLand,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 3,
        miniGameId: 1,
        characterId: 1,
        levelDifficulty: LevelDifficulty.soomyLand,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 4,
        miniGameId: 1,
        characterId: 1,
        levelDifficulty: LevelDifficulty.soomyLand,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 5,
        miniGameId: 1,
        characterId: 1,
        levelDifficulty: LevelDifficulty.soomyLand,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 6,
        miniGameId: 1,
        characterId: 1,
        levelDifficulty: LevelDifficulty.soomyLand,
        levelType: LevelType.coinPicker),
  ],

  ///
  [
    GameLevel(
        levelId: 7,
        miniGameId: 1,
        characterId: 1,
        levelDifficulty: LevelDifficulty.soomyLand,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 8,
        miniGameId: 1,
        characterId: 1,
        levelDifficulty: LevelDifficulty.soomyLand,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 9,
        miniGameId: 1,
        characterId: 1,
        levelDifficulty: LevelDifficulty.soomyLand,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 10,
        miniGameId: 1,
        characterId: 1,
        levelDifficulty: LevelDifficulty.soomyLand,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 11,
        miniGameId: 1,
        characterId: 1,
        levelDifficulty: LevelDifficulty.soomyLand,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 12,
        characterId: 1,
        miniGameId: 1,
        levelDifficulty: LevelDifficulty.soomyLand,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 13,
        miniGameId: 1,
        characterId: 1,
        levelDifficulty: LevelDifficulty.soomyLand,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 14,
        miniGameId: 1,
        characterId: 1,
        levelDifficulty: LevelDifficulty.soomyLand,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 15,
        miniGameId: 1,
        characterId: 1,
        levelDifficulty: LevelDifficulty.soomyLand,
        levelType: LevelType.coinPicker),
  ],
];
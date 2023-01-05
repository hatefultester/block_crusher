// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:block_crusher/src/level_selection/level_states/collector_game_level_state.dart';

const gameLevels = [
  GameLevel(levelId: 1, levelDifficulty: LevelDifficulty.learning),
  GameLevel(levelId: 2, levelDifficulty: LevelDifficulty.learning),
  GameLevel(levelId: 3, levelDifficulty: LevelDifficulty.learning),
  GameLevel(levelId: 4, levelDifficulty: LevelDifficulty.beginner),
  GameLevel(levelId: 5, levelDifficulty: LevelDifficulty.beginner),
  GameLevel(levelId: 6, levelDifficulty: LevelDifficulty.beginner),
  GameLevel(levelId: 7, levelDifficulty: LevelDifficulty.intermediate),
  GameLevel(levelId: 8, levelDifficulty: LevelDifficulty.intermediate),
  GameLevel(levelId: 9, levelDifficulty: LevelDifficulty.intermediate),
  GameLevel(levelId: 10, levelDifficulty: LevelDifficulty.master),
  GameLevel(levelId: 11, levelDifficulty: LevelDifficulty.master),
  GameLevel(levelId: 12, levelDifficulty: LevelDifficulty.master),
  GameLevel(levelId: 13, levelDifficulty: LevelDifficulty.jedi),
  GameLevel(levelId: 14, levelDifficulty: LevelDifficulty.jedi),
  GameLevel(levelId: 15, levelDifficulty: LevelDifficulty.jedi),
];

const bonusLevels = [
  [
    GameLevel(
        levelId: 1,
        miniGameId: 1,
        levelDifficulty: LevelDifficulty.learning,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 2,
        miniGameId: 1,
        levelDifficulty: LevelDifficulty.learning,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 3,
        miniGameId: 1,
        levelDifficulty: LevelDifficulty.learning,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 4,
        miniGameId: 1,
        levelDifficulty: LevelDifficulty.learning,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 5,
        miniGameId: 1,
        levelDifficulty: LevelDifficulty.learning,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 6,
        miniGameId: 1,
        levelDifficulty: LevelDifficulty.learning,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 7,
        miniGameId: 1,
        levelDifficulty: LevelDifficulty.learning,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 8,
        miniGameId: 1,
        levelDifficulty: LevelDifficulty.learning,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 9,
        miniGameId: 1,
        levelDifficulty: LevelDifficulty.learning,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 10,
        miniGameId: 1,
        levelDifficulty: LevelDifficulty.learning,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 11,
        miniGameId: 1,
        levelDifficulty: LevelDifficulty.learning,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 12,
        miniGameId: 1,
        levelDifficulty: LevelDifficulty.learning,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 13,
        miniGameId: 1,
        levelDifficulty: LevelDifficulty.learning,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 14,
        miniGameId: 1,
        levelDifficulty: LevelDifficulty.learning,
        levelType: LevelType.coinPicker),
  ],
  [
    GameLevel(
        levelId: 15,
        miniGameId: 1,
        levelDifficulty: LevelDifficulty.learning,
        levelType: LevelType.coinPicker),
  ],
];

enum LevelDifficulty {
  learning,
  beginner,
  intermediate,
  master,
  jedi;

  bool atLeast(LevelDifficulty difficulty) {
    switch (difficulty) {
      case LevelDifficulty.learning:
        return false;
      case LevelDifficulty.beginner:
        return this == LevelDifficulty.jedi ||
            this == LevelDifficulty.master ||
            this == LevelDifficulty.intermediate ||
            this == LevelDifficulty.beginner;
      case LevelDifficulty.intermediate:
        return this == LevelDifficulty.jedi ||
            this == LevelDifficulty.master ||
            this == LevelDifficulty.intermediate;
      case LevelDifficulty.master:
        return this == LevelDifficulty.jedi || this == LevelDifficulty.master;
      case LevelDifficulty.jedi:
        return this == LevelDifficulty.jedi;
    }
  }

  additionalLives(LevelType type) {
    switch (type) {
      case LevelType.collector:
        switch (this) {
          case LevelDifficulty.learning:
            return 0;
          case LevelDifficulty.beginner:
            return 0;
          case LevelDifficulty.intermediate:
            return 50;
          case LevelDifficulty.master:
            return 100;
          case LevelDifficulty.jedi:
            return 200;
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

  final int? miniGameId;

  int get lives =>
      levelType.defaultLives() + levelDifficulty.additionalLives(levelType);

  final String? achievementIdIOS;

  final String? achievementIdAndroid;

  bool get awardsAchievement => achievementIdAndroid != null;

  const GameLevel(
      {required this.levelDifficulty,
      required this.levelId,
      this.achievementIdIOS,
      this.achievementIdAndroid,
      this.levelType = LevelType.collector,
      this.miniGameId = 0})
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

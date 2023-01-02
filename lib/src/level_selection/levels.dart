// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

const gameLevels = [
  GameLevel(level: 1, levelDifficulty: LevelDifficulty.learning),
  GameLevel(level: 2, levelDifficulty: LevelDifficulty.learning),
  GameLevel(level: 3, levelDifficulty: LevelDifficulty.learning),

  GameLevel(level: 4, levelDifficulty: LevelDifficulty.beginner),
  GameLevel(level: 5, levelDifficulty: LevelDifficulty.beginner),
  GameLevel(level: 6, levelDifficulty: LevelDifficulty.beginner),

  GameLevel(level: 7, levelDifficulty: LevelDifficulty.intermediate),
  GameLevel(level: 8, levelDifficulty: LevelDifficulty.intermediate),
  GameLevel(level: 9, levelDifficulty: LevelDifficulty.intermediate),

  GameLevel(level: 10, levelDifficulty: LevelDifficulty.master),
  GameLevel(level: 11, levelDifficulty: LevelDifficulty.master),
  GameLevel(level: 12, levelDifficulty: LevelDifficulty.master),

  GameLevel(level: 13, levelDifficulty: LevelDifficulty.jedi),
  GameLevel(level: 14, levelDifficulty: LevelDifficulty.jedi),
  GameLevel(level: 15, levelDifficulty: LevelDifficulty.jedi),

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
}

class GameLevel {
  final LevelDifficulty levelDifficulty;

  final int level;

  final int lives = 1000;

  /// The achievement to unlock when the level is finished, if any.
  final String? achievementIdIOS;

  final String? achievementIdAndroid;

  bool get awardsAchievement => achievementIdAndroid != null;

  const GameLevel({
    required this.levelDifficulty,
    required this.level,
    this.achievementIdIOS,
    this.achievementIdAndroid,
  }) : assert(
            (achievementIdAndroid != null && achievementIdIOS != null) ||
                (achievementIdAndroid == null && achievementIdIOS == null),
            'Either both iOS and Android achievement ID must be provided, '
            'or none');
}

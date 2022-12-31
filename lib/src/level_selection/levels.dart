// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

const gameLevels = [
  GameLevel(number: 1, difficulty: 1),
  GameLevel(number: 2, difficulty: 2),
  GameLevel(number: 3, difficulty: 3),
  GameLevel(number: 4, difficulty: 4),
  GameLevel(number: 5, difficulty: 5),
  GameLevel(number: 6, difficulty: 6),
  GameLevel(number: 7, difficulty: 7),
  GameLevel(number: 8, difficulty: 8),
  GameLevel(number: 9, difficulty: 9),
  GameLevel(number: 10, difficulty: 10),
  GameLevel(number: 11, difficulty: 11),
  GameLevel(number: 12, difficulty: 12),
  GameLevel(number: 13, difficulty: 13),
  GameLevel(number: 14, difficulty: 14),
  GameLevel(number: 15, difficulty: 15),

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

class GameLevel {
  final int number;

  final int difficulty;

  final int lives = 1000;

  /// The achievement to unlock when the level is finished, if any.
  final String? achievementIdIOS;

  final String? achievementIdAndroid;

  bool get awardsAchievement => achievementIdAndroid != null;

  const GameLevel({
    required this.number,
    required this.difficulty,
    this.achievementIdIOS,
    this.achievementIdAndroid,
  }) : assert(
            (achievementIdAndroid != null && achievementIdIOS != null) ||
                (achievementIdAndroid == null && achievementIdIOS == null),
            'Either both iOS and Android achievement ID must be provided, '
            'or none');
}

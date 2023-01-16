// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:block_crusher/src/level_selection/levels.dart';
import 'package:block_crusher/src/utils/characters.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// An extremely silly example of a game state.
///
/// Tracks only a single variable, [score], and calls [onWin] when
/// the value of [score] reaches [getGoal].
class CollectorGameLevelState extends ChangeNotifier {
  final VoidCallback onWin;
  final VoidCallback onDie;

  final LevelType levelType;
  final LevelDifficulty levelDifficulty;

  final int characterId;

  final int goal;

  final int maxLives;

  late int _lives;
  int get lives => _lives;

  int _score = 0;
  int get score => _score;

  int _level = 0;
  int get level => _level;

  bool _playerDied = false;
  bool _gameWon = false;

  List<int> _items = [];

  List<int> get items => _items;

  void reset() {
    _score = 0;
    _level = 0;
    _lives = maxLives;
    _playerDied = false;
    _gameWon = false;
  }

  CollectorGameLevelState(
      {required this.onWin,
      required this.characterId,
      required this.onDie,
      required this.levelType,
      required this.levelDifficulty,
      this.goal = 100,
      this.maxLives = 10}) {
    _lives = maxLives;
    if (levelDifficulty == LevelDifficulty.cityLand) {
      _getGoalItems();
      print(cityFoods[characterId - 1]['debug']);
    }
  }

  _getGoalItems() {
    print('goalItems generated');
    for (var _ in cityFoods[characterId - 1]['characters']) {
      _items.add(0);
    }
  }

  void collect(int id) {
    _items[id]++;
    notifyListeners();
  }

  void setLevel(int value) {
    _level = value;
    notifyListeners();
  }

  void increaseScore(int value) {
    _score += value;
    notifyListeners();
  }

  void setProgress(int value) {
    _score = value;
    notifyListeners();
  }

  void decreaseLife() {
    _lives--;
    notifyListeners();
  }

  bool _collected() {
    if (_playerDied || _gameWon) return false;

    bool collected = true;

    for (int i = 0; i < _items.length; i++) {
      print(' i position $i : ${_items[i]}');
      if (_items[i] < cityFoods[characterId - 1]['characters'][i]['goal'])
        collected = false;
    }

    return collected;
  }

  void evaluate() {
    if (levelType == LevelType.collector) {
      if (_level >= goal && !_playerDied && !_gameWon) {
        onWin();
        _gameWon = true;
      }
      if (_lives <= 0 && !_playerDied && !_gameWon) {
        onDie();
        _playerDied = true;
      }
    }
    if (_collected()) {
      onWin();
      _gameWon = true;
    }
  }
}

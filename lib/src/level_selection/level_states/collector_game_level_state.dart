

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

  bool isWinningLevel;

  List<int> items = [];

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
        this.isWinningLevel = true,
      this.goal = 100,
      this.maxLives = 10}) {
    _lives = maxLives;

    if (levelDifficulty == LevelDifficulty.cityLand) {
      _getGoalItems();
      debugPrint(cityFoods[characterId - 1]['debug']);
    }

    if(levelDifficulty == LevelDifficulty.purpleWorld) {
      isWinningLevel = false;
    }
  }

  _getGoalItems() {
    debugPrint('goalItems generated');
    for (var _ in cityFoods[characterId - 1]['characters']) {
      items.add(0);
    }
  }

  void collect(int id) {
    items[id]++;
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
    if ((_playerDied || _gameWon)) return false;
    if (levelDifficulty != LevelDifficulty.cityLand) return false;

    bool collected = true;

    for (int i = 0; i < items.length; i++) {
      debugPrint(' i position $i : ${items[i]}');
      if (items[i] < cityFoods[characterId - 1]['characters'][i]['goal']) {
        collected = false;
      }
    }

    return collected;
  }

  void evaluate() {
    if(!isWinningLevel) return;

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

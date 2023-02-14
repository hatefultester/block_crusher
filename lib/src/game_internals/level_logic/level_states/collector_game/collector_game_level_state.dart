
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/levels.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/world_type.dart';
import 'package:block_crusher/src/utils/in_game_characters.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'level.dart';

class CollectorGameLevelState extends ChangeNotifier {
  final VoidCallback onWin;
  final VoidCallback onDie;

  final GameType levelType;
  final WorldType levelDifficulty;
  
  final GameLevel level;

  final int characterId;

  final int goal;
  int _currentGoalStatus = 20;

  final int maxLives;

  late int _lives;
  int get lives => _lives;

  int _currentScore = 0;
  int get currentScore => _currentScore;

  bool _playerDied = false;
  bool _gameWon = false;

  int _coinCount = 0;
  int get coinCount => _coinCount;

  int get currentGoal => _currentGoalStatus;

  bool isWinningLevel;

  List<int> items = [];

  void reset() {
    _currentScore = 0;
    _lives = maxLives;

    _playerDied = false;
    _gameWon = false;
  }

  CollectorGameLevelState(
      {
        required this.level,
        required this.onWin,
      required this.characterId,
      required this.onDie,
      required this.levelType,
      required this.levelDifficulty,
        this.isWinningLevel = true,
      this.goal = 20,
      required this.maxLives}) {

    _lives = maxLives;

    if (levelDifficulty == WorldType.cityLand) {
      _getGoalItems();
      debugPrint(cityFoods[characterId - 1]['debug']);
      return;
    }

    if(levelDifficulty == WorldType.purpleWorld) {
      isWinningLevel = false;
    return;
    }
    if(levelDifficulty == WorldType.alien) {
      isWinningLevel = false;
  return;
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

  void setScore(int value) {
    _currentScore = value;
    notifyListeners();
  }

  bool evaluateScore(int value) {
    if (value > _currentScore) {
      _currentScore = value;
    return true;
    }
    return false;
  }

  void decreaseLife() {
    _lives--;
    notifyListeners();
  }

  void increaseCoinCount(int value) {
    _coinCount+= value;
    notifyListeners();
  }

  bool _collected() {
    print('checking collected status');

    if ((_playerDied)) return false;

    print('its good, player didnt die');
    if (levelDifficulty != WorldType.cityLand) return false;

    print('its city land all good');

    bool collected = true;

    for (int i = 0; i < items.length; i++) {
      debugPrint(' i position $i : ${items[i]}');
      if (items[i] < cityFoods[characterId - 1]['characters'][i]['goal']) {
        collected = false;
      }
    }

    return collected;
  }

  decreaseCountdown() {
    _currentGoalStatus--;
    notifyListeners();
  }

  _counterGoalReached() {
    if (levelDifficulty != WorldType.purpleWorld) return false;
    else {
      return _currentGoalStatus == 0;
    }
  }

  void evaluate() {

      if (_currentScore >= goal && !_playerDied && !_gameWon && isWinningLevel) {
        onWin();
        _gameWon = true;
      }
      if (_lives <= 0 && !_playerDied && !_gameWon) {
        onDie();
        _playerDied = true;
      }


    if (_collected()) {
      onWin();
      _gameWon = true;
    }

    if (_counterGoalReached()) {
      onWin();
      _gameWon = true;
    }
  }
}

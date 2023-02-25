
import 'dart:async';

import 'package:block_crusher/src/storage/persistence/level_statistics_persistence.dart';
import 'package:flutter/foundation.dart';

class LevelStatistics extends ChangeNotifier {
  final LevelStatisticsPersistence _store;

  int _highestLevelReached = 0;

  int _totalPlayedTimeInSeconds = 0;

  int _deathRate = 0;
  int _winRate = 0;
  int _loseRate = 0;


  LevelStatistics(LevelStatisticsPersistence store) : _store = store;

  int get highestLevelReached => _highestLevelReached;
  int get totalPlayedTimeInSeconds => _totalPlayedTimeInSeconds;
  int get deathRate => _deathRate;
  int get loseRate => _loseRate;
  int get winRate => _winRate;

  void increaseDeathRate() {
    _deathRate++;
    notifyListeners();
    unawaited(_store.saveDeathRate(deathRate));
  }


  void increaseLoseRate() {
    _loseRate++;
    notifyListeners();
    unawaited(_store.saveLoseRate(loseRate));
  }


  void increaseWinRate() {
    _winRate++;
    notifyListeners();
    unawaited(_store.saveWinRate(winRate));
  }

  void setLevelReached(int level) {
    if (level > _highestLevelReached) {
      _highestLevelReached = level;
      notifyListeners();
      unawaited(_store.saveHighestLevelReached(level));
    }
  }

  void increaseTotalPlayTime(int seconds) {
    _totalPlayedTimeInSeconds += seconds;
    notifyListeners();
    unawaited(_store.saveTotalPlayedTimeInSeconds(_totalPlayedTimeInSeconds));
  }


  Future<void> getLatestFromStore() async {
    await _getLatestHighestLevelReached();
    await _getLatestTotalPlayTimeInSeconds();
    await _getLatestDeathRate();
    await _getLatestLoseRate();
    await _getLatestWinRate();
  }

  Future<void> _getLatestDeathRate() async {
    final rate = await _store.getDeathRate();
    if (rate > deathRate) {
      _deathRate = rate;
      notifyListeners();
    } else if (rate < deathRate) {
      await _store.saveDeathRate(deathRate);
    }
  }

  Future<void> _getLatestLoseRate() async {
    final rate = await _store.getLoseRate();
    if (rate > loseRate) {
      _loseRate = rate;
      notifyListeners();
    } else if (rate < loseRate) {
      await _store.saveLoseRate(loseRate);
    }
  }

  Future<void> _getLatestWinRate() async {
    final rate = await _store.getWinRate();
    if (rate > winRate) {
      _winRate = rate;
      notifyListeners();
    } else if (rate < winRate) {
      await _store.saveWinRate(winRate);
    }
  }

  Future<void> _getLatestTotalPlayTimeInSeconds() async {
    final totalPlayTimeInSeconds = await _store.getTotalPlayedTimeInSeconds();
    if (totalPlayTimeInSeconds > totalPlayedTimeInSeconds) {
      _totalPlayedTimeInSeconds = totalPlayTimeInSeconds;
      notifyListeners();
    } else if (totalPlayTimeInSeconds < _totalPlayedTimeInSeconds) {
      await _store.saveTotalPlayedTimeInSeconds(_totalPlayedTimeInSeconds);
    }
  }

  Future<void> _getLatestHighestLevelReached() async {
    final level = await _store.getHighestLevelReached();
    if (level > _highestLevelReached) {
      _highestLevelReached = level;
      notifyListeners();
    } else if (level < _highestLevelReached) {
      await _store.saveHighestLevelReached(_highestLevelReached);
    }
  }

  void reset() async {
    _highestLevelReached = 0;
    _totalPlayedTimeInSeconds = 0;
    _loseRate = 0;
    _winRate = 0;
    _deathRate = 0;
    notifyListeners();
    await _store.saveHighestLevelReached(_highestLevelReached);
    await _store.saveTotalPlayedTimeInSeconds(_totalPlayedTimeInSeconds);
    await _store.saveDeathRate(deathRate);
    await _store.saveLoseRate(loseRate);
    await _store.saveWinRate(winRate);
  }

  void cheat() async {
    _highestLevelReached = 32;
    await _store.saveHighestLevelReached(_highestLevelReached);
    notifyListeners();
  }
}

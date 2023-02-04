
import 'dart:async';

import 'package:block_crusher/src/storage/level_statistics/persistence/level_statistics_persistence.dart';
import 'package:flutter/foundation.dart';

class LevelStatistics extends ChangeNotifier {
  final LevelStatisticsPersistence _store;

  int _highestLevelReached = 0;

  int _totalPlayedTimeInSeconds = 0;


  LevelStatistics(LevelStatisticsPersistence store) : _store = store;

  int get highestLevelReached => _highestLevelReached;
  int get totalPlayedTimeInSeconds => _totalPlayedTimeInSeconds;



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
    notifyListeners();
    await _store.saveHighestLevelReached(_highestLevelReached);
    await _store.saveTotalPlayedTimeInSeconds(_totalPlayedTimeInSeconds);
  }

  void cheat() async {
    _highestLevelReached = 23;
    await _store.saveHighestLevelReached(_highestLevelReached);
    notifyListeners();
  }
}

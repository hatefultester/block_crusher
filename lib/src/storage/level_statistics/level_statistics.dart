
import 'dart:async';

import 'package:block_crusher/src/storage/level_statistics/persistence/level_statistics_persistence.dart';
import 'package:flutter/foundation.dart';

class LevelStatistics extends ChangeNotifier {
  final LevelStatisticsPersistence _store;

  int _highestLevelReached = 0;


  LevelStatistics(LevelStatisticsPersistence store) : _store = store;

  int get highestLevelReached => _highestLevelReached;

  void setLevelReached(int level) {
    if (level > _highestLevelReached) {
      _highestLevelReached = level;
      notifyListeners();
      unawaited(_store.saveHighestLevelReached(level));
    }
  }


  Future<void> getLatestFromStore() async {
    await _getLatestHighestLevelReached();
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
    notifyListeners();
    await _store.saveHighestLevelReached(_highestLevelReached);
  }

  void cheat() async {
    _highestLevelReached = 23;
    await _store.saveHighestLevelReached(_highestLevelReached);
    notifyListeners();
  }
}

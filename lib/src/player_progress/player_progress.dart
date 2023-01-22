// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';

import 'persistence/player_progress_persistence.dart';

/// Encapsulates the player's progress.
class PlayerProgress extends ChangeNotifier {
  static const maxHighestScoresPerPlayer = 10;

  final PlayerProgressPersistence _store;

  int _highestLevelReached = 0;
  int _coinCount = 0;

  /// Creates an instance of [PlayerProgress] backed by an injected
  /// persistence [store].
  PlayerProgress(PlayerProgressPersistence store) : _store = store;

  /// The highest level that the player has reached so far.
  int get highestLevelReached => _highestLevelReached;
  int get coinCount => _coinCount;

  /// Fetches the latest data from the backing persistence store.
  Future<void> getLatestFromStore() async {
    await _getLatestCoinCount();
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

  Future<void> _getLatestCoinCount() async {
    final coinCount = await _store.getCoinCount();
    if (coinCount > _coinCount) {
      _coinCount = coinCount;
      notifyListeners(); }
    else if (coinCount < _coinCount) {
      await _store.saveCoinCount(coinCount);
    }
  }

  /// Resets the player's progress so it's like if they just started
  /// playing the game for the first time.
  void reset() async {
    _highestLevelReached = 0;
    notifyListeners();
    await _store.saveHighestLevelReached(_highestLevelReached);
  }

  void cheat() async {
    _highestLevelReached = 23;
    notifyListeners();
    await _store.saveHighestLevelReached(_highestLevelReached);
  }

  /// Registers [level] as reached.
  ///
  /// If this is higher than [highestLevelReached], it will update that
  /// value and save it to the injected persistence store.
  void setLevelReached(int level) {
    if (level > _highestLevelReached) {
      _highestLevelReached = level;
      notifyListeners();

      unawaited(_store.saveHighestLevelReached(level));
    }
  }

  void incrementCoinCount(int value) {
    _coinCount += value;

      notifyListeners();

      unawaited(_store.saveCoinCount(coinCount));

  }
}

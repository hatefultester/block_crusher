// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:block_crusher/src/game_internals/level_logic/levels.dart';
import 'package:block_crusher/src/google_play/remote_config/remote_config.dart';
import 'package:flutter/foundation.dart';

import 'persistence/player_progress_persistence.dart';

/// Encapsulates the player's progress.
class PlayerProgress extends ChangeNotifier {
  final PlayerProgressPersistence _store;

  bool _hoomyLandOpen = false;

  bool _seaLandOpen = false;

  bool _cityLandOpen = false;

  int _highestLevelReached = 0;

  int _coinCount = 0;


  PlayerProgress(PlayerProgressPersistence store) : _store = store;

  int get highestLevelReached => _highestLevelReached;
  int get coinCount => _coinCount;
  bool get cityLandOpen => _cityLandOpen;
  bool get hoomyLandOpen => _hoomyLandOpen;
  bool get seaLandOpen => _seaLandOpen;

  Future<void> getLatestFromStore() async {
    await _getLatestCoinCount();
    await _getLatestHighestLevelReached();
    await _getLatestUnlockedStatus();
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

  Future<void> _getLatestUnlockedStatus() async {
    await _getLatestHoomyLandUnlockedStatus();
    await _getLatestCityLandUnlockedStatus();
    await _getLatestSeaLandUnlockedStatus();
  }

  Future<void> _getLatestHoomyLandUnlockedStatus() async {
    final isHoomyLandOpen = await _store.isHoomyLandOpen();

    if (!isHoomyLandOpen && _hoomyLandOpen) {
      await _store.saveHoomyLandLocked(_hoomyLandOpen);
    }

    if (isHoomyLandOpen && !_hoomyLandOpen) {
      _hoomyLandOpen = isHoomyLandOpen;
      notifyListeners();
    }
  }

  Future<void> _getLatestSeaLandUnlockedStatus() async {
    final isSeaLandOpen = await _store.isSeaLandOpen();

    if (!isSeaLandOpen && _seaLandOpen) {
      await _store.saveSeaLandLocked(_seaLandOpen);
    }

    if (isSeaLandOpen && !_seaLandOpen) {
      _seaLandOpen = isSeaLandOpen;
      notifyListeners();
    }
  }


  Future<void> _getLatestCityLandUnlockedStatus() async {
    final isCityLandOpen = await _store.isCityLandOpen();

    if (!isCityLandOpen && _cityLandOpen) {
      await _store.saveCityLandLocked(_cityLandOpen);
    }

    if (isCityLandOpen && !_cityLandOpen) {
      _cityLandOpen = isCityLandOpen;
      notifyListeners();
    }
  }


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

  unlockWorld(LevelDifficulty levelDifficulty) {
    switch(levelDifficulty) {

      case LevelDifficulty.soomyLand:
      case LevelDifficulty.purpleWorld:
      case LevelDifficulty.alien:
      case LevelDifficulty.blueWorld:
        return;
      case LevelDifficulty.hoomyLand:
        _coinCount -= RemoteConfigService.to.getHoomyLandCoinPrice();
        _hoomyLandOpen = true;
        notifyListeners();
        unawaited(_store.saveHoomyLandLocked(_hoomyLandOpen));
        unawaited(_store.saveCoinCount(coinCount));
        break;
      case LevelDifficulty.seaLand:
        _coinCount -= RemoteConfigService.to.getSeaLandCoinPrice();
        _seaLandOpen = true;
        notifyListeners();
        unawaited(_store.saveSeaLandLocked(_seaLandOpen));
        unawaited(_store.saveCoinCount(coinCount));
        break;
      case LevelDifficulty.cityLand:
        _coinCount -= RemoteConfigService.to.getCityLandCoinPrice();
        _cityLandOpen = true;
        notifyListeners();
        unawaited(_store.saveCityLandLocked(_cityLandOpen));
        unawaited(_store.saveCoinCount(coinCount));
        break;
    }


  }

  isWorldUnlocked(LevelDifficulty levelDifficulty) {
    switch(levelDifficulty) {
      case LevelDifficulty.soomyLand:
        return true;
      case LevelDifficulty.hoomyLand:
        return hoomyLandOpen;
      case LevelDifficulty.seaLand:
        return seaLandOpen;
      case LevelDifficulty.cityLand:
        return cityLandOpen;
      case LevelDifficulty.purpleWorld:
        return true;
      case LevelDifficulty.alien:
        return true;
      case LevelDifficulty.blueWorld:
        return true;
    }
  }

}

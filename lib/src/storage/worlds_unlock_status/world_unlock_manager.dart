
import 'dart:async';

import 'package:block_crusher/src/game_internals/level_logic/levels.dart';
import 'package:block_crusher/src/storage/worlds_unlock_status/persistence/world_unlock_manager_persistence.dart';
import 'package:flutter/foundation.dart';

class WorldUnlockManager extends ChangeNotifier {
  final WorldUnlockManagerPersistence _store;

  bool _hoomyLandOpen = false;
  bool _seaLandOpen = false;
  bool _cityLandOpen = false;
  bool _purpleLandOpen = false;
  bool _alienLandOpen = false;


  WorldUnlockManager(WorldUnlockManagerPersistence store) : _store = store;

  bool get cityLandOpen => _cityLandOpen;
  bool get hoomyLandOpen => _hoomyLandOpen;
  bool get seaLandOpen => _seaLandOpen;
  bool get alienLandOpen => _alienLandOpen;
  bool get purpleLandOpen => _purpleLandOpen;

  Future<void> getLatestFromStore() async {
    await _getLatestUnlockedStatus();
  }

  Future<void> _getLatestUnlockedStatus() async {
    await _getLatestHoomyLandUnlockedStatus();
    await _getLatestCityLandUnlockedStatus();
    await _getLatestSeaLandUnlockedStatus();
    await _getLatestAlienLandUnlockedStatus();
    await _getLatestPurpleLandUnlockedStatus();
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

  Future<void> _getLatestAlienLandUnlockedStatus() async {
    final isAlienLandOpen = await _store.isAlienLandOpen();

    if (!isAlienLandOpen && _alienLandOpen) {
      await _store.saveAlienLandLocked(_alienLandOpen);
    }

    if (isAlienLandOpen && !_alienLandOpen) {
      _alienLandOpen = isAlienLandOpen;
      notifyListeners();
    }
  }

  Future<void> _getLatestPurpleLandUnlockedStatus() async {
    final isPurpleLandOpen = await _store.isPurpleLandOpen();

    if (!isPurpleLandOpen && _purpleLandOpen) {
      await _store.savePurpleLandLocked(_purpleLandOpen);
    }

    if (isPurpleLandOpen && !_alienLandOpen) {
      _purpleLandOpen = isPurpleLandOpen;
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
    _cityLandOpen = false;
    _hoomyLandOpen = false;
    _seaLandOpen = false;
    _purpleLandOpen = false;
    _alienLandOpen = false;

    notifyListeners();
    await _store.saveCityLandLocked(_cityLandOpen);
    await _store.saveSeaLandLocked(_seaLandOpen);
    await _store.saveHoomyLandLocked(_hoomyLandOpen);
    await _store.saveAlienLandLocked(_alienLandOpen);
    await _store.savePurpleLandLocked(_purpleLandOpen);
  }

  void cheat() async {
    _cityLandOpen = true;
    _hoomyLandOpen = true;
    _seaLandOpen = true;
    _purpleLandOpen = true;
    _alienLandOpen = true;

    notifyListeners();
    await _store.saveCityLandLocked(_cityLandOpen);
    await _store.saveSeaLandLocked(_seaLandOpen);
    await _store.saveHoomyLandLocked(_hoomyLandOpen);
    await _store.saveAlienLandLocked(_alienLandOpen);
    await _store.savePurpleLandLocked(_purpleLandOpen);
  }

  unlockWorld(LevelDifficulty levelDifficulty) {
    switch(levelDifficulty) {

      case LevelDifficulty.soomyLand:
      case LevelDifficulty.blueWorld:
        return;
      case LevelDifficulty.hoomyLand:
        _hoomyLandOpen = true;
        notifyListeners();
        unawaited(_store.saveHoomyLandLocked(_hoomyLandOpen));
        break;
      case LevelDifficulty.seaLand:
        _seaLandOpen = true;
        notifyListeners();
        unawaited(_store.saveSeaLandLocked(_seaLandOpen));
        break;
      case LevelDifficulty.cityLand:
        _cityLandOpen = true;
        notifyListeners();
        unawaited(_store.saveCityLandLocked(_cityLandOpen));
        break;
      case LevelDifficulty.purpleWorld:
      _purpleLandOpen = true;
      notifyListeners();
      unawaited(_store.saveHoomyLandLocked(_hoomyLandOpen));
      break;
      case LevelDifficulty.alien:
      _alienLandOpen = true;
      notifyListeners();
      unawaited(_store.saveHoomyLandLocked(_hoomyLandOpen));
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
        return purpleLandOpen;
      case LevelDifficulty.alien:
        return alienLandOpen;
      case LevelDifficulty.blueWorld:
        return true;
    }
  }

}

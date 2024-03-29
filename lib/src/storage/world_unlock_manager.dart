
import 'dart:async';

import 'package:block_crusher/src/storage/persistence/world_unlock_manager_persistence.dart';
import 'package:flutter/foundation.dart';

import '../game/world_type.dart';

class WorldUnlockManager extends ChangeNotifier {
  final WorldUnlockManagerPersistence _store;

  bool _hoomyLandOpen = false;
  bool _seaLandOpen = false;
  bool _cityLandOpen = false;
  bool _purpleLandOpen = false;
  bool _purpleLandMathOpen = false;
  bool _alienLandOpen = false;


  WorldUnlockManager(WorldUnlockManagerPersistence store) : _store = store;

  bool get cityLandOpen => _cityLandOpen;
  bool get hoomyLandOpen => _hoomyLandOpen;
  bool get seaLandOpen => _seaLandOpen;
  bool get alienLandOpen => _alienLandOpen;
  bool get purpleLandOpen => _purpleLandOpen;
  bool get purpleLandMathOpen => _purpleLandMathOpen;

  Future<void> getLatestFromStore() async {
    await _getLatestUnlockedStatus();
  }

  Future<void> _getLatestUnlockedStatus() async {
    await _getLatestHoomyLandUnlockedStatus();
    await _getLatestCityLandUnlockedStatus();
    await _getLatestSeaLandUnlockedStatus();
    await _getLatestAlienLandUnlockedStatus();
    await _getLatestPurpleLandUnlockedStatus();
    await _getLatestPurpleLandMathUnlockedStatus();
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

    if (isPurpleLandOpen && !_purpleLandOpen) {
      _purpleLandOpen = isPurpleLandOpen;
      notifyListeners();
    }
  }
  Future<void> _getLatestPurpleLandMathUnlockedStatus() async {
    final isPurpleLandMathOpen = await _store.isPurpleLandMathOpen();

    if (!isPurpleLandMathOpen && _purpleLandMathOpen) {
      await _store.savePurpleLandMathLocked(_purpleLandMathOpen);
    }

    if (isPurpleLandMathOpen && !_purpleLandMathOpen) {
      _purpleLandMathOpen = isPurpleLandMathOpen;
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
    _purpleLandMathOpen = true;

    notifyListeners();
    await _store.saveCityLandLocked(_cityLandOpen);
    await _store.saveSeaLandLocked(_seaLandOpen);
    await _store.saveHoomyLandLocked(_hoomyLandOpen);
    await _store.saveAlienLandLocked(_alienLandOpen);
    await _store.savePurpleLandLocked(_purpleLandOpen);
    await _store.savePurpleLandMathLocked(_purpleLandMathOpen);
  }

  unlockWorld(WorldType levelDifficulty) {
    switch(levelDifficulty) {

      case WorldType.purpleWorldMath:
        _purpleLandMathOpen = true;
        notifyListeners();
        unawaited(_store.savePurpleLandMathLocked(_purpleLandMathOpen));
        break;
      case WorldType.soomyLand:
        return;
      case WorldType.hoomyLand:
        _hoomyLandOpen = true;
        notifyListeners();
        unawaited(_store.saveHoomyLandLocked(_hoomyLandOpen));
        break;
      case WorldType.seaLand:
        _seaLandOpen = true;
        notifyListeners();
        unawaited(_store.saveSeaLandLocked(_seaLandOpen));
        break;
      case WorldType.cityLand:
        _cityLandOpen = true;
        notifyListeners();
        unawaited(_store.saveCityLandLocked(_cityLandOpen));
        break;
      case WorldType.purpleWorld:
      _purpleLandOpen = true;
      notifyListeners();
      unawaited(_store.savePurpleLandLocked(_purpleLandOpen));
      break;
      case WorldType.alien:
      _alienLandOpen = true;
      notifyListeners();
      unawaited(_store.saveAlienLandLocked(_alienLandOpen));
      break;
    }
  }

  bool isWorldUnlocked(WorldType levelDifficulty) {
    switch(levelDifficulty) {
      case WorldType.purpleWorldMath:
        return purpleLandMathOpen;
      case WorldType.soomyLand:
        return true;
      case WorldType.hoomyLand:
        return hoomyLandOpen;
      case WorldType.seaLand:
        return seaLandOpen;
      case WorldType.cityLand:
        return cityLandOpen;
      case WorldType.purpleWorld:
        return purpleLandOpen;
      case WorldType.alien:
        return alienLandOpen;
    }
  }

  bool canBeOpened(WorldType levelDifficulty) {
    switch(levelDifficulty) {
      case WorldType.soomyLand:
      case WorldType.seaLand:
        return true;
      case WorldType.hoomyLand:
        return seaLandOpen;
      case WorldType.cityLand:
        return seaLandOpen && hoomyLandOpen;
      case WorldType.purpleWorld:
        return seaLandOpen && hoomyLandOpen && cityLandOpen;
      case WorldType.purpleWorldMath:
        return seaLandOpen && hoomyLandOpen && cityLandOpen && purpleLandOpen;
      case WorldType.alien:
        return seaLandOpen && hoomyLandOpen && cityLandOpen && purpleLandOpen && purpleLandMathOpen;
    }
  }

  bool isHiddenLevel(WorldType levelDifficulty) {
    switch (levelDifficulty) {
      case WorldType.soomyLand:
      case WorldType.seaLand:
      case WorldType.hoomyLand:
        return false;
      case WorldType.cityLand:
        return !seaLandOpen;
      case WorldType.purpleWorld:
        return !hoomyLandOpen;
      case WorldType.purpleWorldMath:
        return !cityLandOpen;
      case WorldType.alien:
        return !purpleLandOpen;
    }
  }

}

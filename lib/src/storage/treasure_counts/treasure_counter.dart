import 'dart:async';

import 'package:block_crusher/src/storage/treasure_counts/persistence/treasure_counter_persistence.dart';
import 'package:flutter/foundation.dart';

class TreasureCounter extends ChangeNotifier {
  final TreasureCounterPersistence _store;

  int _coinCount = 0;
  int _tegrommCount = 0;
  int _nutCount = 0;

  TreasureCounter(TreasureCounterPersistence store) : _store = store;

  int get coinCount => _coinCount;
  int get tegrommCount => _tegrommCount;
  int get nutCount => _nutCount;

  Future<void> getLatestFromStore() async {
    final updateCoinCount = await _getLatestCoinCount();
    final updateTegrommCount = await _getLatestTegrommCount();
    final updateNutCount =  await _getLatestNutCount();

    if(updateCoinCount || updateTegrommCount || updateNutCount) {
      notifyListeners();
    }
  }

  Future<bool> _getLatestCoinCount() async {
    final coinCount = await _store.getCoinCount();
    if (coinCount > _coinCount) {
      _coinCount = coinCount;
      return true;
    }
    else if (coinCount < _coinCount) {
      await _store.saveCoinCount(_coinCount);
    }

    return false;
  }

  Future<bool> _getLatestTegrommCount() async {
    final tegrommCount = await _store.getTegrommCount();
    if (tegrommCount > _tegrommCount) {
      _tegrommCount = tegrommCount;
      return true;
    }
    else if (tegrommCount < _tegrommCount) {
      await _store.saveTegrommCount(_tegrommCount);
    }

    return false;
  }

  Future<bool> _getLatestNutCount() async {
    final nutCount = await _store.getNutCount();
    if (nutCount > _nutCount) {
      _nutCount = nutCount;
      return true;
    }
    else if (nutCount < _nutCount) {
      await _store.saveNutCount(_nutCount);
    }

    return false;
  }

  void reset() async {
    _coinCount = 0;
    _tegrommCount = 0;
    _nutCount = 0;

    notifyListeners();
    await _store.saveCoinCount(_coinCount);
    await _store.saveNutCount(_nutCount);
    await _store.saveTegrommCount(_tegrommCount);
  }

  void cheat() async {
    _coinCount = 10000;
    _nutCount = 500;
    _tegrommCount = 500;

    await _store.saveCoinCount(_coinCount);
    await _store.saveTegrommCount(_tegrommCount);
    await _store.saveNutCount(_nutCount);
    notifyListeners();
  }

  void incrementCoinCount(int value) async{
    _coinCount += value;
      notifyListeners();
      unawaited(_store.saveCoinCount(coinCount));
  }

  void decreaseCoinCount(int value) async {
    _coinCount -= value;
    notifyListeners();
    unawaited(_store.saveCoinCount(coinCount));
  }

  void incrementTegrommCount(int value) async{
    _tegrommCount += value;
    notifyListeners();
    unawaited(_store.saveTegrommCount(_tegrommCount));
  }

  void decreaseTegrommCount(int value) async {
    _tegrommCount -= value;
    notifyListeners();
    unawaited(_store.saveTegrommCount(_tegrommCount));
  }

  void incrementNutCount(int value) async{
    _nutCount += value;
    notifyListeners();
    unawaited(_store.saveNutCount(_nutCount));
  }

  void decreaseNutCount(int value) async {
    _nutCount -= value;
    notifyListeners();
    unawaited(_store.saveNutCount(_nutCount));
  }
}

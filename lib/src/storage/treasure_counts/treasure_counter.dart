

import 'dart:async';

import 'package:block_crusher/src/storage/treasure_counts/persistence/treasure_counter_persistence.dart';
import 'package:flutter/foundation.dart';

class TreasureCounter extends ChangeNotifier {
  final TreasureCounterPersistence _store;


  int _coinCount = 0;

  TreasureCounter(TreasureCounterPersistence store) : _store = store;

  int get coinCount => _coinCount;

  Future<void> getLatestFromStore() async {
    await _getLatestCoinCount();

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

  void reset() async {
    _coinCount = 0;

    notifyListeners();
    await _store.saveCoinCount(_coinCount);
  }

  void cheat() async {
    _coinCount = 10000;
    await _store.saveCoinCount(_coinCount);
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
}

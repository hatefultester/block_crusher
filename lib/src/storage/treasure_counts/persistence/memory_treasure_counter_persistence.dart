

import 'package:block_crusher/src/storage/treasure_counts/persistence/treasure_counter_persistence.dart';

class MemoryOnlyTreasureCounterPersistence implements TreasureCounterPersistence {
  int coinCount = 0;
  int tegrommCount = 0;
  int nutCount = 0;

  @override
  Future<void> saveCoinCount(int value) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    coinCount = value;
  }

  @override
  Future<int> getCoinCount() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return coinCount;
  }

  @override
  Future<int> getNutCount() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return nutCount;
  }

  @override
  Future<int> getTegrommCount() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return tegrommCount;
  }

  @override
  Future<void> saveNutCount(int value) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    nutCount = value;
  }

  @override
  Future<void> saveTegrommCount(int value) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    tegrommCount = value;
  }
}

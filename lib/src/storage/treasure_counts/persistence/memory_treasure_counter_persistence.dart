

import 'package:block_crusher/src/storage/treasure_counts/persistence/treasure_counter_persistence.dart';

class MemoryOnlyTreasureCounterPersistence implements TreasureCounterPersistence {
  int coinCount = 0;

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
}

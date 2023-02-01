
abstract class TreasureCounterPersistence {
  Future<int> getCoinCount();
  Future<void> saveCoinCount(int value);
}

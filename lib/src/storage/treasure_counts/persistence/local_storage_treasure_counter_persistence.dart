
import 'package:block_crusher/src/storage/treasure_counts/persistence/treasure_counter_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageTreasureCounterPersistence extends TreasureCounterPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  @override
  Future<int> getCoinCount() async {
    final prefs = await instanceFuture;
    return prefs.getInt('coinCount') ?? 0;
  }

  @override
  Future<void> saveCoinCount(int value) async {
    final prefs = await instanceFuture;
    await prefs.setInt('coinCount', value);
  }
}

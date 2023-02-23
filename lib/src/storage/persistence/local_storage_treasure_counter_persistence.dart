
import 'package:block_crusher/src/storage/persistence/treasure_counter_persistence.dart';
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

  @override
  Future<int> getNutCount() async {
    final prefs = await instanceFuture;
    return prefs.getInt('nutCount') ?? 0;
  }

  @override
  Future<int> getTegrommCount() async {
    final prefs = await instanceFuture;
    return prefs.getInt('tegrommCount') ?? 0;
  }

  @override
  Future<void> saveNutCount(int value) async {
    final prefs = await instanceFuture;
    await prefs.setInt('nutCount', value);
  }

  @override
  Future<void> saveTegrommCount(int value) async {
    final prefs = await instanceFuture;
    await prefs.setInt('tegrommCount', value);
  }
}



import 'package:block_crusher/src/storage/player_inventory/persistence/player_inventory_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStoragePlayerInventoryPersistence extends PlayerInventoryPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  @override
  Future<int> getIndexOfSelectedBackgroundColorForProfile() async {
    final prefs = await instanceFuture;
    return prefs.getInt('selectedBackgroundColorIndexForProfile') ?? 0;
  }

  @override
  Future<void> saveIndexOfSelectedBackgroundColorForProfile(int value) async {
    final prefs = await instanceFuture;
    await prefs.setInt('selectedBackgroundColorIndexForProfile', value);
  }
}

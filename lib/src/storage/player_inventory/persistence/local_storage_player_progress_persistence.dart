

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

  @override
  Future<List<String>> getAvailableCharacters() async {
    final prefs = await instanceFuture;
    return prefs.getStringList('availableCharacters') ?? [];
  }

  @override
  Future<List<String>> getPlayerCharacters() async {
    final prefs = await instanceFuture;
    return prefs.getStringList('playerCharacters') ?? [];
  }

  @override
  Future<void> saveAvailableCharacters(List<String> values) async {
    final prefs = await instanceFuture;
    await prefs.setStringList('availableCharacters', values);
  }

  @override
  Future<void> savePlayerCharacters(List<String> values) async {
    final prefs = await instanceFuture;
    await prefs.setStringList('playerCharacters', values);
  }
}

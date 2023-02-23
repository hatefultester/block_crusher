
import 'package:block_crusher/src/storage/persistence/player_inventory_persistence.dart';

class MemoryOnlyPlayerInventoryPersistence implements PlayerInventoryPersistence {
  int selectedBackgroundColorIndexForProfile = 0;

  List<String> availableCharacters = [];

  List<String> playerCharacters = [];

  @override
  Future<int> getIndexOfSelectedBackgroundColorForProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return selectedBackgroundColorIndexForProfile;
  }

  @override
  Future<void> saveIndexOfSelectedBackgroundColorForProfile(int value) async  {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    selectedBackgroundColorIndexForProfile = value;
  }

  @override
  Future<List<String>> getAvailableCharacters() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return availableCharacters;
  }

  @override
  Future<List<String>> getPlayerCharacters() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return playerCharacters;
  }

  @override
  Future<void> saveAvailableCharacters(List<String> values) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    availableCharacters = values;
  }

  @override
  Future<void> savePlayerCharacters(List<String> values) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    playerCharacters = values;
  }
}

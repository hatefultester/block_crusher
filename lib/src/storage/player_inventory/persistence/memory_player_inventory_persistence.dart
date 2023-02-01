

import 'package:block_crusher/src/storage/player_inventory/persistence/player_inventory_persistence.dart';

class MemoryOnlyPlayerInventoryPersistence implements PlayerInventoryPersistence {
  int selectedBackgroundColorIndexForProfile = 0;

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
}

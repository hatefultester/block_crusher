
abstract class PlayerInventoryPersistence {

  Future<int> getIndexOfSelectedBackgroundColorForProfile();
  Future<void> saveIndexOfSelectedBackgroundColorForProfile(int value);

}

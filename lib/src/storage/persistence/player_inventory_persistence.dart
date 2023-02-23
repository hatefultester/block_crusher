
abstract class PlayerInventoryPersistence {

  Future<int> getIndexOfSelectedBackgroundColorForProfile();
  Future<void> saveIndexOfSelectedBackgroundColorForProfile(int value);

  Future<List<String>> getAvailableCharacters();
  Future<void> saveAvailableCharacters(List<String> values);

  Future<List<String>> getPlayerCharacters();
  Future<void> savePlayerCharacters(List<String> values);
}


import 'dart:convert';

import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/world_type.dart';
import 'package:block_crusher/src/utils/characters.dart';

class GameLevel {
  final GameType gameType;
  final WorldType worldType;

  final int levelId;
  final int miniGameId;
  final int characterId;

  final int coinCountOnWin;

  final int levelCoinPriceToOpen;
  bool get openByDefault => levelCoinPriceToOpen == 0 ? true : false;

  int get lives => worldType.defaultLives();

  final String? achievementIdIOS;
  final String? achievementIdAndroid;
  bool get awardsAchievement => achievementIdAndroid != null;

  String get winningCharacter {
    final character = imageSource[worldType.index][characterId];

    Map<String, dynamic> characterModelMap = {};
    characterModelMap['source'] = character['source'];

    return jsonEncode(characterModelMap);
  }

  const GameLevel(
      {required this.worldType,
        required this.levelId,
        required this.characterId,
        this.achievementIdIOS,
        this.achievementIdAndroid,
        this.gameType = GameType.collector,
        this.miniGameId = 0,
        this.coinCountOnWin = 50,
        this.levelCoinPriceToOpen = 0,})
      : assert(
  (achievementIdAndroid != null && achievementIdIOS != null) ||
      (achievementIdAndroid == null && achievementIdIOS == null),
  'Either both iOS and Android achievement ID must be provided, '
      'or none');
}

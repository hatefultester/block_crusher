
import 'dart:convert';

import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/world_type.dart';
import 'package:block_crusher/src/utils/in_game_characters.dart';

import '../../../games/collector_game/game_components/purple_land/purple_component.dart';
import '../../../games/collector_game/game_components/purple_math/purple_math_component.dart';
import '../../../games/collector_game/util/collector_game_helper.dart';

class GameLevel {
  final GameType gameType;
  final WorldType worldType;

  final int levelId;
  final int miniGameId;
  final int characterId;

  final String winningCharacterReference;

  final int coinCountOnWin;

  final int? gameGoal;

  final int levelCoinPriceToOpen;
  bool get openByDefault => levelCoinPriceToOpen == 0 ? true : false;

  final String? achievementIdIOS;
  final String? achievementIdAndroid;
  bool get awardsAchievement => achievementIdAndroid != null;

  final PurpleMode? purpleMode;
  final TrippieCharacterType? trippieCharacterType;
  final MathCharacterType? mathCharacterType;

  const GameLevel({
    required this.worldType,
        required this.levelId,
        required this.characterId,
        this.achievementIdIOS,
        this.achievementIdAndroid,
        this.gameType = GameType.collector,
        this.miniGameId = 0,
        this.coinCountOnWin = 50,
        this.levelCoinPriceToOpen = 0,
        this.winningCharacterReference = 'null', this.mathCharacterType,
        this.purpleMode, this.gameGoal, this.trippieCharacterType,
      })
      : assert(
  (achievementIdAndroid != null && achievementIdIOS != null) ||
      (achievementIdAndroid == null && achievementIdIOS == null),
  'Either both iOS and Android achievement ID must be provided, '
      'or none');
}

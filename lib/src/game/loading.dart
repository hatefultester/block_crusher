import 'package:block_crusher/src/game/collector_game.dart';
import 'package:block_crusher/src/game/collector_game_helper.dart';
import 'package:block_crusher/src/game/collector_game_level_state.dart';
import 'package:flutter/cupertino.dart';

extension LoadingPart on BlockCrusherGame {

  setBlockCrusherGameFromPlaySessionWidget(BuildContext context, CollectorGameLevelState state) {
    this.state = state;

    foodIndex = state.characterId - 1;
    maxCharacterIndex = state.items.length;
    if (maxCharacterIndex > 2) maxCharacterIndex = 2;

  }

  setVariablesBasedOnGameMode() {
    switch(gameMode) {
      case GameMode.classic:

        hasDifferentStartingBlock = false;
        hasSpecialEvents = false;
        generateCharacterFromLastLevel = true;

        blockFallSpeed = remoteConfig.getDefaultBlockFallbackSpeed();
        tickSpeed = remoteConfig.getDefaultTickSpeed();
        connectCoinCount = remoteConfig.getSoomyLandConnectCoinCount();

        break;
      case GameMode.hoomy:

        hasDifferentStartingBlock = false;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        blockFallSpeed = remoteConfig.getHoomyBlockFallbackSpeed();
        tickSpeed = remoteConfig.getHoomyTickSpeed();
        connectCoinCount = remoteConfig.getHoomyLandConnectCoinCount();

        break;
      case GameMode.sharks:
        hasDifferentStartingBlock = false;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        blockFallSpeed = remoteConfig.getSharkBlockFallbackSpeed();
        tickSpeed = remoteConfig.getSharkTickSpeed();
        connectCoinCount = remoteConfig.getSharkLandConnectCoinCount();

        break;
      case GameMode.cityFood:
        hasDifferentStartingBlock = true;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        blockFallSpeed = remoteConfig.getCityBlockFallbackSpeed();
        tickSpeed = remoteConfig.getCityTickSpeed();
        connectCoinCount = remoteConfig.getCityLandConnectCoinCount();

        break;
      case GameMode.purpleWorld:
        hasDifferentStartingBlock = true;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        blockFallSpeed = remoteConfig.getPurpleBlockFallbackSpeed();
        tickSpeed = remoteConfig.getPurpleTickSpeed();
        connectCoinCount = remoteConfig.getPurpleLandConnectCoinCount();

        purpleMode = state.level.purpleMode ?? PurpleMode.trippie;

        break;
      case GameMode.alien:
        hasDifferentStartingBlock = false;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        blockFallSpeed = remoteConfig.getAlienBlockFallbackSpeed();
        tickSpeed = remoteConfig.getAlienTickSpeed();
        connectCoinCount = remoteConfig.getAlienLandConnectCoinCount();

        break;
    }

    tickCounter = 0;
    generatedCounter = 0;
  }

}
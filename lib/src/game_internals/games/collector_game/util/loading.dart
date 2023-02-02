import 'package:block_crusher/src/game_internals/games/collector_game/collector_game.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/collector_game_level_state.dart';
import 'package:flutter/cupertino.dart';

import '../../../../google_play/remote_config/remote_config.dart';

extension LoadingPart on BlockCrusherGame {

  setBlockCrusherGameFromPlaySessionWidget(BuildContext context, CollectorGameLevelState state) {

    this.context = context;
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

        blockFallSpeed = RemoteConfigService.to.getDefaultBlockFallbackSpeed();
        tickSpeed = RemoteConfigService.to.getDefaultTickSpeed();
        connectCoinCount = RemoteConfigService.to.getSoomyLandConnectCoinCount();

        break;
      case GameMode.hoomy:

        hasDifferentStartingBlock = false;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        blockFallSpeed = RemoteConfigService.to.getHoomyBlockFallbackSpeed();
        tickSpeed = RemoteConfigService.to.getHoomyTickSpeed();
        connectCoinCount = RemoteConfigService.to.getHoomyLandConnectCoinCount();

        break;
      case GameMode.sharks:
        hasDifferentStartingBlock = false;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        blockFallSpeed = RemoteConfigService.to.getSharkBlockFallbackSpeed();
        tickSpeed = RemoteConfigService.to.getSharkTickSpeed();
        connectCoinCount = RemoteConfigService.to.getSharkLandConnectCoinCount();

        break;
      case GameMode.cityFood:
        hasDifferentStartingBlock = true;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        blockFallSpeed = RemoteConfigService.to.getCityBlockFallbackSpeed();
        tickSpeed = RemoteConfigService.to.getCityTickSpeed();
        connectCoinCount = RemoteConfigService.to.getCityLandConnectCoinCount();

        break;
      case GameMode.purpleWorld:
        hasDifferentStartingBlock = true;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        blockFallSpeed = RemoteConfigService.to.getPurpleBlockFallbackSpeed();
        tickSpeed = RemoteConfigService.to.getPurpleTickSpeed();
        connectCoinCount = RemoteConfigService.to.getPurpleLandConnectCoinCount();

        if (state.characterId == 1) {
          purpleMode = PurpleMode.trippie;
        } else {
          purpleMode = PurpleMode.counter;
        }
        break;
      case GameMode.alien:
        hasDifferentStartingBlock = false;
        hasSpecialEvents = true;
        generateCharacterFromLastLevel = false;
        blockFallSpeed = RemoteConfigService.to.getAlienBlockFallbackSpeed();
        tickSpeed = RemoteConfigService.to.getAlienTickSpeed();
        connectCoinCount = RemoteConfigService.to.getAlienLandConnectCoinCount();

        break;
    }

    tickCounter = 0;
    generatedCounter = 0;
  }

}
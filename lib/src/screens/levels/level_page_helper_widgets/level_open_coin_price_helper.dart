import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/world_type.dart';
import 'package:block_crusher/src/google_play/remote_config/remote_config.dart';

extension CoinPriceExtension on WorldType {
  int coinPrice(RemoteConfig remoteConfig) {
    switch(this) {
      case WorldType.soomyLand:
        return 0;
      case WorldType.purpleWorld:
        return remoteConfig.getPurpleLandCoinPrice();
      case WorldType.alien:
        return remoteConfig.getAlienLandCoinPrice();
      case WorldType.hoomyLand:
        return remoteConfig.getHoomyLandCoinPrice();
      case WorldType.seaLand:
        return remoteConfig.getSeaLandCoinPrice();
      case WorldType.cityLand:
        return remoteConfig.getCityLandCoinPrice();
    }
  }
}
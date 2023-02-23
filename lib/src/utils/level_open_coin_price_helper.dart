
import 'package:block_crusher/src/game/world_type.dart';
import 'package:block_crusher/src/services/remote_config.dart';

extension CoinPriceExtension on WorldType {
  int coinPrice(RemoteConfigProvider remoteConfig) {
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
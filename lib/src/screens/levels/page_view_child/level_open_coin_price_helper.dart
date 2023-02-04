import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/world_type.dart';
import 'package:block_crusher/src/google_play/remote_config/remote_config.dart';

extension CoinPriceExtension on WorldType {
  int coinPrice() {
    switch(this) {
      case WorldType.soomyLand:
        return 0;
      case WorldType.purpleWorld:
        return RemoteConfigService.to.getPurpleLandCoinPrice();
      case WorldType.alien:
        return RemoteConfigService.to.getAlienLandCoinPrice();
      case WorldType.hoomyLand:
        return RemoteConfigService.to.getHoomyLandCoinPrice();
      case WorldType.seaLand:
        return RemoteConfigService.to.getSeaLandCoinPrice();
      case WorldType.cityLand:
        return RemoteConfigService.to.getCityLandCoinPrice();
    }
  }
}
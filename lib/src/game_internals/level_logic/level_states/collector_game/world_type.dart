import 'package:block_crusher/src/google_play/remote_config/remote_config.dart';

enum WorldType {
  soomyLand,
  hoomyLand,
  seaLand,
  cityLand,
  purpleWorld,
  alien;

  int defaultLives() {

    int lives = 3;

    switch (this) {

      case WorldType.soomyLand:
        lives = RemoteConfigService.to.getSoomyLandLives();
        break;
      case WorldType.hoomyLand:
        lives = RemoteConfigService.to.getHoomyLandLives();
        break;
      case WorldType.seaLand:
        lives = RemoteConfigService.to.getSharkLandLives();
        break;
      case WorldType.cityLand:
        lives = RemoteConfigService.to.getCityLandLives();
        break;
      case WorldType.purpleWorld:
        lives = RemoteConfigService.to.getPurpleLandLives();
        break;
      case WorldType.alien:
        lives = RemoteConfigService.to.getAlienLandLives();
        break;
    }

    return lives;
  }
}

enum GameType {
  coinPicker,
  collector,
  ;

  defaultLives() {
    switch (this) {
      case GameType.coinPicker:
        return 5;
      case GameType.collector:
        return 100;
    }
  }
}
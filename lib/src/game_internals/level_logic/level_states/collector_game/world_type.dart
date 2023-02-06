import 'package:block_crusher/src/google_play/remote_config/remote_config.dart';

enum WorldType {
  soomyLand,
  seaLand,
  hoomyLand,
  cityLand,
  purpleWorld,
  alien;

  int defaultLives(RemoteConfig remoteConfig) {
    int lives = 3;

    switch (this) {

      case WorldType.soomyLand:
        lives = remoteConfig.getSoomyLandLives();
        break;
      case WorldType.hoomyLand:
        lives = remoteConfig.getHoomyLandLives();
        break;
      case WorldType.seaLand:
        lives = remoteConfig.getSharkLandLives();
        break;
      case WorldType.cityLand:
        lives = remoteConfig.getCityLandLives();
        break;
      case WorldType.purpleWorld:
        lives = remoteConfig.getPurpleLandLives();
        break;
      case WorldType.alien:
        lives = remoteConfig.getAlienLandLives();
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
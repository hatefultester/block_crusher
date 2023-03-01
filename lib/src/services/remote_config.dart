
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import 'remote_config_keys.dart';

const Duration remoteConfigFetchTimeout = Duration(minutes:1);

const Duration remoteConfigMinimumFetchInterval = Duration(hours: 1);

class RemoteConfigProvider extends ChangeNotifier {
  final remoteConfig = FirebaseRemoteConfig.instance;

  final Map<String, dynamic> _defaultParameters = {
    RemoteConfigKey.defaultFallbackSpeed : 1.1,
    RemoteConfigKey.alienFallbackSpeed : 1.2,
    RemoteConfigKey.purpleFallbackSpeed : 1.2,
    RemoteConfigKey.cityFallbackSpeed : 1.2,
    RemoteConfigKey.hoomyFallbackSpeed : 1.3,
    RemoteConfigKey.defaultTickSpeed : 150,
    RemoteConfigKey.alienTickSpeed : 120,
    RemoteConfigKey.purpleTickSpeed : 120,
    RemoteConfigKey.cityTickSpeed : 140,
    RemoteConfigKey.hoomyTickSpeed : 130,
    RemoteConfigKey.sharkTickSpeed : 135,
    RemoteConfigKey.sharkFallbackSpeed : 1.3,
    RemoteConfigKey.cityLandCoinPrice: 3500,
    RemoteConfigKey.hoomyLandCoinPrice: 2500,
    RemoteConfigKey.seaLandCoinPrice: 1200,
    RemoteConfigKey.purpleLandCoinPrice: 5000,
    RemoteConfigKey.alienLandCoinPrice: 10000,
    RemoteConfigKey.alienLives : 3,
    RemoteConfigKey.seaLives : 3,
    RemoteConfigKey.soomyLives : 3,
    RemoteConfigKey.hoomyLives : 3,
    RemoteConfigKey.purpleLives : 3,
    RemoteConfigKey.soomyCoinCount: 5,
    RemoteConfigKey.hoomyCoinCount: 15,
    RemoteConfigKey.sharkCoinCount: 10,
    RemoteConfigKey.purpleCoinCount: 25,
    RemoteConfigKey.alienCoinCount: 30,
};

  Future<void> init() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: remoteConfigFetchTimeout,
      minimumFetchInterval: remoteConfigMinimumFetchInterval,
    ));

    await remoteConfig.setDefaults(_defaultParameters);

    remoteConfig.fetchAndActivate();

    remoteConfig.getAll().forEach((key, value) {
      debugPrint('REMOTE CONFIG KEY : ${key.toString()}, VALUE : ${value.asString()}');
    });
  }

  double getDefaultBlockFallbackSpeed() => _getDouble(RemoteConfigKey.defaultFallbackSpeed);
  double getAlienBlockFallbackSpeed() => _getDouble(RemoteConfigKey.alienFallbackSpeed);
  double getPurpleBlockFallbackSpeed() => _getDouble(RemoteConfigKey.purpleFallbackSpeed);
  double getHoomyBlockFallbackSpeed() => _getDouble(RemoteConfigKey.hoomyFallbackSpeed);
  double getCityBlockFallbackSpeed() => _getDouble(RemoteConfigKey.cityFallbackSpeed);
  double getSharkBlockFallbackSpeed() => _getDouble(RemoteConfigKey.sharkFallbackSpeed);

  int getDefaultTickSpeed() => _getInt(RemoteConfigKey.defaultTickSpeed);
  int getAlienTickSpeed() => _getInt(RemoteConfigKey.alienTickSpeed);
  int getPurpleTickSpeed() => _getInt(RemoteConfigKey.purpleTickSpeed);
  int getCityTickSpeed() => _getInt(RemoteConfigKey.cityTickSpeed);
  int getHoomyTickSpeed() => _getInt(RemoteConfigKey.hoomyTickSpeed);
  int getSharkTickSpeed() => _getInt(RemoteConfigKey.sharkTickSpeed);

  int getCityLandCoinPrice() => _getInt(RemoteConfigKey.cityLandCoinPrice);
  int getSeaLandCoinPrice() => _getInt(RemoteConfigKey.seaLandCoinPrice);
  int getHoomyLandCoinPrice() => _getInt(RemoteConfigKey.hoomyLandCoinPrice);
  int getAlienLandCoinPrice() => _getInt(RemoteConfigKey.alienLandCoinPrice);
  int getPurpleLandCoinPrice() => _getInt(RemoteConfigKey.purpleLandCoinPrice);

  int getSoomyLandLives() => _getInt(RemoteConfigKey.soomyLives);
  int getHoomyLandLives() => _getInt(RemoteConfigKey.hoomyLives);
  int getSharkLandLives() => _getInt(RemoteConfigKey.seaLives);
  int getCityLandLives() => _getInt(RemoteConfigKey.cityLives);
  int getAlienLandLives() => _getInt(RemoteConfigKey.alienLives);
  int getPurpleLandLives() => _getInt(RemoteConfigKey.purpleLives);

  int getSoomyLandConnectCoinCount() => _getInt(RemoteConfigKey.soomyCoinCount);
  int getHoomyLandConnectCoinCount() => _getInt(RemoteConfigKey.hoomyCoinCount);
  int getSharkLandConnectCoinCount() => _getInt(RemoteConfigKey.sharkCoinCount);
  int getCityLandConnectCoinCount() => _getInt(RemoteConfigKey.cityCoinCount);
  int getPurpleLandConnectCoinCount() => _getInt(RemoteConfigKey.purpleCoinCount);
  int getAlienLandConnectCoinCount() => _getInt(RemoteConfigKey.alienCoinCount);

  _getInt(String key) {
    var result = remoteConfig.getInt(key);
    debugPrint('GETTING KEY : ${key.toString()}  || Result : ${result.toString()}');

    return result;
  }

  _getDouble(String key) {
    var result = remoteConfig.getDouble(key);
    debugPrint('GETTING KEY : ${key.toString()}  || Result : ${result.toString()}');

    return result;
  }
}
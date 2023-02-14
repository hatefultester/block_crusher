
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
    RemoteConfigKey.cityLandCoinPrice: 1000,
    RemoteConfigKey.hoomyLandCoinPrice: 1500,
    RemoteConfigKey.seaLandCoinPrice: 1200,
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
  int getAlienLandCoinPrice() => 2000; //todo
  int getPurpleLandCoinPrice() => 2000; //todo

  int getSoomyLandLives() => 3; // todo
  int getHoomyLandLives() => 10; // todo
  int getSharkLandLives() => 20; // todo
  int getCityLandLives() => 50; // todo
  int getAlienLandLives() => 3; // todo
  int getPurpleLandLives() => 3; // todo

  int getSoomyLevelBonusPrice() => 50; // todo
  int getHoomyLevelBonusPrice() => 100; // todo
  int getSharkLevelBonusPrice() => 200; // todo
  int getCityLevelBonusPrice() => 250; // todo

  int getSoomyLandConnectCoinCount() => 5; //todo
  int getHoomyLandConnectCoinCount() => 10; //todo
  int getSharkLandConnectCoinCount() => 15; //todo
  int getCityLandConnectCoinCount() => 20; //todo
  int getPurpleLandConnectCoinCount() => 25; //todo
  int getAlienLandConnectCoinCount() => 30; //todo

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
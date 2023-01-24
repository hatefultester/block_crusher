
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'remote_config_keys.dart';

const Duration remoteConfigFetchTimeout = Duration(minutes:1);

const Duration remoteConfigMinimumFetchInterval = Duration(minutes: 1);

class RemoteConfigService extends GetxService {
  static RemoteConfigService get to => Get.find();

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
  };

  Future<RemoteConfigService> init() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: remoteConfigFetchTimeout,
      minimumFetchInterval: remoteConfigMinimumFetchInterval,
    ));

    await remoteConfig.setDefaults(_defaultParameters);

    remoteConfig.fetchAndActivate();

    remoteConfig.getAll().forEach((key, value) {
      debugPrint('REMOTE CONFIG KEY : ${key.toString()}, VALUE : ${value.asString()}');
    });

    return this;
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
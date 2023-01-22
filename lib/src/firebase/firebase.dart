import 'package:block_crusher/src/firebase/firebase_keys.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

const Duration remoteConfigFetchTimeout = Duration(minutes:1);

const Duration remoteConfigMinimumFetchInterval = Duration(minutes: 1);

class FirebaseService extends GetxService {
  static FirebaseService get to => Get.find();

  final remoteConfig = FirebaseRemoteConfig.instance;

  final Map<String, dynamic> _defaultParameters = {
    FirebaseKey.defaultFallbackSpeed : 1.1,
    FirebaseKey.alienFallbackSpeed : 1.2,
    FirebaseKey.purpleFallbackSpeed : 1.2,
    FirebaseKey.cityFallbackSpeed : 1.2,
   FirebaseKey.hoomyFallbackSpeed : 1.3,
    FirebaseKey.defaultTickSpeed : 150,
    FirebaseKey.alienTickSpeed : 120,
    FirebaseKey.purpleTickSpeed : 120,
    FirebaseKey.cityTickSpeed : 140,
    FirebaseKey.hoomyTickSpeed : 130,
    FirebaseKey.sharkTickSpeed : 135,
    FirebaseKey.sharkFallbackSpeed : 1.3,
  };

  Future<FirebaseService> init() async {
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

  double getDefaultBlockFallbackSpeed() => _getDouble(FirebaseKey.defaultFallbackSpeed);
  double getAlienBlockFallbackSpeed() => _getDouble(FirebaseKey.alienFallbackSpeed);
  double getPurpleBlockFallbackSpeed() => _getDouble(FirebaseKey.purpleFallbackSpeed);
  double getHoomyBlockFallbackSpeed() => _getDouble(FirebaseKey.hoomyFallbackSpeed);
  double getCityBlockFallbackSpeed() => _getDouble(FirebaseKey.cityFallbackSpeed);
  double getSharkBlockFallbackSpeed() => _getDouble(FirebaseKey.sharkFallbackSpeed);

  int getDefaultTickSpeed() => _getInt(FirebaseKey.defaultTickSpeed);
  int getAlienTickSpeed() => _getInt(FirebaseKey.alienTickSpeed);
  int getPurpleTickSpeed() => _getInt(FirebaseKey.purpleTickSpeed);
  int getCityTickSpeed() => _getInt(FirebaseKey.cityTickSpeed);
  int getHoomyTickSpeed() => _getInt(FirebaseKey.hoomyTickSpeed);
  int getSharkTickSpeed() => _getInt(FirebaseKey.sharkTickSpeed);

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
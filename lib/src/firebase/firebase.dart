import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';

const Duration remoteConfigFetchTimeout = Duration(minutes:1);

const Duration remoteConfigMinimumFetchInterval = Duration(minutes: 1);

class FirebaseService extends GetxService {
  static FirebaseService get to => Get.find();

  final remoteConfig = FirebaseRemoteConfig.instance;

  final Map<String, dynamic> _defaultParameters = {
    "collectorGameDefaultBlockFallbackSpeed" : 0.7,
    "collectorGameDefaultTickSpeed" : 150,
  };

  Future<FirebaseService> init() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: remoteConfigFetchTimeout,
      minimumFetchInterval: remoteConfigMinimumFetchInterval,
    ));

    await remoteConfig.setDefaults(_defaultParameters);

    remoteConfig.fetchAndActivate();

    remoteConfig.getAll().forEach((key, value) {
      print('REMOTE CONFIG KEY : ${key.toString()}, VALUE : ${value.asString()}');
    });

    return this;
  }

  double getDefaultBlockFallbackSpeed() {
    print('GETTING DEF VALUE BLOCK FALLBACK ${remoteConfig.getDouble('collectorGameDefaultBlockFallbackSpeed')}');

    return  remoteConfig.getDouble('collectorGameDefaultBlockFallbackSpeed');
  }

  int getDefaultTickSpeed() {
    print('GETTING DEF VALUE TICK SPEED ${remoteConfig.getInt('collectorGameDefaultTickSpeed')}');

    return remoteConfig.getInt('collectorGameDefaultTickSpeed');
  }

}
import 'package:block_crusher/src/game/world_type.dart';

/// World description strings
///

const List<String> _soomyLandDescriptions = [];
const List<String> _hoomyLandDescriptions = [];
const List<String> _sharkLandDescriptions = [];
const List<String> _purpleLandDescriptions = [];
const List<String> _cityLandDescriptions = [];
const List<String> _alienLandDescriptions = [];

extension WorldDescriptionTexts on WorldType {
  List<String> getDescriptions() {
    switch (this) {
      case WorldType.soomyLand: return _soomyLandDescriptions;
        case WorldType.seaLand: return _sharkLandDescriptions;
      case WorldType.hoomyLand: return _hoomyLandDescriptions;
      case WorldType.cityLand: return _cityLandDescriptions;
      case WorldType.purpleWorld: return _purpleLandDescriptions;
      case WorldType.alien: return _alienLandDescriptions;
      case WorldType.purpleWorldMath:
        return [];
        break;
    }
  }
}
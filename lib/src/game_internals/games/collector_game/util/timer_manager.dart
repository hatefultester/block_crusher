import 'dart:math';
import 'dart:ui';

import 'package:block_crusher/src/game_internals/games/collector_game/collector_game.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/hoomy_land/hoomy_weapon_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/purple_land/purple_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/purple_math/purple_math_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/shark_land/shark_enemy_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/game_components/soomy_land/sprite_block_component.dart';
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/settings/app_lifecycle/app_lifecycle.dart';
import 'dart:async' as dart_async;

extension TimerManager on BlockCrusherGame {

  startTimer() {
    if (timer == null) {
      _startTimer();
    }
  }

  _startTimer() async {
    Random random = Random();

    timer = dart_async.Timer.periodic(const Duration(milliseconds: 15),
            (timer) async {

          if(AppLifecycleObserver.appState == AppLifecycleState.paused) return;

          tickCounter++;

          if (tickCounter != tickSpeed) return;

          tickCounter = 0;

          generatedCounter++;

          if(hasDifferentStartingBlock) {
            if(gameMode == GameMode.cityFood) {
              await add(SpriteBlockComponent.withLevelSet(
                  _generatedIndexNumber(random), difficulty),);
            }


            if(gameMode == GameMode.purpleWorld) {
              if (purpleMode == PurpleMode.trippie) {
                final int index = random.nextInt(5);

                final PurpleWorldComponent newPurpleComponent = PurpleWorldComponent(
                    _generatedIndexNumber(random), TrippieCharacterType.values.elementAt(index));
                await add(newPurpleComponent);
                purpleWorldComponents.add(newPurpleComponent);
              }
              if (purpleMode == PurpleMode.counterToFive) {
                await add(PurpleMathComponent(_generatedIndexNumber(random), type: mathCharacterType!));
              }
            }
          } else {
            await add(SpriteBlockComponent(difficulty));
          }


          /// special events
          if(!hasSpecialEvents) return;
          if(generatedCounter % 2 != 0) return;

          if (gameMode == GameMode.hoomy) {
            await add(HoomyWeaponComponent());
          }

          if (gameMode == GameMode.sharks) {
            await add(SharkEnemyComponent());
          }
        });
  }


  _generatedIndexNumber(Random random) {
    int generatedIndexNumber = 0;
    if(gameMode == GameMode.cityFood) {
      if (maxCharacterIndex != 0) {
        generatedIndexNumber = random.nextInt(maxCharacterIndex);
      } else {
        generatedIndexNumber = 0;
      }
      //debugPrint('debug gen: $generatedIndexNumber');
      if (generatedIndexNumber > 0) {
        generatedIndexNumber = random.nextInt(maxCharacterIndex);
        if (generatedIndexNumber > 1) {
          generatedIndexNumber = random.nextInt(maxCharacterIndex);
        }
      }
    }

    if(gameMode == GameMode.purpleWorld) {
      if(purpleMode == PurpleMode.trippie) {
        generatedIndexNumber = random.nextInt(4) + 1;
      }
      if (purpleMode == PurpleMode.counterToFive) {
        generatedIndexNumber = random.nextInt(4);
        if(generatedIndexNumber >= 2) {
          if (random
              .nextInt(10)
              .isEven) {
            generatedIndexNumber = random.nextInt(2);
          }
        }
      }
    }

    return generatedIndexNumber;
  }

}
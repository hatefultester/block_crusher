import 'dart:async';

import 'package:block_crusher/src/game_internals/games/collector_game/collector_game.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/collector_game_level_state.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/level.dart';
import 'package:block_crusher/src/google_play/games_services/games_services.dart';
import 'package:block_crusher/src/google_play/games_services/score.dart';
import 'package:block_crusher/src/screens/play_session/scenarios/player_die_scenario.dart';
import 'package:block_crusher/src/screens/play_session/scenarios/player_won_scenario.dart';
import 'package:block_crusher/src/screens/play_session/styles/item_background_color_extension.dart';
import 'package:block_crusher/src/screens/play_session/widgets/bottom_layer/city_level_bottom.dart';
import 'package:block_crusher/src/screens/play_session/widgets/bottom_layer/default_bottom.dart';
import 'package:block_crusher/src/screens/play_session/widgets/top_layer/default_top.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/settings/audio/sounds.dart';
import 'package:block_crusher/src/storage/game_achievements/game_achievements.dart';
import 'package:block_crusher/src/storage/level_statistics/level_statistics.dart';
import 'package:block_crusher/src/storage/treasure_counts/treasure_counter.dart';
import 'package:block_crusher/src/utils/in_game_characters.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../game_internals/level_logic/level_states/collector_game/world_type.dart';
import '../../style/confetti.dart';
import '../../style/palette.dart';



class PlaySessionScreen extends StatefulWidget {
  final GameLevel level;

  const PlaySessionScreen(this.level, {super.key});

  @override
  State<PlaySessionScreen> createState() => PlaySessionScreenState();
}

class PlaySessionScreenState extends State<PlaySessionScreen> {

  final celebrationDuration = const Duration(milliseconds: 2500);
  final preCelebrationDuration = const Duration(milliseconds: 750);

  bool duringCelebration = false;
  bool duringLost = false;

  late BlockCrusherGame blockCrusherGame;
  late DateTime startOfPlay;
  late Color itemBackgroundColor;
  late Color itemTextColor;

  @override
  Widget build(BuildContext context) {

  //  var adsController = AdsController(MobileAds.instance);
  //  adsController.preloadAd();

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => CollectorGameLevelState(
              level: widget.level,
              levelType: widget.level.gameType,
              levelDifficulty: widget.level.worldType,
              goal: widget.level.characterId,
              characterId: widget.level.characterId,
              onDie: playerDie,
              onWin: playerWon,
            ),
          ),
        ],
        child: IgnorePointer(
          ignoring: duringCelebration,
          child: Scaffold(
            body: Stack(
              children: [
                _gameWidget(),
                _appLayer(),
                _celebrationWidget(),
                _loseWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  _appLayer() {
    return Column(
      children: [_topAppLayer(), const Spacer(), _bottomAppLayer()],
    );
  }

  _topAppLayer() {
    /// for coin picker => 'assets/images/${imageSource[widget.level.levelDifficulty.index][levelState.level]['source']}'
    String imagePath = 'assets/images/${imageSource[widget.level.worldType.index][widget.level.characterId]['source']}';
    String title = 'Level ${widget.level.levelId}';

    return DefaultTopWidget(title: title , imagePath: imagePath,);
  }

  _bottomAppLayer() {
    if (widget.level.worldType == WorldType.cityLand) {
      return const CityLevelBottomWidget();
    }

    if (widget.level.worldType == WorldType.purpleWorld) {
      if(widget.level.characterId == 1) {

      }
      if(widget.level.characterId == 2) {

      }
    }

    return DefaultBottomWidget(startOfPlay: startOfPlay, itemTextColor: itemTextColor, itemBackgroundColor: itemBackgroundColor,);
  }

  _gameWidget() {
    return Consumer<CollectorGameLevelState>(
      builder: (context, levelState, child) {
        return
        GameWidget(
            game: blockCrusherGame.setGame(context, levelState));
      });
  }

  _celebrationWidget() {
    return SizedBox.expand(
      child: Visibility(
        visible: duringCelebration,
        child: IgnorePointer(
          child: Confetti(
            isStopped: !duringCelebration,
          ),
        ),
      ),
    );
  }

  _loseWidget() {
    return SizedBox.expand(
      child: Visibility(
        visible: duringLost,
        child: IgnorePointer(
          child: Confetti(lost: true,
            isStopped: !duringLost,
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    final achievements = context.read<GameAchievements>();
    final audio = context.read<AudioController>();

    blockCrusherGame = BlockCrusherGame(widget.level.worldType, achievements: achievements, audio: audio);

    startOfPlay = DateTime.now();
    itemBackgroundColor = widget.level.worldType.getItemBackgroundColor();
    itemTextColor = widget.level.worldType.getItemTextColor();
  }
}

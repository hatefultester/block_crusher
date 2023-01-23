// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:block_crusher/src/screens/play_session/styles/item_background_color_extension.dart';
import 'package:block_crusher/src/screens/play_session/widgets/bottom_layer/city_level_bottom.dart';
import 'package:block_crusher/src/screens/play_session/widgets/bottom_layer/default_bottom.dart';
import 'package:block_crusher/src/screens/play_session/widgets/top_layer/default_top.dart';
import 'package:block_crusher/src/utils/characters.dart';
import 'package:block_crusher/src/game_internals/collector_game/collector_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

import '../../audio/audio_controller.dart';
import '../../audio/sounds.dart';
import '../../level_selection/level_states/collector_game/collector_game_level_state.dart';
import '../../games_services/games_services.dart';
import '../../games_services/score.dart';
import '../../level_selection/levels.dart';
import '../../player_progress/player_progress.dart';
import '../../style/confetti.dart';
import '../../style/palette.dart';


const _celebrationDuration = Duration(milliseconds: 2000);

const _preCelebrationDuration = Duration(milliseconds: 500);

class PlaySessionScreen extends StatefulWidget {
  final GameLevel level;

  const PlaySessionScreen(this.level, {super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {

  bool _duringCelebration = false;

  late BlockCrusherGame _blockCrusherGame;

  late DateTime _startOfPlay;

  late Color _itemBackgroundColor;
  late Color _itemTextColor;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

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
              levelType: widget.level.levelType,
              levelDifficulty: widget.level.levelDifficulty,
              goal: widget.level.characterId,
              maxLives: 3,//widget.level.lives,
              characterId: widget.level.characterId,
              onDie: _playerDie,
              onWin: _playerWon,
            ),
          ),
        ],
        child: IgnorePointer(
          ignoring: _duringCelebration,
          child: Scaffold(
            backgroundColor: palette.backgroundPlaySession,
            body: Stack(
              children: [
                _gameWidget(),
                _appLayer(),
                _celebrationWidget(),
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
    String imagePath = 'assets/images/${imageSource[widget.level.levelDifficulty.index][widget.level.characterId]['source']}';
    String title = 'Level ${widget.level.levelId}';

    return DefaultTopWidget(title: title , imagePath: imagePath,);
  }

  _bottomAppLayer() {
    if (widget.level.levelDifficulty == LevelDifficulty.cityLand) {
      return const CityLevelBottomWidget();
    }

    if (widget.level.levelDifficulty == LevelDifficulty.purpleWorld) {
      if(widget.level.characterId == 1) {

      }
      if(widget.level.characterId == 2) {

      }
    }

    return DefaultBottomWidget(startOfPlay: _startOfPlay, itemTextColor: _itemTextColor, itemBackgroundColor: _itemBackgroundColor,);
  }

  _gameWidget() {
    return Consumer<CollectorGameLevelState>(
      builder: (context, levelState, child) {
        return
        GameWidget(
            game: _blockCrusherGame.setGame(context, levelState));
      });
  }

  _celebrationWidget() {
    return SizedBox.expand(
      child: Visibility(
        visible: _duringCelebration,
        child: IgnorePointer(
          child: Confetti(
            isStopped: !_duringCelebration,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _blockCrusherGame = BlockCrusherGame(widget.level.levelDifficulty);

    _startOfPlay = DateTime.now();
    _itemBackgroundColor = widget.level.levelDifficulty.getItemBackgroundColor();
    _itemTextColor = widget.level.levelDifficulty.getItemTextColor();
  }

  Future<void> _playerDie() async {
    // TODO

    _playerWon();
  }

  Future<void> _playerWon() async {

    final score = Score(
      widget.level.levelId,
      widget.level.levelId,
      DateTime.now().difference(_startOfPlay),
    );
    final audioController = context.read<AudioController>();
    final playerProgress = context.read<PlayerProgress>();
    playerProgress
      ..setLevelReached(widget.level.levelId)
    ..incrementCoinCount(widget.level.coinCount);

    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      _duringCelebration = true;
    });

    final gamesServicesController = context.read<GamesServicesController?>();

    await Future<void>.delayed(const Duration(milliseconds: 200));

    audioController.playSfx(SfxType.congrats);

    if (gamesServicesController != null) {
      // Award achievement.
      if (widget.level.awardsAchievement) {
        await gamesServicesController.awardAchievement(
          android: widget.level.achievementIdAndroid!,
          iOS: widget.level.achievementIdIOS!,
        );
      }

      // Send score to leaderboard.
      await gamesServicesController.submitLeaderboardScore(score);
    }

    /// Give the player some time to see the celebration animation.
    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).go('/play/won', extra: {'score': score});
  }
}

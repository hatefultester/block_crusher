import 'dart:async';

import 'package:block_crusher/src/game_internals/games/collector_game/collector_game.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/collector_game_level_state.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/level.dart';
import 'package:block_crusher/src/google_play/games_services/games_services.dart';
import 'package:block_crusher/src/google_play/games_services/score.dart';
import 'package:block_crusher/src/screens/play_session/styles/item_background_color_extension.dart';
import 'package:block_crusher/src/screens/play_session/widgets/bottom_layer/city_level_bottom.dart';
import 'package:block_crusher/src/screens/play_session/widgets/bottom_layer/default_bottom.dart';
import 'package:block_crusher/src/screens/play_session/widgets/top_layer/default_top.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/settings/audio/sounds.dart';
import 'package:block_crusher/src/storage/level_statistics/level_statistics.dart';
import 'package:block_crusher/src/storage/treasure_counts/treasure_counter.dart';
import 'package:block_crusher/src/utils/characters.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../game_internals/level_logic/level_states/collector_game/world_type.dart';
import '../../style/confetti.dart';
import '../../style/palette.dart';


const _celebrationDuration = Duration(milliseconds: 2500);

const _preCelebrationDuration = Duration(milliseconds: 750);

class PlaySessionScreen extends StatefulWidget {
  final GameLevel level;

  const PlaySessionScreen(this.level, {super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {

  bool _duringCelebration = false;
  bool _duringLost = false;

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
              level: widget.level,
              levelType: widget.level.gameType,
              levelDifficulty: widget.level.worldType,
              goal: widget.level.characterId,
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
                _debugButton(),
                _celebrationWidget(),
                _loseWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _debugButton() {
    return const SizedBox.shrink();
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

  _loseWidget() {
    return SizedBox.expand(
      child: Visibility(
        visible: _duringLost,
        child: IgnorePointer(
          child: Confetti(lost: true,
            isStopped: !_duringLost,
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _blockCrusherGame = BlockCrusherGame(widget.level.worldType);

    _startOfPlay = DateTime.now();
    _itemBackgroundColor = widget.level.worldType.getItemBackgroundColor();
    _itemTextColor = widget.level.worldType.getItemTextColor();
  }

  Future<void> _playerDie() async {
    final score = Score(
      widget.level.levelId,
      widget.level.levelId,
      DateTime.now().difference(_startOfPlay),
    );
    final audioController = context.read<AudioController>();
    final treasureCounter = context.read<TreasureCounter>();
    treasureCounter
      .incrementCoinCount(widget.level.coinCountOnWin);

    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      _duringLost = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 200));

    audioController.playSfx(SfxType.lost);

    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).go('/play/lost', extra: {'score': score});
  }

  Future<void> _playerWon() async {

    final score = Score(
      widget.level.levelId,
      widget.level.levelId,
      DateTime.now().difference(_startOfPlay),
    );
    final audioController = context.read<AudioController>();

    final levelStatistics = context.read<LevelStatistics>();
    levelStatistics.setLevelReached(widget.level.levelId);

    final treasureCounter = context.read<TreasureCounter>();
    treasureCounter.incrementCoinCount(widget.level.coinCountOnWin);

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

import 'dart:async';

import 'package:block_crusher/src/game_internals/games/collector_game/collector_game.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/collector_game_level_state.dart';
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/level.dart';
import 'package:block_crusher/src/google_play/games_services/games_services.dart';
import 'package:block_crusher/src/google_play/remote_config/remote_config.dart';
import 'package:block_crusher/src/screens/play_session/scenarios/game_play_statistics.dart';
import 'package:block_crusher/src/screens/play_session/styles/item_background_color_extension.dart';
import 'package:block_crusher/src/screens/play_session/styles/play_screen_overlay.dart';
import 'package:block_crusher/src/screens/play_session/widgets/bottom_layer/city_level_bottom.dart';
import 'package:block_crusher/src/screens/play_session/widgets/bottom_layer/default_bottom.dart';
import 'package:block_crusher/src/screens/play_session/widgets/top_layer/city_level_top.dart';
import 'package:block_crusher/src/screens/play_session/widgets/top_layer/default_top.dart';
import 'package:block_crusher/src/screens/play_session/widgets/top_layer/purple_level_top.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/storage/game_achievements/game_achievements.dart';
import 'package:block_crusher/src/storage/level_statistics/level_statistics.dart';
import 'package:block_crusher/src/storage/treasure_counts/treasure_counter.dart';
import 'package:block_crusher/src/utils/in_game_characters.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../game_internals/level_logic/level_states/collector_game/world_type.dart';
import '../../settings/audio/sounds.dart';
import '../../storage/player_inventory/player_inventory.dart';
import '../../style/confetti.dart';

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
  bool displayWelcomeOverlay = true;

  late BlockCrusherGame blockCrusherGame;
  late DateTime startOfPlay;
  late Color itemBackgroundColor;
  late Color itemTextColor;

  @override
  Widget build(BuildContext context) {
    final remoteConfig = context.read<RemoteConfigProvider>();

    final String imagePath =
        'assets/images/${imageSource[widget.level.worldType.index][widget.level.characterId]['source']}';

    final String title = 'Level ${widget.level.levelId}';

    final bool isPurpleWorld = widget.level.worldType == WorldType.purpleWorld;
    final bool isCityLand = widget.level.worldType == WorldType.cityLand;
    final bool isDefaultWorld = !isPurpleWorld && !isCityLand;

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
              maxLives: widget.level.worldType.defaultLives(remoteConfig),
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

                /// GAME WIDGET
                Consumer<CollectorGameLevelState>(
                    builder: (context, levelState, child) {
                  return GameWidget(
                      game: blockCrusherGame.setGame(context, levelState));
                }),

                /// CITY LAND WIDGETS
                isCityLand
                    ? Column(
                        children: [
                          CityTopWidget(
                            title: title,
                            imagePath: imagePath,
                          ),
                          const Spacer(),
                          const CityLevelBottomWidget(),
                        ],
                      )
                    : const SizedBox.shrink(),

                /// IS PURPLE WORLD
                isPurpleWorld
                    ? Column(
                        children: [
                          PurpleTopWidget(
                            title: title,
                            imagePath: imagePath,
                          ),
                          const Spacer(),
                          DefaultBottomWidget(
                            startOfPlay: startOfPlay,
                            itemTextColor: itemTextColor,
                            itemBackgroundColor: itemBackgroundColor,
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),

                //// DEFAULT WIDGETS
                isDefaultWorld
                    ? Column(
                        children: [
                          DefaultTopWidget(
                            title: title,
                            imagePath: imagePath,
                          ),
                          const Spacer(),
                          DefaultBottomWidget(
                            startOfPlay: startOfPlay,
                            itemTextColor: itemTextColor,
                            itemBackgroundColor: itemBackgroundColor,
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),

                // Game Won widget
                SizedBox.expand(
                  child: Visibility(
                    visible: duringCelebration,
                    child: IgnorePointer(
                      child: Confetti(
                        isStopped: !duringCelebration,
                      ),
                    ),
                  ),
                ),

                // Game Lost widget
                SizedBox.expand(
                  child: Visibility(
                    visible: duringLost,
                    child: const PlaySessionDeathOverlay(),
                  ),
                ),

                SizedBox.expand( child: Visibility(
                  visible: displayWelcomeOverlay,
                  child: PlaySessionStartOverlay(title: title, path: imagePath)
                ),),
              ],
            ),
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
    final remoteConfig = context.read<RemoteConfigProvider>();

    blockCrusherGame = BlockCrusherGame(widget.level.worldType,
        gameAchievements: achievements,
        audioController: audio,
        remoteConfig: remoteConfig);

    initAnimation();

    startOfPlay = DateTime.now();
    itemBackgroundColor = widget.level.worldType.getItemBackgroundColor();
    itemTextColor = widget.level.worldType.getItemTextColor();


  }

  Future<void> initAnimation() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {displayWelcomeOverlay = false;});
    startOfPlay = DateTime.now();
  }

  Future<void> playerDie() async {
    final audioController = context.read<AudioController>();
    final treasureCounter = context.read<TreasureCounter>();
    final levelStatistics = context.read<LevelStatistics>();

    final bool alreadyFinishedLevel = levelStatistics.highestLevelReached >= widget.level.levelId;
    final int coinIncrease =  blockCrusherGame.coinCountFromState();

    final GamePlayStatistics gamePlayStatistics = GamePlayStatistics(
        duration: DateTime.now().difference(startOfPlay),
        level: widget.level.levelId,
        coinCount: coinIncrease, alreadyFinishedLevel: alreadyFinishedLevel
        , winningCharacter: widget.level.winningCharacterReference);


    treasureCounter.incrementCoinCount(gamePlayStatistics.coinCount);
    levelStatistics.increaseTotalPlayTime(gamePlayStatistics.duration.inSeconds);

    await Future<void>.delayed(preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      duringLost = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 200));

    audioController.playSfx(SfxType.lost);

    await Future<void>.delayed(celebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).go('/play/lost', extra: {'score' : gamePlayStatistics});
  }

  Future<void> playerWon() async {
    final audioController = context.read<AudioController>();
    final levelStatistics = context.read<LevelStatistics>();
    final playerInventory = context.read<PlayerInventory>();

    final int coinIncrease =  blockCrusherGame.coinCountFromState();
    final int coinIncreaseFromLevel = widget.level.coinCountOnWin;

    final bool alreadyFinishedLevel = levelStatistics.highestLevelReached >= widget.level.levelId;

    final GamePlayStatistics gamePlayStatistics = GamePlayStatistics(
        duration: DateTime.now().difference(startOfPlay),
        level: widget.level.levelId,
        coinCount: alreadyFinishedLevel ? coinIncrease :coinIncreaseFromLevel + coinIncrease,
        alreadyFinishedLevel: alreadyFinishedLevel
        , winningCharacter: widget.level.winningCharacterReference
    );

    levelStatistics.setLevelReached(gamePlayStatistics.level);
    levelStatistics.increaseTotalPlayTime(gamePlayStatistics.duration.inSeconds);

    playerInventory.addNewAvailableCharacter(gamePlayStatistics.winningCharacter);

    final treasureCounter = context.read<TreasureCounter>();
    treasureCounter.incrementCoinCount(gamePlayStatistics.coinCount);

    await Future<void>.delayed(preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      duringCelebration = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 200));
    audioController.playSfx(SfxType.congrats);

    await Future<void>.delayed(celebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).go('/play/won', extra: {'score' : gamePlayStatistics});
  }

  submitToLeaderBoards() async {

    final gamesServicesController = context.read<GamesServicesController?>();

    if (gamesServicesController != null) {
      // Award achievement.
      if (widget.level.awardsAchievement) {
        await gamesServicesController.awardAchievement(
          android: widget.level.achievementIdAndroid!,
          iOS: widget.level.achievementIdIOS!,
        );
      }

      // Send score to leaderboard.
      await gamesServicesController.submitLeaderboardScore();
    }
  }
}

import 'dart:async';

import 'package:block_crusher/src/game/collector_game.dart';
import 'package:block_crusher/src/game/collector_game_level_state.dart';
import 'package:block_crusher/src/database/model/level.dart';
import 'package:block_crusher/src/screens/play_session/purple_world_top_widget.dart';
import 'package:block_crusher/src/services/games_services.dart';
import 'package:block_crusher/src/services/remote_config.dart';
import 'package:block_crusher/src/screens/play_session/game_play_statistics.dart';
import 'package:block_crusher/src/screens/play_session/item_background_color_extension.dart';
import 'package:block_crusher/src/screens/play_session/play_screen_overlay.dart';
import 'package:block_crusher/src/screens/play_session/city_level_bottom.dart';
import 'package:block_crusher/src/screens/play_session/default_bottom.dart';
import 'package:block_crusher/src/services/audio_controller.dart';
import 'package:block_crusher/src/storage/game_achievements.dart';
import 'package:block_crusher/src/storage/level_statistics.dart';
import 'package:block_crusher/src/storage/settings.dart';
import 'package:block_crusher/src/storage/treasure_counter.dart';
import 'package:block_crusher/src/database/in_game_characters.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../database/player_inventory_database.dart';
import '../../game/world_type.dart';
import '../../services/ads_controller.dart';
import '../../services/sounds.dart';
import '../../storage/player_inventory.dart';
import '../../utils/confetti.dart';
import 'city_world_top_widget.dart';
import 'default_top_widget.dart';

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
    final settings = context.read<SettingsController>();

    final String imagePath = 'assets/images/${charactersForInventory[widget.level.winningCharacterReference]['source']}';

    final String title = 'Level ${widget.level.levelId}';

    final bool isPurpleWorld = widget.level.worldType == WorldType.purpleWorld;
    final bool isCityLand = widget.level.worldType == WorldType.cityLand;
    final bool isDefaultWorld = !isPurpleWorld && !isCityLand;

    var adsController = AdsController(MobileAds.instance);
    adsController.preloadBannerAd(AdType.winAd);
    adsController.loadFullscreenAd();

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
              goal: widget.level.gameGoal ?? widget.level.characterId,
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
                            onExit: onExit,
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
                            onExit: onExit,
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
                            onExit: onExit,
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

                Align(alignment: Alignment.bottomLeft, child: Visibility(visible:settings.cheatsOn,
                child: ElevatedButton(child: Text('cheat'), onPressed: () {playerWon();},),
                ),),

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
        remoteConfig: remoteConfig, trippieCharacterType: widget.level.trippieCharacterType,mathCharacterType: widget.level.mathCharacterType);

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

  onExit() async {

    final audioController = context.read<AudioController>();
    final treasureCounter = context.read<TreasureCounter>();
    final levelStatistics = context.read<LevelStatistics>();

    levelStatistics.increaseLoseRate();

    final bool alreadyFinishedLevel = levelStatistics.highestLevelReached >= widget.level.levelId;
    final int coinIncrease =  blockCrusherGame.coinCountFromState();

    final GamePlayStatistics gamePlayStatistics = GamePlayStatistics(
        duration: DateTime.now().difference(startOfPlay),
        level: widget.level.levelId,
        coinCount: coinIncrease, alreadyFinishedLevel: alreadyFinishedLevel
        , winningCharacter: widget.level.winningCharacterReference);

    audioController.playSfx(SfxType.buttonTap);

    treasureCounter.incrementCoinCount(gamePlayStatistics.coinCount);

    levelStatistics.increaseTotalPlayTime(gamePlayStatistics.duration.inSeconds);



    GoRouter.of(context).go('/play');


  }

  Future<void> playerDie() async {
    final audioController = context.read<AudioController>();
    final treasureCounter = context.read<TreasureCounter>();
    final levelStatistics = context.read<LevelStatistics>();


    levelStatistics.increaseDeathRate();


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


    levelStatistics.increaseWinRate();


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

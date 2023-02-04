import 'package:block_crusher/src/google_play/games_services/games_services.dart';
import 'package:block_crusher/src/screens/play_session/play_session_screen.dart';
import 'package:block_crusher/src/screens/play_session/scenarios/game_play_statistics.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/settings/audio/sounds.dart';
import 'package:block_crusher/src/storage/level_statistics/level_statistics.dart';
import 'package:block_crusher/src/storage/treasure_counts/treasure_counter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';



extension PlayerWonScenario on PlaySessionScreenState{
  Future<void> playerWon() async {
    final int coinIncrease =  blockCrusherGame.coinCountFromState();
    final int coinIncreaseFromLevel = widget.level.coinCountOnWin;

    final GamePlayStatistics gamePlayStatistics = GamePlayStatistics(
      duration: DateTime.now().difference(startOfPlay),
      level: widget.level.levelId,
      coinCount: coinIncreaseFromLevel + coinIncrease
    );

    final audioController = context.read<AudioController>();
    final levelStatistics = context.read<LevelStatistics>();
    levelStatistics.setLevelReached(gamePlayStatistics.level);
    levelStatistics.increaseTotalPlayTime(gamePlayStatistics.duration.inSeconds);

    final treasureCounter = context.read<TreasureCounter>();
    treasureCounter.incrementCoinCount(gamePlayStatistics.coinCount);

    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      duringCelebration = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 200));
    audioController.playSfx(SfxType.congrats);

    /// Give the player some time to see the celebration animation.
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
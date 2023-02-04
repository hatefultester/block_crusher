import 'package:block_crusher/src/screens/play_session/play_session_screen.dart';
import 'package:block_crusher/src/screens/play_session/scenarios/game_play_statistics.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/settings/audio/sounds.dart';
import 'package:block_crusher/src/storage/level_statistics/level_statistics.dart';
import 'package:block_crusher/src/storage/treasure_counts/treasure_counter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

extension PlayerDieScenarion on PlaySessionScreenState {
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
    , winningCharacter: widget.level.winningCharacter);




    treasureCounter.incrementCoinCount(gamePlayStatistics.coinCount);
    levelStatistics.increaseTotalPlayTime(gamePlayStatistics.duration.inSeconds);



    // Let the player see the game just after winning for a bit.
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
}
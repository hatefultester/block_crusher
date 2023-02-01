
import 'package:block_crusher/src/game_internals/level_logic/levels.dart';
import 'package:block_crusher/src/screens/levels/level_selection_data.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/settings/audio/sounds.dart';
import 'package:block_crusher/src/storage/level_statistics/level_statistics.dart';
import 'package:block_crusher/src/utils/characters.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LevelBoxWidget extends StatelessWidget {
  final int id;


  const LevelBoxWidget({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();
    final levelStatistics = context.watch<LevelStatistics>();

    var highestScore = levelStatistics.highestLevelReached;

    final level = gameLevels[id];
    bool enabled = highestScore >= level.levelId - 1;
    if (highestScore == 23) {
      enabled = true;
    }

    final bool won = highestScore > level.levelId - 1;


    final Widget child = Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: won
            ? LinearGradient(
          begin:
          id.isEven ? Alignment.topRight : Alignment.topLeft,
          end: id.isEven
              ? Alignment.bottomLeft
              : Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.yellow.shade200,
            Colors.white,
          ],
        )
            : null,
        border: Border.all(
          color: won ? Colors.yellow.shade600 : Colors.black,
          width: won ? 3 : 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      width: enabled && !won ? levelBoxSize : levelBoxSize - 20,
      height: enabled && !won ? levelBoxSize : levelBoxSize - 20,
      child: Image.asset(
          'assets/images/${imageSource[level.levelDifficulty.index][level.characterId]['source']}'),
    );

    if (enabled) {
      return Material(
        color: const Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            audioController.playSfx(SfxType.buttonTap);

            GoRouter.of(context).go('/play/session/${level.levelId}/0');
          },
          child: IgnorePointer(
            child: child,
          ),),
      );
    } else {
      return ColorFiltered(
        colorFilter: greyscaleMatrix,
        child: Material(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20),
            child: child),
      );
    }
  }
}

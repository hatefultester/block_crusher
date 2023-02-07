import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/levels.dart';
import 'package:block_crusher/src/settings/audio/audio_controller.dart';
import 'package:block_crusher/src/settings/audio/sounds.dart';
import 'package:block_crusher/src/storage/level_statistics/level_statistics.dart';
import 'package:block_crusher/src/utils/in_game_characters.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

const double levelBoxSize = 85;

const double pageHorizontalPadding = 12;

const ColorFilter greyscaleMatrix = ColorFilter.matrix(<double>[
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
]);

class LevelBoxWidget extends StatelessWidget {
  final int id;

  const LevelBoxWidget({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();
    final levelStatistics = context.watch<LevelStatistics>();
    final highestScore = levelStatistics.highestLevelReached;
    final level = gameLevels[id];
    final String path =
        'assets/images/${imageSource[level.worldType.index][level.characterId]['source']}';

    final bool won = highestScore > level.levelId - 1;
    bool enabled = highestScore >= level.levelId - 1;

    onTap() => {
          audioController.playSfx(SfxType.buttonTap),
          GoRouter.of(context).go('/play/session/${level.levelId}/0'),
        };

    if (won) {
      return _FinishedLevelBox(path: path, onTap: onTap, id: id);
    }

    if (enabled) {
      return _OpenLevelBox(path: path, onTap: onTap, id: id);
    }


    return _CloseLevelBox(path: path, id: id);
  }
}

class _BoxContent extends StatelessWidget {
  final String path;
  final String id;

  const _BoxContent({Key? key, required this.path, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
            alignment: Alignment.topCenter,
            child: Transform.translate(
                offset: const Offset(0, -30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      width: 0.1,
                      color: Colors.black,
                    )
                  ),
                  width: 30,
                  height: 30,
                  child: Center(child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(id, style: const TextStyle(fontSize: 20,),),),),),),),
        Center(child: Image.asset(path)),
      ],
    );
  }
}


class _CloseLevelBox extends StatelessWidget {
  final String path;
  final int id;

  const _CloseLevelBox({Key? key, required this.path, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: greyscaleMatrix,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        width: levelBoxSize,
        height: levelBoxSize,
        child: _BoxContent(path: path, id: id.toString()),
      ),
    );
  }
}

class _OpenLevelBox extends StatelessWidget {
  final String path;
  final GestureTapCallback onTap;
  final int id;

  const _OpenLevelBox({Key? key, required this.path, required this.onTap, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.4),
                spreadRadius: 4,
                blurRadius: 8,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          width: levelBoxSize,
          height: levelBoxSize,
          child: _BoxContent(path: path, id: id.toString()),
        ),
      ),
    );
  }
}

class _FinishedLevelBox extends StatelessWidget {
  final String path;
  final GestureTapCallback onTap;
  final int id;

  const _FinishedLevelBox(
      {Key? key, required this.path, required this.onTap, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.yellow.shade300.withOpacity(0.4),
                spreadRadius: 4,
                blurRadius: 8,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: id.isEven ? Alignment.topRight : Alignment.topLeft,
              end: id.isEven ? Alignment.bottomLeft : Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.8),
                Colors.yellow.shade100.withOpacity(0.8),
                Colors.white.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          width: levelBoxSize,
          height: levelBoxSize,
          child: _BoxContent(path: path, id: id.toString()),
        ),
      ),
    );
  }
}

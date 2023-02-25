import 'package:block_crusher/src/database/levels.dart';
import 'package:block_crusher/src/services/audio_controller.dart';
import 'package:block_crusher/src/services/sounds.dart';
import 'package:block_crusher/src/storage/level_statistics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../database/player_inventory_database.dart';

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

enum LevelBoxStyle {
  rounded,
  squared,
  ;

  double borderRadius() {
    switch (this) {
      case LevelBoxStyle.rounded:
        return 10;
      case LevelBoxStyle.squared:
        return 0;
    }
  }

  double borderRadiusForDescriptor() {
    switch (this) {

      case LevelBoxStyle.rounded:
        return 50;
      case LevelBoxStyle.squared:
        return 10;
  }
}
}

class LevelBoxWidget extends StatelessWidget {
  final int id;

  final double customSize;

  final String? sideImagePath;

  final LevelBoxStyle style;

  const LevelBoxWidget({
    Key? key,
    required this.id,
    this.customSize = levelBoxSize,
    this.sideImagePath,
    this.style = LevelBoxStyle.rounded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();
    final levelStatistics = context.watch<LevelStatistics>();
    final highestScore = levelStatistics.highestLevelReached;
    final level = gameLevels[id];
    final String path =
        'assets/images/${charactersForInventory[level.winningCharacterReference]['source']}';

    final bool won = highestScore > level.levelId - 1;

    bool enabled = highestScore >= level.levelId - 1;

    onTap() => {
          audioController.playSfx(SfxType.buttonTap),
          GoRouter.of(context).go('/play/session/${level.levelId}/0'),
        };

    if (won) {
      return _FinishedLevelBox(
        style: style,
        path: path,
        onTap: onTap,
        id: id,
        size: customSize,
        sideImagePath: sideImagePath,
      );
    }

    if (enabled) {
      return _OpenLevelBox(
        style: style,
        path: path,
        onTap: onTap,
        id: id,
        size: customSize,
        sideImagePath: sideImagePath,
      );
    }

    return _CloseLevelBox(
      style: style,
      path: path,
      id: id,
      size: customSize,
      sideImagePath: sideImagePath,
    );
  }
}

class _BoxDescriptor extends StatelessWidget {
  final int id;
  final LevelBoxStyle style;

  const _BoxDescriptor({Key? key, required this.id, required this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Transform.translate(
        offset: const Offset(0, -30),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(style.borderRadiusForDescriptor()),
              border: Border.all(
                width: 0.1,
                color: Colors.black,
              )),
          width: 30,
          height: 30,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                (id + 1).toString(),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _BoxContent extends StatelessWidget {
  final String path;
  final int id;

  final String? sideImagePath;

  final double size;

  final LevelBoxStyle style;

  const _BoxContent(
      {Key? key,
      required this.path,
      required this.id,
      this.sideImagePath,
      required this.size, required this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
            visible: style == LevelBoxStyle.rounded,
            child: _BoxDescriptor(id: id, style: style,)),
        Center(child: Image.asset(path)),

        sideImagePath == null
            ? const SizedBox.shrink()
            : Align(
                alignment: Alignment.bottomRight,
                child: Transform.rotate(
                    angle: id.isEven ? 0.1 : -0.1,
                    child: Transform.translate(
                        offset: Offset(size / 3, size / 3),
                        child: SizedBox(
                          height: size / 2,
                          width: size / 2,
                          child: Image.asset(sideImagePath!),
                        ))),
              )
      ],
    );
  }
}

class _CloseLevelBox extends StatelessWidget {
  final LevelBoxStyle style;
  final String path;
  final int id;
  final double size;
  final String? sideImagePath;

  const _CloseLevelBox(
      {Key? key,
      required this.path,
      required this.id,
      required this.size,
      this.sideImagePath,
      required this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: greyscaleMatrix,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.8),
          borderRadius: BorderRadius.circular(style.borderRadius()),
        ),
        width: size,
        height: size,
        child: _BoxContent(
          style: style,
            path: path,
            id: id,
            sideImagePath: 'assets/images/lock/lock_locked.png',
            size: size),
      ),
    );
  }
}

class _OpenLevelBox extends StatelessWidget {
  final LevelBoxStyle style;
  final String path;
  final GestureTapCallback onTap;
  final int id;
  final double size;
  final String? sideImagePath;

  const _OpenLevelBox(
      {Key? key,
      required this.path,
      required this.onTap,
      required this.id,
      required this.size,
      this.sideImagePath,
      required this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(style.borderRadius()),
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
            borderRadius: BorderRadius.circular(style.borderRadius()),
          ),
          width: size,
          height: size,
          child: _BoxContent(
              style: style,
              path: path,
              id: id,
              sideImagePath: 'assets/images/lock/lock_unlocked.png',
              size: size),
        ),
      ),
    );
  }
}

class _FinishedLevelBox extends StatelessWidget {
  final LevelBoxStyle style;
  final String path;
  final GestureTapCallback onTap;
  final int id;
  final double size;
  final String? sideImagePath;

  const _FinishedLevelBox(
      {Key? key,
      required this.path,
      required this.onTap,
      required this.id,
      required this.size,
      this.sideImagePath,
      required this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(style.borderRadius()),
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
            borderRadius: BorderRadius.circular(style.borderRadius()),
          ),
          width: size,
          height: size,
          child:
              _BoxContent(
                  style: style,path: path, id: id, sideImagePath: null, size: size),
        ),
      ),
    );
  }
}

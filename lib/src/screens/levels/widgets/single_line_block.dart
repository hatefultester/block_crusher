import 'dart:math';

import 'package:block_crusher/src/game_internals/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/player_progress/player_progress.dart';
import 'package:block_crusher/src/screens/levels/level_selection_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Color _lineBorderColor = Colors.black;

const double _finishedLineThickness = 8;
const double _openLineThickness = 8;
const double _closedLineThickness = 8;

const double _borderThickness = 0.5;
const double _radius = 12;

class SingleLineBlock extends StatelessWidget {
  final Direction direction;
  final int id;
  final int offset;
  final double rotationFactor;

  final bool hasRandomColor;


  const SingleLineBlock({Key? key, this.hasRandomColor = true,required this.direction, required this.id, this.offset = 0, this.rotationFactor = 0.0}) : super(key: key);

  _finishedLineColor() {
    List<Color> finishedLineColors = [Colors.yellow.shade600,Colors.yellow.shade400, Colors.yellow.shade500, Colors.yellow.shade300,Colors.yellow.shade800, Colors.yellow.shade700];
    if (!hasRandomColor) {
      return finishedLineColors[0];
    } else {
     return finishedLineColors[Random().nextInt(finishedLineColors.length)];
    }
  }

  _openLineColor() {
    List<Color> openLineColors = [ Colors.white,  Colors.white38,  Colors.white60,  Colors.white70];
    if (!hasRandomColor) {
      return openLineColors[0];
    } else {
      return openLineColors[Random().nextInt(openLineColors.length)];
    }
  }

  _closedLineColor() {
    List<Color> closedLineColors = [ Colors.grey,   Colors.grey.shade400,  Colors.grey.shade300,  Colors.grey.shade500,  Colors.grey.shade700];
    if (!hasRandomColor) {
      return closedLineColors[0];
    } else {
      return closedLineColors[Random().nextInt(closedLineColors.length)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerProgress = context.watch<PlayerProgress>();

      final lineColor = playerProgress.highestLevelReached > id
          ? _finishedLineColor()
          : playerProgress.highestLevelReached == id
          ? _openLineColor()
          : _closedLineColor();

      final borderColor = _lineBorderColor;

      final double lineThickness = playerProgress.highestLevelReached > id
          ? _finishedLineThickness
          : playerProgress.highestLevelReached == id
          ? _openLineThickness
          : _closedLineThickness;

      final BoxDecoration borderDecoration = BoxDecoration(
          color: lineColor, border: Border.all(color: borderColor, width: _borderThickness,), borderRadius: BorderRadius.circular(_radius));

      if (direction == Direction.down) {
        return Transform.rotate(
          angle: rotationFactor,
          child: Column(
            children: [
              const Spacer(),
              Container(
                decoration: borderDecoration,
                height: lineThickness,
                width: lineThickness,
              ),
              SizedBox(
                height: levelBoxSize / 2 + offset + Random().nextInt(6) - 3,
              )
            ],
          ),
        );
      }

      if (direction == Direction.up) {
        return Transform.rotate(
          angle: rotationFactor,
          child: Column(
            children: [
              SizedBox(
                height: levelBoxSize / 2 + offset + Random().nextInt(6) - 3,
              ),
              Container(
                decoration: borderDecoration,
                height: lineThickness,
                width: lineThickness,
              ),
              const Spacer(),
            ],
          ),
        );
      }

      if (direction == Direction.right) {
        return  Row(
          children: [
            const Spacer(),
            Transform.rotate(
              angle: rotationFactor,
              child: Container(
                decoration: borderDecoration,
                height: lineThickness,
                width: lineThickness,
              ),
            ),
            SizedBox(width: (levelBoxSize / 2 + pageHorizontalPadding) + offset + Random().nextInt(6) - 3)
          ],
        );
      }

      if (direction == Direction.left) {
        return  Row(
          children: [
            SizedBox(width: (levelBoxSize / 2 + pageHorizontalPadding) + offset + Random().nextInt(6) - 3),
            Transform.rotate(
              angle: rotationFactor,
              child: Container(
                decoration: borderDecoration,
                height: lineThickness,
                width: lineThickness,
              ),
            ),
            const Spacer(),
          ],
        );
      }

      return const SizedBox.shrink();
    }
}



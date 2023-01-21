import 'package:block_crusher/src/game_internals/collector_game/components/sprite_block_component.dart';
import 'package:block_crusher/src/player_progress/player_progress.dart';
import 'package:block_crusher/src/screens/levels/level_selection_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Color _finishedLineColor = Colors.yellow.shade600;
Color _openLineColor = Colors.white;
Color _closedLineColor = Colors.grey;
Color _lineBorderColor = Colors.black;

const double _finishedLineThickness = 8;
const double _openLineThickness = 8;
const double _closedLineThickness = 8;

const double _borderThickness = 0.5;

class SingleLineBlock extends StatelessWidget {
  final Direction direction;
  final int id;
  final int offset;
  final double rotationFactor;


  const SingleLineBlock({Key? key, required this.direction, required this.id, this.offset = 0, this.rotationFactor = 0.0}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final playerProgress = context.watch<PlayerProgress>();

      final lineColor = playerProgress.highestLevelReached > id
          ? _finishedLineColor
          : playerProgress.highestLevelReached == id
          ? _openLineColor
          : _closedLineColor;

      final borderColor = _lineBorderColor;

      final double lineThickness = playerProgress.highestLevelReached > id
          ? _finishedLineThickness
          : playerProgress.highestLevelReached == id
          ? _openLineThickness
          : _closedLineThickness;

      final BoxDecoration borderDecoration = BoxDecoration(
          color: lineColor, border: Border.all(color: borderColor, width: _borderThickness));

      if (direction == Direction.down) {
        return Transform.rotate(
          angle: rotationFactor,
          child: Column(
            children: [
              const Spacer(),
              Container(
                decoration: borderDecoration,
                height: lineThickness,
                width: 4,
              ),
              SizedBox(
                height: levelBoxSize / 2 + offset,
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
                height: levelBoxSize / 2 + offset,
              ),
              Container(
                decoration: borderDecoration,
                height: lineThickness,
                width: 4,
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
                height: 5,
                width: lineThickness,
              ),
            ),
            SizedBox(width: (levelBoxSize / 2 + pageHorizontalPadding) + offset)
          ],
        );
      }

      if (direction == Direction.left) {
        return  Row(
          children: [
            SizedBox(width: (levelBoxSize / 2 + pageHorizontalPadding) + offset),
            Transform.rotate(
              angle: rotationFactor,
              child: Container(
                decoration: borderDecoration,
                height: 5,
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



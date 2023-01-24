
import 'package:block_crusher/src/game_internals/games/collector_game/util/collector_game_helper.dart';
import 'package:block_crusher/src/screens/levels/widgets/single_line_block.dart';
import 'package:flutter/material.dart';

class LineBuilder extends StatelessWidget {
  final Direction direction;
  final int id;
  final int offset;
  final double rotationFactor;

  final double width;
  final double height;

  final int count;

  final bool expandable;

  const LineBuilder(
      {Key? key,
      required this.direction,
      required this.id,
      this.offset = 0,
      this.rotationFactor = 0,
      this.width = double.infinity,
      this.height = double.infinity,
      required this.count,
      this.expandable = true,})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox.shrink();

    if (direction == Direction.up || direction == Direction.down) {
      child =  SizedBox(
            width: width,
            height: height,
            child: Row(
              children: [
                for (int i = 0; i < count; i++)
                  i.isEven
                      ? const Spacer()
                      : SingleLineBlock(
                          direction: direction,
                          id: id,
                          offset: offset,
                          rotationFactor: rotationFactor,
                        ),
              ],
            ),);
    }

    if (direction == Direction.left || direction == Direction.right) {
      child = SizedBox(
            width: width,
            height: height,
            child: Column(
              children: [
                for (int i = 0; i < count; i++)
                  i.isEven
                      ? const Spacer()
                      : SingleLineBlock(
                          direction: direction,
                          id: id,
                          offset: offset,
                          rotationFactor: rotationFactor,
                        ),
              ],
            ),);
    }

    if(expandable) {
      return Expanded(child: child);
    } else {
      return child;
    }
  }
}

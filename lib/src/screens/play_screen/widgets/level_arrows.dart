import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../play_screen_provider.dart';

class LevelArrows extends StatefulWidget {
  const LevelArrows({Key? key}) : super(key: key);

  @override
  State<LevelArrows> createState() => _LevelArrowsState();
}

class _LevelArrowsState extends State<LevelArrows> {
  int page = 2;


  @override
  Widget build(BuildContext context) {
    final playScreenProvider = context.watch<PlayScreenProvider>();

    return Align(alignment: Alignment.bottomCenter,
    child: Container(padding: const EdgeInsets.only(left: 10, right: 10), height: 100, width: double.infinity, child:
    Row(children: [
      _ArrowButton(action: () => {playScreenProvider.previousPage()}, direction: ArrowDirection.left),
      const Spacer(),
      _ArrowButton(action: () => {playScreenProvider.nextPage()}, direction: ArrowDirection.right),
      ],),),
    );
  }
}

enum ArrowDirection {
  left, right
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({Key? key, required this.direction, required this.action}) : super(key: key);

  final ArrowDirection direction;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return Container(
        width :50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: Colors.black,
        ),
        child: Center(child: IconButton(icon: Icon(direction == ArrowDirection.right ? Icons.arrow_right :Icons.arrow_left , color: Colors.white, size: 25), onPressed: action,)));
  }
}

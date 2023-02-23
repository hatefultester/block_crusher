
import 'package:block_crusher/src/game/collector_game_level_state.dart';
import 'package:block_crusher/src/screens/play_session/image_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterGoalWidget extends StatefulWidget {
  final Color backgroundColor;
  final Color textColor;


  const CounterGoalWidget({Key? key, required this.backgroundColor, required this.textColor}) : super(key: key);

  @override
  State<CounterGoalWidget> createState() => _CounterGoalWidgetState();
}

class _CounterGoalWidgetState extends State<CounterGoalWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CollectorGameLevelState>(
        builder: (context, levelState, child) {
          return
            Container(width: 100, height: 50, decoration: BoxDecoration(color: widget.backgroundColor, borderRadius: BorderRadius.circular(20),), padding: const EdgeInsets.all(6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(levelState.currentGoal.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: widget.textColor),),
                  ],
                ));}
    );
  }
}

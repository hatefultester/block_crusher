
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/collector_game_level_state.dart';
import 'package:block_crusher/src/screens/play_session/widgets/parts/image_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeartWidget extends StatefulWidget {
  final Color backgroundColor;
  final Color textColor;


  const HeartWidget({Key? key, required this.backgroundColor, required this.textColor}) : super(key: key);

  @override
  State<HeartWidget> createState() => _HeartWidgetState();
}

class _HeartWidgetState extends State<HeartWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CollectorGameLevelState>(
        builder: (context, levelState, child) {

          return
            Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                width: 75, height: 50, decoration: BoxDecoration(color: widget.backgroundColor, borderRadius: BorderRadius.circular(20),),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(levelState.lives.toString(), style: const TextStyle(fontSize: 25),),
                    const ImageWidget(path: 'assets/images/heart/live_heart.png', width: 40, height: 50, symmetric: false,),
                  ],
                ));}
    );
  }

  String _path(i, y) {
    if (i < y) {
      return 'assets/images/heart/live_heart.png';
    } else{
      return 'assets/images/heart/dead_heart.png';
    }
  }
}

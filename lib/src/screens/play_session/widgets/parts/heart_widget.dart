
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
          if (kDebugMode) {
            print('REBUILDING CONSUMER ON COIN COUNT BOTTOM WIDGET');
          }

          return
            Container(width: 150, height: 50, decoration: BoxDecoration(color: widget.backgroundColor, borderRadius: BorderRadius.circular(20),), padding: const EdgeInsets.all(6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for(int i = 0; i < levelState.maxLives ; i++) ImageWidget(path: _path(i, levelState.lives), size: 45,),
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

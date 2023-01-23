import 'package:block_crusher/src/level_selection/level_states/collector_game/collector_game_level_state.dart';
import 'package:block_crusher/src/screens/play_session/widgets/parts/coin_wallet.dart';
import 'package:block_crusher/src/screens/play_session/widgets/parts/heart_widget.dart';
import 'package:block_crusher/src/screens/play_session/widgets/parts/timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DefaultBottomWidget extends StatefulWidget {
  final DateTime startOfPlay;

  final Color itemBackgroundColor;
  final Color itemTextColor;

  const DefaultBottomWidget({Key? key, required this.startOfPlay, required this.itemBackgroundColor, required this.itemTextColor}) : super(key: key);

  @override
  State<DefaultBottomWidget> createState() => _DefaultBottomWidgetState();
}

class _DefaultBottomWidgetState extends State<DefaultBottomWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
       // decoration: const BoxDecoration(color: Colors.black),
        height: 80,
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<CollectorGameLevelState>(
              builder: (context, levelState, child) {
                print('REBUILDING CONSUMER ON DEFAULT BOTTOM WIDGET');
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CoinWalletWidget(backgroundColor: widget.itemBackgroundColor, textColor : widget.itemTextColor),
                  const SizedBox(width:5),
                  HeartWidget(backgroundColor: widget.itemBackgroundColor, textColor : widget.itemTextColor),
                  const SizedBox(width:5),
                  TimerWidget(widget.startOfPlay, backgroundColor: widget.itemBackgroundColor, textColor: widget.itemTextColor,),
                ],
              );}
            ),
          ],
        ),);
  }
}

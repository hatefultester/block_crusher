
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/collector_game_level_state.dart';
import 'package:block_crusher/src/screens/play_session/widgets/parts/image_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoinWalletWidget extends StatefulWidget {
  final Color backgroundColor;
  final Color textColor;


  const CoinWalletWidget({Key? key, required this.backgroundColor, required this.textColor}) : super(key: key);

  @override
  State<CoinWalletWidget> createState() => _CoinWalletWidgetState();
}

class _CoinWalletWidgetState extends State<CoinWalletWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CollectorGameLevelState>(
        builder: (context, levelState, child) {
      if (kDebugMode) {
        print('REBUILDING CONSUMER ON COIN COUNT BOTTOM WIDGET');
      }
      return
      Container(width: 100, height: 50, decoration: BoxDecoration(color: widget.backgroundColor, borderRadius: BorderRadius.circular(20),), padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ImageWidget(path: 'assets/images/coins/1000x677/money.png', size: 50,),
          Text(levelState.coinCount.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: widget.textColor),),
        ],
      ));}
    );
  }
}

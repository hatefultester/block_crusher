
import 'package:animated_text_kit/animated_text_kit.dart';
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


      return
      Container(
          margin: const EdgeInsets.only(left: 5, right: 5),
          width: 100, height: 50, decoration: BoxDecoration(color: widget.backgroundColor, borderRadius: BorderRadius.circular(20),), padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          const Spacer(),

          Text(levelState.coinCount.toString(), style: TextStyle(color: widget.textColor, fontSize: 25),),

          const ImageWidget(path: 'assets/images/coins/1000x677/money.png', width: 50,),
         ],
      ));}
    );
  }

}


/// TODO

class CustomAnimatedText extends StatefulWidget {
  final String text;

  const CustomAnimatedText({Key? key, required this.text}) : super(key: key);

  @override
  State<CustomAnimatedText> createState() => _CustomAnimatedTextState();
}

class _CustomAnimatedTextState extends State<CustomAnimatedText> {

  bool textAnimation = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      style: textAnimation ?
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white) :
      const TextStyle(fontWeight: FontWeight.w100, fontSize: 20, color: Colors.white),
      duration: const Duration(seconds: 1),
      child:  Text(widget.text),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        textAnimation = false;
      });
      await Future.delayed(const Duration(seconds:3));
      setState(() {
        textAnimation = true;
      });
    });
  }

}

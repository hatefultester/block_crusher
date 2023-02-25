import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class MainHeadingArea extends StatelessWidget {
  const MainHeadingArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.white,
      Colors.red,
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.amber,
      Colors.deepPurple
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 50,
      letterSpacing: 8,
      fontWeight: FontWeight.bold
    );



    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const SizedBox(height: 80,),

          Container(
            padding: const EdgeInsets.all(10),
            width: 350,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(25),
            //   gradient: const LinearGradient(
            //     begin: Alignment.bottomCenter,
            //     end: Alignment.topCenter,
            //     colors: [Colors.black, Colors.transparent],
            //   ),
            // ),
            child:
            AnimatedTextKit(
              animatedTexts: [
              ColorizeAnimatedText('Hoomy Hoo Collector!',
              textStyle: colorizeTextStyle,
              speed: const Duration(milliseconds: 700),
              colors: colorizeColors,
                textAlign: TextAlign.center,
            ),],
            isRepeatingAnimation: true, repeatForever: true,),
            // const Text(
            //
            //   style: TextStyle(
            //     fontSize: 50,
            //     color: Colors.white,
            //     letterSpacing: 6
            //   ),
            //   textWidthBasis: TextWidthBasis.longestLine,
            // ),
          ),



          const Spacer(),

          // Container(
          //   padding: const EdgeInsets.all(10),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(25),
          //     gradient: const LinearGradient(
          //       begin: Alignment.bottomCenter,
          //       end: Alignment.topCenter,
          //       colors: [Colors.black, Colors.transparent],
          //     ),
          //   ),
          //   child:
          //   DefaultTextStyle(
          //     style: const TextStyle(
          //       fontSize: 38,
          //       letterSpacing: 2,
          //       color: Colors.white,
          //       fontFamily: 'Quikhand'
          //     ),
          //     child: AnimatedTextKit(
          //       repeatForever: true,
          //       pause: const Duration(seconds: 1),
          //       animatedTexts: [
          //         TyperAnimatedText('Adventures', speed: const Duration(milliseconds:200)),
          //         TyperAnimatedText('have fun :)', speed: const Duration(milliseconds: 200)),
          //         TyperAnimatedText('get all characters', speed: const Duration(milliseconds: 200)),
          //       ],
          //     ),
          //   ),
          // ),

        ],
      ),
    );
  }
}

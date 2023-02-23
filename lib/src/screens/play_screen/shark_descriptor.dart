import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class SharkDescriptor extends StatelessWidget {


  const SharkDescriptor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 300.0),
        child: SizedBox(
          width: 250,
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              letterSpacing: 2,
              fontFamily: 'Quikhand',
            ),
            child: AnimatedTextKit(
              isRepeatingAnimation: false,
              animatedTexts: [
                TyperAnimatedText('Be aware, sharks want to eat!', speed: const Duration(milliseconds: 50), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

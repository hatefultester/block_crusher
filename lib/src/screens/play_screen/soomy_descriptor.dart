import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class SoomyDescriptor extends StatelessWidget {


  const SoomyDescriptor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 45.0),
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
              TyperAnimatedText('Collect all the soomy characters!', speed: const Duration(milliseconds: 50), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

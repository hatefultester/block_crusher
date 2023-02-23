import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class DefaultDescriptor extends StatelessWidget {
final String message;
final int size;
final int offset;
final Color color;

  const DefaultDescriptor({Key? key, required this.message, this.size = 40, this.offset = 45, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding:  EdgeInsets.only(bottom: offset.toDouble()),
        child: DefaultTextStyle(
          style: TextStyle(
            color: color,
            fontSize: size.toDouble(),
            letterSpacing: 2,
            fontFamily: 'Quikhand',
          ),
          child: AnimatedTextKit(
            isRepeatingAnimation: false,
            animatedTexts: [
              TyperAnimatedText(message, speed: const Duration(milliseconds: 25), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

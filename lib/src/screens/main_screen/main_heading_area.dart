import 'package:flutter/material.dart';

class MainHeadingArea extends StatelessWidget {
  const MainHeadingArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black, Colors.transparent],
              ),
            ),
            child: Text(
              'H o o m y   H o o'.toUpperCase(),
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
              textWidthBasis: TextWidthBasis.longestLine,
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black, Colors.transparent],
              ),
            ),
            child: Text(
              'A d v a n t u r e s'.toUpperCase(),
              style: const TextStyle(
                fontSize: 38,
                color: Colors.white,
              ),
              textWidthBasis: TextWidthBasis.longestLine,
            ),
          ),

        ],
      ),
    );
  }
}

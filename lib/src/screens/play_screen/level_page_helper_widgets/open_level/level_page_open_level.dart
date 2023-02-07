import 'package:flutter/material.dart';

class LevelPageOpenLevel extends StatelessWidget {
  final List<Widget> topSection;
  final List<Widget> middleSection;
  final List<Widget> bottomSection;

  final int topSectionFlex;
  final int middleSectionFlex;
  final int bottomSectionFlex;

  const LevelPageOpenLevel({Key? key,
    required this.bottomSection,
    required this.middleSection,
    required this.topSection,
    required this.middleSectionFlex,
    required this.topSectionFlex,
    required this.bottomSectionFlex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: topSectionFlex,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: topSection,
            ),
          ),
          Expanded(
            flex: middleSectionFlex,
            child: Column(children: middleSection),
          ),
          Expanded(
            flex: bottomSectionFlex,
            child: Column(
              children: bottomSection,
            ),),
        ],
      ),
    );
  }
}

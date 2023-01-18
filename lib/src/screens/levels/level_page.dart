import 'package:flutter/material.dart';

class LevelPage extends StatelessWidget {
  final List<Widget> topSection;
  final List<Widget> middleSection;
  final List<Widget> bottomSection;

  final int topSectionFlex;
  final int middleSectionFlex;
  final int bottomSectionFlex;

  const LevelPage(
      {super.key,
        required this.topSection,
        required this.middleSection,
        required this.bottomSection,
        required this.topSectionFlex,
        required this.middleSectionFlex,
        required this.bottomSectionFlex});

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
              )),
        ],
      ),
    );
  }
}

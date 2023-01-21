import 'package:flutter/material.dart';

class LevelPageViewChild extends StatelessWidget {
  final List<Widget> topSection;
  final List<Widget> middleSection;
  final List<Widget> bottomSection;

  final int topSectionFlex;
  final int middleSectionFlex;
  final int bottomSectionFlex;

  const LevelPageViewChild(
      {super.key,
        this.topSection =  const [SizedBox.shrink()],
        this.middleSection = const [SizedBox.shrink()],
        this.bottomSection =  const [SizedBox.shrink()],
        this.topSectionFlex = 1,
        this.middleSectionFlex = 1,
        this.bottomSectionFlex = 1});

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

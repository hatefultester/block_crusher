import 'package:flutter/material.dart';

class LevelPageOpenLevel extends StatelessWidget {
  final List<Widget> topSection;
  final List<Widget> middleSection;
  final List<Widget> bottomSection;

  final int topSectionFlex;
  final int middleSectionFlex;
  final int bottomSectionFlex;

  final int? topSectionMaxSize;
  final int? middleSectionMaxSize;
  final int? bottomSectionMaxSize;

  const LevelPageOpenLevel({Key? key,
    required this.bottomSection,
    required this.middleSection,
    required this.topSection,
    required this.middleSectionFlex,
    required this.topSectionFlex,
    required this.bottomSectionFlex,
    this.topSectionMaxSize,
    this.middleSectionMaxSize,
    this.bottomSectionMaxSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget topSectionChild = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: topSection,
    );
    final Widget middleSectionChild = Column(children: middleSection);
    final Widget bottomSectionChild = Column(
      children: bottomSection,);

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              topSectionMaxSize == null ? Expanded(
                flex: topSectionFlex,
                child: topSectionChild,
              ) : SizedBox(height: topSectionMaxSize!.toDouble(), width: double.infinity, child: topSectionChild),
              middleSectionMaxSize == null ? Expanded(
                flex: middleSectionFlex,
                child: middleSectionChild,
              ) : SizedBox(height: middleSectionMaxSize!.toDouble(), width: double.infinity, child: middleSectionChild),
              bottomSectionMaxSize == null ? Expanded(
                flex: bottomSectionFlex,
                child: bottomSectionChild) : SizedBox(height: bottomSectionMaxSize!.toDouble(), width: double.infinity, child: bottomSectionChild) ,
            ],
          ),
        ],
      ),
    );
  }
}

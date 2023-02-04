import 'package:block_crusher/src/screens/levels/page_view_child/level_page_view_child.dart';
import 'package:block_crusher/src/screens/levels/page_view_child/level_page_view_child_menu.dart';
import 'package:flutter/material.dart';

extension LevelPageViewChildOpenLevelBuilder on LevelPageViewChildState {

  Widget buildOpenLevel() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: widget.topSectionFlex,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: widget.topSection,
                ),
              ),
              Expanded(
                flex: widget.middleSectionFlex,
                child: Column(children: widget.middleSection),
              ),
              Expanded(
                flex: widget.bottomSectionFlex,
                child: Column(
                  children: widget.bottomSection,
                ),),
            ],
          ),
        ),

    //    TopLayerWidget(pageTitle: widget.pageTitle, worldType: widget.levelDifficulty,),
      ],
    );
  }

}
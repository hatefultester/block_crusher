
import 'dart:convert';

import 'package:block_crusher/src/screens/profile_screen/parts/profile_action_button_section.dart';
import 'package:block_crusher/src/screens/profile_screen/parts/profile_back_button.dart';
import 'package:block_crusher/src/screens/profile_screen/parts/profile_color_slider.dart';
import 'package:block_crusher/src/screens/profile_screen/parts/profile_statistics_section.dart';
import 'package:block_crusher/src/screens/profile_screen/parts/profile_top_part.dart';
import 'package:block_crusher/src/screens/profile_screen/profile_background_color.dart';
import 'package:block_crusher/src/storage/level_statistics/level_statistics.dart';
import 'package:block_crusher/src/storage/player_inventory/player_inventory.dart';
import 'package:block_crusher/src/utils/player_inventory_database.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../style/responsive_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final playerInventory = context.watch<PlayerInventory>();
    final levelStatistics = context.watch<LevelStatistics>();

    final Color backgroundColor = profileBackgroundColors[playerInventory.selectedBackgroundColorIndexForProfile];

    return Scaffold(
      backgroundColor: backgroundColor,

      body: Stack(children: const [
        ProfileTopWidget(title: 'Player statistics', itemBackgroundColor: Colors.white, itemTextColor: Colors.black),
        ProfileContent(),
        ProfileBackButton(),
      //  ProfileColorSlider(),
      ],
      )
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 120,),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ProfileStatisticsSection(backgroundColor: Colors.white,textColor: Colors.black,),
        ),
      ],
    );
  }
}



/*
Column(
        children: [
          Wrap(
            children: [
              for (int i = 0; i < 29; i++)
              ElevatedButton(onPressed: () {playerInventory.changeSelectedBackgroundColorIndexForProfile(i);}, child: Container(
                  decoration: BoxDecoration(borderRadius:
                  BorderRadius.circular(60),
                  border: Border.all(width:0.1, color: Colors.black),
                  color: profileBackgroundColors[i],), width: 50, height: 50,
                  child: Center(child: Text(i.toString()),),),),
            ],
          ),
          Wrap(children: [
            for (int i = 0; i < playerInventory.availableCharacters.length; i++)
              characterWidget(playerInventory.availableCharacters[i])
          ],),

          SizedBox(height: 300,child: Center(child: Text(levelStatistics.totalPlayedTimeInSeconds.toString(), style: const TextStyle(fontSize: 35),),)),
        ],
      ),


        characterWidget(String character) {
    return Column(
      children: [
        Container(width: 50, height: 50, child: Padding(padding: const EdgeInsets.all(5), child: Image.asset('assets/images/${charactersForInventory[
          character]['source']}'),),),
        Text(charactersForInventory[character]['sila'].toString()),
      ],
    );
  }
 */
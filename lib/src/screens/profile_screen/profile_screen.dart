
import 'dart:convert';

import 'package:block_crusher/src/screens/profile_screen/profile_background_color.dart';
import 'package:block_crusher/src/storage/level_statistics/level_statistics.dart';
import 'package:block_crusher/src/storage/player_inventory/player_inventory.dart';
import 'package:block_crusher/src/utils/game_characters/playable_characters.dart';
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

    return Scaffold(
      backgroundColor: profileBackgroundColors[playerInventory.selectedBackgroundColorIndexForProfile],
      appBar: AppBar(title: const Text('Profile'),),
      body: Column(
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
    );
  }

  characterWidget(String character) {
    final characterObject = jsonDecode(character);

    return Container(width: 50, height: 50, child: Padding(padding: const EdgeInsets.all(5), child: Image.asset('assets/images/${characterObject['source']}'),),);
  }
}

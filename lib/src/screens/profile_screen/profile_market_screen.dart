
import 'dart:convert';

import 'package:block_crusher/src/screens/profile_screen/profile_action_button_section.dart';
import 'package:block_crusher/src/screens/profile_screen/profile_back_button.dart';
import 'package:block_crusher/src/screens/profile_screen/profile_characters_view.dart';
import 'package:block_crusher/src/screens/profile_screen/profile_color_slider.dart';
import 'package:block_crusher/src/screens/profile_screen/profile_statistics_section.dart';
import 'package:block_crusher/src/screens/profile_screen/profile_top_part.dart';
import 'package:block_crusher/src/screens/profile_screen/profile_background_color.dart';
import 'package:block_crusher/src/storage/level_statistics.dart';
import 'package:block_crusher/src/storage/player_inventory.dart';
import 'package:block_crusher/src/database/player_inventory_database.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/audio_controller.dart';
import '../../services/sounds.dart';
import '../../utils/responsive_screen.dart';

class ProfileMarketScreen extends StatefulWidget {
  const ProfileMarketScreen({Key? key}) : super(key: key);

  @override
  State<ProfileMarketScreen> createState() => _ProfileMarketScreenState();
}

class _ProfileMarketScreenState extends State<ProfileMarketScreen> {
  @override
  Widget build(BuildContext context) {
    final playerInventory = context.watch<PlayerInventory>();
    final levelStatistics = context.watch<LevelStatistics>();

    final Color backgroundColor = profileBackgroundColors[playerInventory.selectedBackgroundColorIndexForProfile];

    return Scaffold(
        backgroundColor: backgroundColor,

        body: Stack(children: const [
          ProfileTopWidget(
            width: 200,
            title: 'Profile', itemBackgroundColor: Colors.white, itemTextColor: Colors.white, extra :
          ProfileWallet(width: 150,),),
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
        SizedBox(height: 80),
        ProfileStatisticsButton(),
        Expanded(child: ProfileCharactersView()),
        ProfileColorSlider(),
        SizedBox(height:80,),
      ],
    );
  }
}

class ProfileStatisticsButton extends StatelessWidget {
  const ProfileStatisticsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.all(8), margin: EdgeInsets.all(8),width: double.infinity, height: 60, child:
    ElevatedButton(onPressed: () {final audio = context.read<AudioController>();
    audio.playSfx(SfxType.buttonTap);
    GoRouter.of(context).pushReplacement('/play/profile');  }, child: Text('Game statistics'),
      
    ));
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
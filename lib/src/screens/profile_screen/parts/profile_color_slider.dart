import 'package:block_crusher/src/screens/profile_screen/parts/profile_container.dart';
import 'package:block_crusher/src/screens/profile_screen/parts/profile_top_part.dart';
import 'package:block_crusher/src/storage/player_inventory/player_inventory.dart';
import 'package:block_crusher/src/storage/treasure_counts/treasure_counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../profile_background_color.dart';

class ProfileColorSlider extends StatelessWidget {
  const ProfileColorSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerInventory = context.read<PlayerInventory>();
    final treasureCounter = context.read<TreasureCounter>();

    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProfileContainer(
          width: double.infinity,
          height: 80,
          color: Colors.white,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (int i = 0; i < 29; i++)
                ElevatedButton(onPressed: () {
                  playerInventory.changeSelectedBackgroundColorIndexForProfile(i);
                  treasureCounter.decreaseCoinCount(50);
                  }, child: Container(
                  decoration: BoxDecoration(borderRadius:
                  BorderRadius.circular(60),
                    border: Border.all(width:0.01, color: Colors.black),
                    color: profileBackgroundColors[i],), width: 50, height: 50,
                  child: Center(child: Text(i.toString()),),),),
            ],
          ),
        ),
      ),
    );
  }
}

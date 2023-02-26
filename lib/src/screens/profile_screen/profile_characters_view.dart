import 'package:block_crusher/src/screens/profile_screen/profile_container.dart';
import 'package:block_crusher/src/screens/profile_screen/profile_market_screen.dart';
import 'package:block_crusher/src/storage/player_inventory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/player_inventory_database.dart';

class ProfileCharactersView extends StatelessWidget {
  final ProfileCharacterTapCallback onTapEvent;

  const ProfileCharactersView({Key? key, required this.onTapEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inventory = context.watch<PlayerInventory>();

    return Center(
      child: Wrap(
        //scrollDirection: Axis.horizontal,
        //controller: PageController(),
        children: [
          for (int i = 0; i < inventory.availableCharacters.length; i++)
            _ProfileBaseCharacter(index : i, tapEvent: () => {
              onTapEvent(i)
            },),
        ],
      ),
    );
  }
}

class _ProfileBaseCharacter extends StatelessWidget {
  final int index;
  final GestureTapCallback? tapEvent;

  const _ProfileBaseCharacter({Key? key, required this.index, this.tapEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inventory = context.read<PlayerInventory>();

    return InkWell(
      onTap : tapEvent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 4, bottom:4),
            child: ProfileContainer(
              withOpacity: false,
              width: 35
              , height: 35,
              color: Colors.black,child: Text((index+1).toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),
          ),
          ProfileContainer( width: 100, height: 100,
            color: Colors.black,
            withOpacity: true,
            child: Center(child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.asset('assets/images/${charactersForInventory[inventory.availableCharacters[index]]['source']}'),
            )),
          ),
        ],
      ),
    );
  }
}

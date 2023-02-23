import 'package:block_crusher/src/screens/profile_screen/profile_container.dart';
import 'package:block_crusher/src/storage/player_inventory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/player_inventory_database.dart';

class ProfileCharactersView extends StatelessWidget {
  const ProfileCharactersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inventory = context.watch<PlayerInventory>();

    return SizedBox.expand(
      child: ListView(
        scrollDirection: Axis.horizontal,
        //controller: PageController(),
        children: [
          for (int i = 0; i < inventory.availableCharacters.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: _ProfileBaseCharacter(index : i),
            ),
        ],
      )
    );
  }
}

class _ProfileBaseCharacter extends StatelessWidget {
  final int index;

  const _ProfileBaseCharacter({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inventory = context.read<PlayerInventory>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProfileContainer(
            width: 100
            , height: 70,
            color: Colors.black,child: Text((index+1).toString(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),),
        ),
        ProfileContainer( width: 300, height: 300,
          color: Colors.black,
          child: Center(child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Image.asset('assets/images/${charactersForInventory[inventory.availableCharacters[index]]['source']}'),
          )),
        ),
      ],
    );
  }
}

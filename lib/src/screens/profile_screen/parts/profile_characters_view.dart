import 'package:block_crusher/src/storage/player_inventory/player_inventory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/player_inventory_database.dart';

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
            _ProfileBaseCharacter(index : i),
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

    return SizedBox( width: 300, height: 300,
      child: Center(child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Image.asset('assets/images/${charactersForInventory[inventory.availableCharacters[index]]['source']}'),
      )),
    );
  }
}

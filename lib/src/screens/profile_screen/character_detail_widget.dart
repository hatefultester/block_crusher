import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/player_inventory_database.dart';
import '../../storage/player_inventory.dart';

class CharacterDetailWidget extends StatelessWidget {
  final int index;
  final VoidCallback backButtonTap;

  const CharacterDetailWidget({
    Key? key,
    required this.index,
    required this.backButtonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inventory = context.read<PlayerInventory>();

    return SizedBox.expand(
      child: Stack(
        children: [
          InkWell(
            onTap: backButtonTap,
            child: Container(color: Colors.black.withOpacity(0.75)),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(20),
              width: 300,
              height: 300,
              child: Image.asset(
                  'assets/images/${charactersForInventory[inventory.availableCharacters[index]]['source']}'),
            ),
          )
        ],
      ),
    );
  }
}

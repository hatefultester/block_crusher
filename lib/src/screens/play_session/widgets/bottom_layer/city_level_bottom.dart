
import 'package:block_crusher/src/game_internals/level_logic/level_states/collector_game/collector_game_level_state.dart';
import 'package:block_crusher/src/utils/in_game_characters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CityLevelBottomWidget extends StatefulWidget {
  const CityLevelBottomWidget({Key? key}) : super(key: key);

  @override
  State<CityLevelBottomWidget> createState() => _CityLevelBottomWidgetState();
}

class _CityLevelBottomWidgetState extends State<CityLevelBottomWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      height: 60,
      width: double.infinity,
      child: Consumer<CollectorGameLevelState>(
        builder: (context, levelState, child) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < levelState.items.length; i++)
              Row(
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      width: levelState.items.length > 3 ? 40 : 50,
                      height: levelState.items.length > 3 ? 40 : 50,
                      child: Image.asset(
                          'assets/images/${cityFoods[levelState.characterId - 1]['characters'][i]['source']}')),
                  Container(
                    padding: const EdgeInsets.only(left: 4),
                    child: levelState.items[i] >=
                        cityFoods[levelState.characterId - 1]
                        ['characters'][i]['goal']
                        ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 25,
                    )
                        : Text(
                        '${levelState.items[i].toString()} / ${cityFoods[levelState.characterId - 1]['characters'][i]['goal']}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                            levelState.items.length > 3 ? 14 : 18)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

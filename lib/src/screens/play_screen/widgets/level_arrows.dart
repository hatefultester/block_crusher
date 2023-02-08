import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../play_screen_provider.dart';

class LevelArrows extends StatefulWidget {
  const LevelArrows({Key? key}) : super(key: key);

  @override
  State<LevelArrows> createState() => _LevelArrowsState();
}

class _LevelArrowsState extends State<LevelArrows> {
  int page = 2;


  @override
  Widget build(BuildContext context) {
    final playScreenProvider = context.watch<PlayScreenProvider>();

    return Align(alignment: Alignment.bottomCenter,
    child: Container(padding: const EdgeInsets.only(left: 10, right: 10), height: 100, width: double.infinity, child:
    Row(children: [
      IconButton(icon: Icon(Icons.arrow_left, color: Colors.white, size: 25), onPressed: () => {playScreenProvider.previousPage()},) ,
      const Spacer(),
     IconButton(icon: Icon(Icons.arrow_right, color: Colors.white, size: 25), onPressed: () => {playScreenProvider.nextPage()},),
    ],),),
    );
  }
}

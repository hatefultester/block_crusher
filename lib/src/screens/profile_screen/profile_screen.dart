import 'package:block_crusher/src/game_internals/player_progress/player_progress.dart';
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
    final playerProgress = context.read<PlayerProgress>();

    return Scaffold(
      body: ResponsiveScreen(squarishMainArea: Column(children:[
        Container(height: 100, width: 100, child: Image.asset('assets/images/${playCharacters[0].imagePath}'),),],
      ), rectangularMenuArea: ElevatedButton(child: Text('Back'), onPressed: () => {
      Navigator.pop(context),},),),
    );
  }
}

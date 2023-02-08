import 'package:block_crusher/src/screens/settings_screen/settings_background.dart';
import 'package:block_crusher/src/screens/settings_screen/settings_view.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [
          SettingsBackground(),
          SettingsView(),
        ],
      ),
    );
  }
}

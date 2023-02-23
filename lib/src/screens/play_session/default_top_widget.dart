import 'dart:io';

import 'package:flutter/material.dart';

import 'coin_wallet.dart';
import 'heart_widget.dart';

class DefaultTopWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onExit;

  const DefaultTopWidget(
      {Key? key, required this.title, required this.imagePath, required this.onExit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black.withOpacity(0.9),Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
      ),
      height: 60,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.cancel_rounded,
              color: Colors.white,
              size: 25,
            ),
            onPressed: (onExit),
          ),
          const Spacer(),
          const CoinWalletWidget(backgroundColor: Colors.red, textColor: Colors.white),
          const HeartWidget(backgroundColor: Colors.red, textColor: Colors.white),
        ],
      ),
    );

    if (Platform.isIOS) {
      return Column(
        children: [
          Container(
            color: Colors.black,
            height: 40,
          ),
          content
        ],
      );
    } else {
      return content;
    }
  }
}

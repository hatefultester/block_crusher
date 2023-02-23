import 'dart:io';

import 'package:flutter/material.dart';

import 'coin_wallet.dart';
import 'image_widget.dart';

class CityTopWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onExit;

  const CityTopWidget(
      {Key? key, required this.title, required this.imagePath, required this.onExit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      decoration: const BoxDecoration(color: Colors.black),
      height: 60,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            ),
            onPressed: (onExit),
          ),
          const Spacer(),
          ImageWidget(path: imagePath),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          ImageWidget(
            path: imagePath,
          ),
          const Spacer(),
          CoinWalletWidget(backgroundColor: Colors.white, textColor: Colors.black),
          const Spacer(),
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

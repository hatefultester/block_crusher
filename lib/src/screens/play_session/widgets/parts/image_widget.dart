
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String path;
  final double size;


  const ImageWidget({Key? key, required this.path, this.size = 60}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      padding: const EdgeInsets.all(10),
      child: Image.asset(
          path),
    );
  }
}

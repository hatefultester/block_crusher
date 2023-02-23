
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String path;
  final double width;
  final double height;
  final bool symmetric;


  const ImageWidget({Key? key, required this.path, this.width = 60, this.height=60, this.symmetric = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: symmetric ? width : height,
      width: width,
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Image.asset(
            path),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileBackButton extends StatelessWidget {
  const ProfileBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Align( alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          height: 70,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(bottom:10),
          child: ElevatedButton(
            child: Text('Back'),
            onPressed: (() => {
              GoRouter.of(context).go('/play'),
            }),
          ),
        ),
      ),
    );
  }
}

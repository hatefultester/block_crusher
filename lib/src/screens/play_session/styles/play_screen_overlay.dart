import 'package:flutter/material.dart';

class PlaySessionStartOverlay extends StatefulWidget {
  final String title;
  final String path;

  const PlaySessionStartOverlay({super.key, required this.title, required this.path});

  @override
  State<PlaySessionStartOverlay> createState() => _PlaySessionStartOverlayState();
}

class _PlaySessionStartOverlayState extends State<PlaySessionStartOverlay> {

  bool resize = false;
  bool fall = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds : 3),
      color: !resize ? Colors.black : Colors.black.withOpacity(0.4),
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        margin: !fall? const EdgeInsets.only(bottom: 800): const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width:  100,
              height: 100,
              child: Image.asset(widget.path),
            ),
            const SizedBox(height: 50,),
            AnimatedContainer(
              duration: const Duration(seconds: 2),
              width: !resize ? 100 : 200,
              child: FittedBox(fit: BoxFit.fill, child:
                  Text(widget.title, style: const TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        fall = true;
      });
      await Future.delayed(const Duration(seconds: 1),);

      setState(() {
        resize = true;
      });
    });
  }
}

class PlaySessionDeathOverlay extends StatefulWidget {
  const PlaySessionDeathOverlay({Key? key}) : super(key: key);

  @override
  State<PlaySessionDeathOverlay> createState() => _PlaySessionDeathOverlayState();
}

class _PlaySessionDeathOverlayState extends State<PlaySessionDeathOverlay> {
  bool resize = false;
  bool fall = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds : 3),
      color: !resize ? Colors.black.withOpacity(0.1) : Colors.black.withOpacity(1),
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow:  [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.25),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(15),
                width:  120,
                height: 120,
                child: Image.asset('assets/images/in_app/death_heart.png'),
              ),
            ),
            const SizedBox(height: 50,),
            AnimatedContainer(
              duration: const Duration(seconds: 2),
              width: !resize ? 100 : 200,
              child: const FittedBox(fit: BoxFit.fill, child:
              Text('You died', style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        fall = true;
      });
      await Future.delayed(const Duration(seconds: 1),);

      setState(() {
        resize = true;
      });
    });
  }
}

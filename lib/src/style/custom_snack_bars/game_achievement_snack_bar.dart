import 'package:block_crusher/src/style/custom_snack_bars/scaffold_key.dart';
import 'package:block_crusher/strings/achievement_snack_bar_texts.dart';
import 'package:flutter/material.dart';

import '../../storage/game_achievements/achievements.dart';

void showAchievementSnackBar(GameAchievement achievement) {
  final messenger = scaffoldMessengerKey.currentState;
  messenger?.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      dismissDirection: DismissDirection.horizontal,
      clipBehavior: Clip.antiAlias,

      duration: const Duration(seconds:3),
      margin: EdgeInsets.only(bottom: MediaQuery.of(messenger.context).size.height-50, right: 20, left: 20, top: 0),
      content: AchievementSnackBarTransitionMessageWidget(achievement: achievement),
    ),
  );
}

class AchievementSnackBarTransitionMessageWidget extends StatefulWidget {
final GameAchievement achievement;
final Color color;

  const AchievementSnackBarTransitionMessageWidget({Key? key, required this.achievement, this.color = Colors.blue}) : super(key: key);

  @override
  State<AchievementSnackBarTransitionMessageWidget> createState() => _AchievementSnackBarTransitionMessageWidgetState();
}

class _AchievementSnackBarTransitionMessageWidgetState extends State<AchievementSnackBarTransitionMessageWidget> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnimatedContainer(duration: const Duration(milliseconds: 500),
          width: selected ? 0 : 150,
        ),
        AnimatedContainer(duration: const Duration(milliseconds: 1300),
        alignment: selected ? Alignment.topLeft : const Alignment(1.5,0),

        decoration: BoxDecoration(
        gradient: selected ? LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [widget.color, widget.color.withOpacity(0.8)]) : LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight ,colors: [widget.color.withOpacity(0.5), Colors.transparent]),
        borderRadius: selected ? BorderRadius.circular(50) : BorderRadius.circular(5),
        ),
        width: selected ? 300: 200,
        height: selected ? 110 : 150,
        curve: Curves.fastOutSlowIn,
        child: Stack(
          children: [
            Container(
                padding: const EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Flexible(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const FittedBox(
                             fit: BoxFit.scaleDown,
                             child: Text('A C H I E V E M E N T !', style: TextStyle(color: Colors.white, fontFamily: 'Quikhand', fontSize: 18),)),
                         const SizedBox(height: 5,),
                         FittedBox(
                             fit: BoxFit.scaleDown,
                             child: Text(widget.achievement.message(), style: const TextStyle(color: Colors.white, fontFamily: 'Quikhand', fontSize: 15),maxLines: 2,)),
                       ],
                     ),
                   ),
                   SizedBox(width: 50, child: Image.asset(widget.achievement.imagePath(),),),
                 ],
                    ),),
            Transform.translate(
              offset: const Offset(-5,15),
              child: Align(alignment: Alignment.bottomLeft, child: Container(
                  padding: const EdgeInsets.only(right: 15, top: 20),
                  width: 40, child: Image.asset('assets/images/lock/lock_unlocked.png',),),),
            ),
          ],
        ),),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        selected = true;
      });
    });
  }

}
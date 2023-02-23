import 'package:block_crusher/src/storage/achievements.dart';

extension AchievementSnackBarStringData on GameAchievement {
 String message() {
   String message = '';

    switch(this) {

      case GameAchievement.connectTwoPlayers:
        message = 'You have successfully connect two players for the first time :)';
        break;
      case GameAchievement.firstPurchase:
        message = 'Your first purchase';
        break;
      case GameAchievement.finishedSoomyLand:
        // TODO: Handle this case.
        break;
      case GameAchievement.finishedSeaLand:
        // TODO: Handle this case.
        break;
      case GameAchievement.finishedHoomyLand:
        // TODO: Handle this case.
        break;
    }

    return message;
  }

 String imagePath() {
   String path = 'assets/images';

    switch(this) {

      case GameAchievement.connectTwoPlayers:
        path = '$path/characters_skill_game/1_1000x880.png';
        break;
      case GameAchievement.firstPurchase:
        path = '$path/coins/1000x677/money.png';
        break;
      case GameAchievement.finishedSoomyLand:
        break;
      case GameAchievement.finishedSeaLand:
        // TODO: Handle this case.
        break;
      case GameAchievement.finishedHoomyLand:
        // TODO: Handle this case.
        break;
    }


   return path;
  }

}
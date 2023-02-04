import 'package:block_crusher/src/google_play/games_services/score.dart';

class GamePlayStatistics {
  final Duration duration;

  final int level;

  final int coinCount;

  String get formattedTime => duration.toFormattedString();

  final bool alreadyFinishedLevel;

  final String winningCharacter;

  GamePlayStatistics({required this.duration, required this.level, required this.coinCount, required this.alreadyFinishedLevel, required this.winningCharacter, });
}
import 'package:block_crusher/src/database/levels.dart';
import 'package:block_crusher/src/database/model/level.dart';
import 'package:block_crusher/src/game/world_type.dart';
import 'package:block_crusher/src/screens/main_screen/main_screen.dart';
import 'package:block_crusher/src/screens/play_screen/play_screen.dart';
import 'package:block_crusher/src/screens/play_session/game_play_statistics.dart';
import 'package:block_crusher/src/screens/play_session/play_session_screen.dart';
import 'package:block_crusher/src/screens/profile_screen/profile_market_screen.dart';
import 'package:block_crusher/src/screens/profile_screen/profile_screen.dart';
import 'package:block_crusher/src/screens/settings_screen/settings_screen.dart';
import 'package:block_crusher/src/screens/winning_screen/game_finished_screen.dart';
import 'package:block_crusher/src/screens/winning_screen/lost_game_screen.dart';
import 'package:block_crusher/src/screens/winning_screen/win_game_screen.dart';
import 'package:block_crusher/src/utils/my_transition.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(key: Key('main menu')),
        routes: [
          GoRoute(
              path: 'play',
              pageBuilder: (context, state) => buildMyTransition<void>(
                    child: const PlayScreen(key: Key('play screen')),
                    color: Colors.black,
                  ),
              routes: [
                GoRoute(
                  path: 'profile',
                  pageBuilder: (context, state) {
                    return buildMyTransition(
                        child: const ProfileScreen(key: Key('user profile')),
                        color: Colors.black);
                  },
                ),
                GoRoute(
                  path: 'profile_market',
                  pageBuilder: (context, state) {
                    return buildMyTransition(
                        child: const ProfileMarketScreen(
                            key: Key('user profile market')),
                        color: Colors.black);
                  },
                ),
                GoRoute(
                  path: 'settings',
                  builder: (context, state) =>
                      const SettingsScreen(key: Key('user settings')),
                ),
                GoRoute(
                  path: 'session/:level/:sublevel',
                  pageBuilder: (context, state) {
                    final levelNumber = int.parse(state.params['level']!);

                    final subLevel = int.parse(state.params['sublevel']!);

                    final level = gameLevels.singleWhere(
                        (e) => e.levelId == levelNumber,
                        orElse: () => const GameLevel(
                            worldType: WorldType.hoomyLand,
                            levelId: 0,
                            characterId: 0));

                    if (level.levelId != 0) {
                      return buildMyTransition<void>(
                        child: PlaySessionScreen(
                          level,
                          key: const Key('play session'),
                        ),
                        color: Colors.black,
                      );
                    } else {
                      return buildMyTransition<void>(
                        child: const GameFinishedScreen(
                          key: Key('play session'),
                        ),
                        color: Colors.black,
                      );
                    }
                  },
                ),
                GoRoute(
                  path: 'won',
                  pageBuilder: (context, state) {
                    final map = state.extra! as Map<String, dynamic>;
                    final score = map['score'] as GamePlayStatistics;

                    return buildMyTransition<void>(
                      child: WinGameScreen(
                        score: score,
                        key: const Key('win game'),
                      ),
                      color: Colors.black,
                    );
                  },
                ),
                GoRoute(
                  path: 'lost',
                  pageBuilder: (context, state) {
                    final map = state.extra! as Map<String, dynamic>;
                    final score = map['score'] as GamePlayStatistics;

                    return buildMyTransition<void>(
                      child: LostGameScreen(
                        score: score,
                        key: const Key('lost game'),
                      ),
                      color: Colors.black,
                    );
                  },
                )
              ]),
          GoRoute(
            path: 'settings',
            builder: (context, state) =>
                const SettingsScreen(key: Key('settings')),
          ),
        ]),
  ],
);

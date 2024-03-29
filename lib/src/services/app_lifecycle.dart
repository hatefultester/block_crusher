// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class AppLifecycleObserver extends StatefulWidget {
  final Widget child;

  static AppLifecycleState appState = AppLifecycleState.inactive;

  const AppLifecycleObserver({required this.child, super.key});

  @override
  State<AppLifecycleObserver> createState() => AppLifecycleObserverState();
}

class AppLifecycleObserverState extends State<AppLifecycleObserver>
    with WidgetsBindingObserver {
  static final _log = Logger('AppLifecycleObserver');

  static final ValueNotifier<AppLifecycleState> lifecycleListenable =
      ValueNotifier(AppLifecycleState.inactive);

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<ValueNotifier<AppLifecycleState>>.value(
      value: lifecycleListenable,
      child: widget.child,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('didChangeAppLifecycleState: $state');
    lifecycleListenable.value = state;
    AppLifecycleObserver.appState = state;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _log.info('Subscribed to app lifecycle updates');
  }
}

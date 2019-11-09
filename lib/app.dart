import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'package:ruhe/interfaces.dart';
import 'package:ruhe/pages/main/page.dart';
import 'package:ruhe/services/logging.dart';
import 'package:ruhe/services/router.dart';
import 'package:ruhe/services/theming.dart';

class App extends State<AppWidget> {
  static GetIt locator;

  App() {
    // like y tho.
    GetIt.allowMultipleInstances = true;

    locator = App.setupRegistration(GetIt.asNewInstance());
  }

  static GetIt setupRegistration(GetIt l) {
    final isTestMode =
        !kIsWeb && Platform.resolvedExecutable.contains('_tester');
    var isDebugMode = false;

    // NB: Assert statements are stripped from release mode. Clever!
    assert(isDebugMode = true);

    final appMode = isTestMode
        ? ApplicationMode.test
        : isDebugMode ? ApplicationMode.debug : ApplicationMode.production;

    l
      ..registerSingleton<ApplicationMode>(appMode)
      ..registerSingleton<Router>(setupRoutes(Router()));

    if (appMode == ApplicationMode.production) {
      // TODO
    } else {
      // TODO
    }

    l.registerSingleton<LogWriter>(DebugLogWriter());
    return l;
  }

  static Router setupRoutes(Router r) {
    MainPage.setupRoutes(r);
    return r;
  }

  @override
  Widget build(BuildContext context) {
    //final routeObserver = App.locator<RouteObserver>();

    return MaterialApp(
      title: 'Ruhe',
      theme: ThemeMetrics.fullTheme(),
      initialRoute: '/',
      onGenerateRoute: App.locator<Router>().generator,
      navigatorObservers: [],
      // navigatorObservers: routeObserver != null ? [routeObserver] : [],
    );
  }
}

class AppWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => App();
}

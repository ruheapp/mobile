import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:fluro/fluro.dart';

import './pages/hello.dart';

class App extends State<AppWidget> {
  static GetIt locator;

  App() {
    locator = App.setupRegistration(GetIt());
  }

  static setupRegistration(GetIt l) {
    l.registerSingleton<Router>(setupRoutes(new Router()));
    return l;
  }

  static setupRoutes(Router r) {
    HelloPage.setupRoutes(r);
    return r;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ruhe',
      theme: ThemeData(primarySwatch: Colors.blue),
      onGenerateRoute: App.locator<Router>().generator,
    );
  }
}

class AppWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new App();
}

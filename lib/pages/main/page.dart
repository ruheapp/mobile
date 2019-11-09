import 'package:flutter/material.dart';

import 'package:ruhe/services/logging.dart';
import 'package:ruhe/services/router.dart';

class MainPage extends StatefulWidget {
  static Router setupRoutes(Router r) {
    final h = Router.exactMatchFor(
        route: '/',
        builder: (_) => MainPage(),
        bottomNavCaption: 'hello',
        bottomNavIcon: (c) => const Icon(
              Icons.settings,
              size: 30,
            ));

    r.routeHandlers.add(h);
    return r;
  }

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with LoggerMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text('hello hi'),
    );
  }
}

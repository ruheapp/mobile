import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class HelloPage extends StatelessWidget {
  static setupRoutes(Router r) {
    r.define("/",
        handler: new Handler(
            type: HandlerType.route, handlerFunc: (_b, _c) => HelloPage()));

    return r;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("sandwiches."),
        ),
        body: Center(child: Text("hi")));
  }
}

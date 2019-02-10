import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:ruhe/app.dart';
import 'package:ruhe/interfaces.dart';

class HelloPage extends StatefulWidget {
  static setupRoutes(Router r) {
    r.define("/",
        handler: new Handler(
            type: HandlerType.route, handlerFunc: (_b, _c) => HelloPage()));

    return r;
  }

  @override
  _HelloPageState createState() => _HelloPageState();
}

class _HelloPageState extends State<HelloPage> {
  doSomething() async {
    final LoginManager lm = App.locator<LoginManager>();
    await lm.ensureNamedUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("sandwiches."),
        ),
        body: Center(
            child:
                RaisedButton(child: Text("Upgrade"), onPressed: doSomething)));
  }
}

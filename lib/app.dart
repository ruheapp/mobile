import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:fluro/fluro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:ruhe/interfaces.dart';
import 'package:ruhe/pages/login.dart';

import './pages/hello.dart';

class FirebaseLoginManager extends LoginManager {
  UserInfo _currentUser;
  UserInfo get currentUser => _currentUser;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<UserInfo> login() async {
    var ret = await FirebaseAuth.instance.currentUser();

    if (ret == null) {
      ret = await FirebaseAuth.instance.signInAnonymously();
    }

    _currentUser = ret;
    return ret;
  }

  @override
  Future<void> logout() {
    _currentUser = null;
    return FirebaseAuth.instance.signOut();
  }

  @override
  Future<UserInfo> ensureNamedUser() async {
    if (_currentUser.email != null && _currentUser.email.isNotEmpty) {
      return _currentUser;
    }

    try {
      final newUser = await _upgradeAnonymousUser();
      _currentUser = newUser;

      return newUser;
    } finally {
      await logout();
    }
  }

  Future<UserInfo> _upgradeAnonymousUser() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;

    final cred = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(cred);
  }
}

class App extends State<AppWidget> {
  static GetIt locator;

  App() {
    locator = App.setupRegistration(GetIt());
  }

  static setupRegistration(GetIt l) {
    l.registerSingleton<Router>(setupRoutes(new Router()));
    l.registerSingleton<LoginManager>(new FirebaseLoginManager());

    return l;
  }

  static setupRoutes(Router r) {
    HelloPage.setupRoutes(r);
    LoginPage.setupRoutes(r);

    return r;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ruhe',
      initialRoute: '/login',
      theme: ThemeData(primarySwatch: Colors.blue),
      onGenerateRoute: App.locator<Router>().generator,
    );
  }
}

class AppWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new App();
}

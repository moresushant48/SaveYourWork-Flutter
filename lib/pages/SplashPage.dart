import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  var _isAuthEnabled;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      _isLoggedIn().then((value) async {
        if (value) {
          if (_isAuthEnabled) // if authentication
            await _localAuthentication.canCheckBiometrics
                .then((canCheck) async {
              canCheck
                  ? await _localAuthentication
                      .authenticateWithBiometrics(
                          localizedReason: "Wait, you gotta pass this test.")
                      .then((authSuccess) {
                      if (authSuccess)
                        Navigator.popAndPushNamed(context, "/home");
                      else
                        SystemNavigator.pop();
                    })
                  : null;
            }); // is enabled. Ask for auth.
          else
            Navigator.popAndPushNamed(
                context, "/home"); // is disabled. Directly go home.
        } else
          Navigator.popAndPushNamed(context, "/login");
      });
    });
  }

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool("isLoggedIn");

    // CHECK IF AUTHENTICATION IS NULL.
    // IF YES : _isAuthEnabled = false
    // IF NO :
    // CHECK IF AUTHENTICATION IS ENABLED.
    // IF YES : _isAuthEnabled = true
    // IF NO : _isAuthEnabled = false
    _isAuthEnabled = prefs.getBool("isAuthEnabled");
    _isAuthEnabled == null
        ? _isAuthEnabled = false
        : _isAuthEnabled ? _isAuthEnabled = true : _isAuthEnabled = false;

    return value == null
        ? Future<bool>.value(false)
        : (value ? Future<bool>.value(true) : Future<bool>.value(false));
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: LinearProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation(Colors.amber),
              ),
            ),
            width: orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width - 100
                : (MediaQuery.of(context).size.width / 2) - 100,
          ),
          Image.asset(
            "assets/images/AppLogo.png",
            width: orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width - 140
                : (MediaQuery.of(context).size.width / 2) - 140,
          ),
          SizedBox(height: 12),
          SizedBox(
            child: LinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(Colors.amber),
            ),
            width: orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width - 100
                : (MediaQuery.of(context).size.width / 2) - 100,
          )
        ],
      ),
    );
  }
}

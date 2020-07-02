import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      _isLoggedIn().then((value) {
        value
            ? Navigator.popAndPushNamed(context, "/home")
            : Navigator.popAndPushNamed(context, "/login");
      });
    });
  }

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool("isLoggedIn");

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

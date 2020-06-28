import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:web_test/pages/HomePage.dart';
import 'package:web_test/pages/LoginPage.dart';
import 'package:web_test/pages/RegisterPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
              fontFamily: 'Oxygen',
              primarySwatch: Colors.indigo,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SaveYourWork',
            theme: theme,
            home: LoginPage(),
            routes: {
              "/home": (context) => HomePage(),
              "/login": (context) => LoginPage(),
              "/register": (context) => RegisterPage()
            },
          );
        });
  }
}

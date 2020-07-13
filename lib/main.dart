import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:web_test/pages/AboutPage.dart';
import 'package:web_test/pages/HomePage.dart';
import 'package:web_test/pages/LoginPage.dart';
import 'package:web_test/pages/RegisterPage.dart';
import 'package:web_test/pages/SharedUserPage.dart';
import 'package:web_test/pages/SplashPage.dart';

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
            appBarTheme: AppBarTheme(
                elevation: 0.0,
                textTheme: TextTheme(
                    headline6: TextStyle(
                        color: brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
                iconTheme: IconThemeData(
                    color: brightness == Brightness.light
                        ? Colors.grey
                        : Colors.white))),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SaveYourWork',
            theme: theme,
            home: SplashPage(),
            routes: {
              "/home": (context) => HomePage(),
              "/login": (context) => LoginPage(),
              "/register": (context) => RegisterPage(),
              "/about": (context) => AboutPage(),
              "/shared": (context) => SharedUserFiles(0)
            },
          );
        });
  }
}

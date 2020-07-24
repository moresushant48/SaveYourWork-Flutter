import 'package:SaveYourWork/Router.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

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
            initialRoute: "/",
            onGenerateRoute: Router.generateRoute,
          );
        });
  }
}

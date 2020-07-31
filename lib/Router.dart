import 'package:SaveYourWork/pages/AboutPage.dart';
import 'package:SaveYourWork/pages/AccountPage.dart';
import 'package:SaveYourWork/pages/HomePage.dart';
import 'package:SaveYourWork/pages/IndexPage/IndexWebPage.dart';
import 'package:SaveYourWork/pages/LoginPage.dart';
import 'package:SaveYourWork/pages/RegisterPage.dart';
import 'package:SaveYourWork/pages/SharedUserPage.dart';
import 'package:SaveYourWork/pages/SplashPage.dart';
import 'package:SaveYourWork/pages/UserWaiting.dart';
import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            settings: settings, builder: (_) => SplashPage());
      case '/index':
        return MaterialPageRoute(
            settings: settings, builder: (_) => IndexWebPage());
      case '/home':
        return MaterialPageRoute(
            settings: settings, builder: (_) => HomePage());
      case '/login':
        return MaterialPageRoute(
            settings: settings, builder: (_) => LoginPage());
      case '/register':
        return MaterialPageRoute(
            settings: settings, builder: (_) => RegisterPage());
      case '/about':
        return MaterialPageRoute(
            settings: settings, builder: (_) => AboutPage());
      case '/account':
        return MaterialPageRoute(
            settings: settings, builder: (_) => AccountPage());
      case '/shared':
        return MaterialPageRoute(
            settings: settings, builder: (_) => SharedUserFiles(0));
      default:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => UserWaitPage(settings.name.substring(1)));
    }
  }
}

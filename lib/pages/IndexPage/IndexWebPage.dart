import 'package:SaveYourWork/pages/IndexPage/AboutInfoPage.dart';
import 'package:SaveYourWork/pages/IndexPage/AppPromoPage.dart';
import 'package:SaveYourWork/pages/IndexPage/FooterPage.dart';
import 'package:SaveYourWork/pages/IndexPage/MainPage.dart';
import 'package:flutter/material.dart';

class IndexWebPage extends StatefulWidget {
  static const eachPageHeight = 600.0;
  @override
  _IndexWebPageState createState() => _IndexWebPageState();
}

class _IndexWebPageState extends State<IndexWebPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
            // Main Page.
            MainPage(),

            // APP PROMOTIONAL LINKS AND IMAGES.
            AppPromoPage(),

            // SOME INFORMATIVE LINES AND SOCIAL HANDLES.
            AboutInfoPage(),

            // FOOTER WITH NAVIGATION LINKS AND COPYRIGHT.
            FooterPage()
          ],
        ),
      ),
    );
  }
}

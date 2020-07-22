import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:SaveYourWork/pages/DrawerPage.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: AppDrawer(),
      body: AboutBody(),
      floatingActionButton: kIsWeb
          ? null
          : FloatingActionButton(
              child: Icon(Icons.email),
              onPressed: () => launch("mailto:moresushant48@gmail.com"),
            ),
    );
  }
}

class AboutBody extends StatelessWidget {
  const AboutBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Flex(
          direction: isPortrait ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipPath(
              clipper: isPortrait
                  ? OvalBottomBorderClipper()
                  : OvalRightBorderClipper(),
              child: Image.asset(
                "assets/images/avatar.png",
                height: isPortrait ? null : MediaQuery.of(context).size.height,
                width: isPortrait ? MediaQuery.of(context).size.width : null,
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Developer",
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "Sushant More",
                      style: TextStyle(
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w600,
                          fontSize: 24.0),
                    ),
                    Text(
                      "@moresushant48",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    GestureDetector(
                      child: Image(
                        color: DynamicTheme.of(context).brightness ==
                                Brightness.dark
                            ? Colors.white
                            : null,
                        height: 50.0,
                        width: 50.0,
                        image: AssetImage("assets/images/github.png"),
                      ),
                      onTap: () async =>
                          await canLaunch("https://github.com/moresushant48/")
                              .then((value) => value
                                  ? launch("https://github.com/moresushant48/")
                                  : null),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

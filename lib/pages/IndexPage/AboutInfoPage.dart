import 'package:SaveYourWork/pages/IndexPage/IndexWebPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: IndexWebPage.eachPageHeight,
      child: RotatedBox(
        quarterTurns: 2,
        child: ClipPath(
          clipper: DiagonalPathClipperOne(),
          child: Container(
            color: Colors.indigo,
            child: RotatedBox(
              quarterTurns: -2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //
                  SizedBox(height: 60.0),
                  //

                  Card(
                    elevation: 8.0,
                    shape: CircleBorder(side: BorderSide(color: Colors.white)),
                    child: Container(
                      padding: EdgeInsets.all(24.0),
                      child: FaIcon(
                        FontAwesomeIcons.quoteRight,
                        color: Colors.indigo,
                      ),
                    ),
                  ),

                  //
                  SizedBox(height: 30.0),

                  //
                  Text(
                    "“SaveYourWork” is an online platform where users can \nUpload & Download their files from anywhere in the world, at any time. \nYou can write and save Text Documents like \ncreating a simple To-Do List to Saving and Sharing your code \nwith your colleagues and friends, On-The-Go.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  ),

                  SizedBox(height: 40.0),

                  //
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            if (await canLaunch(
                                "https://twitter.com/Moresush48")) {
                              await launch("https://twitter.com/Moresush48");
                            }
                          },
                          child: FaIcon(
                            FontAwesomeIcons.twitter,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.0),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            if (await canLaunch(
                                "https://github.com/moresushant48")) {
                              await launch("https://github.com/moresushant48");
                            }
                          },
                          child: FaIcon(
                            FontAwesomeIcons.github,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.0),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            if (await canLaunch(
                                "https://www.instagram.com/_moresushant48_/")) {
                              await launch(
                                  "https://www.instagram.com/_moresushant48_/");
                            }
                          },
                          child: FaIcon(
                            FontAwesomeIcons.instagram,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

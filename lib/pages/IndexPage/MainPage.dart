import 'package:SaveYourWork/pages/IndexPage/IndexWebPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      // alignment: Alignment.center,
      children: [
        //
        // BACKGROUND IMAGE
        ClipPath(
          clipper: DiagonalPathClipperOne(),
          child: Image(
            width: MediaQuery.of(context).size.width,
            height: IndexWebPage.eachPageHeight,
            color: Colors.black,
            colorBlendMode: BlendMode.screen,
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),

        // APP BAR
        Container(
          alignment: Alignment.topCenter,
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "SaveYourWork",
              style: TextStyle(
                  fontFamily: 'Lobster',
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            actions: [
              FlatButton(
                  onPressed: () => Navigator.pushNamed(context, "/login"),
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  )),
              FlatButton(
                  onPressed: () => Navigator.pushNamed(context, "/register"),
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),

        // CENTERED CONTENT
        Container(
          height: IndexWebPage.eachPageHeight,
          width: MediaQuery.of(context).size.width,
          child: AnimationLimiter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: AnimationConfiguration.toStaggeredList(
                duration: Duration(seconds: 1),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 100.0,
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  Image(
                    height: 180.0,
                    width: 180.0,
                    image: AssetImage("assets/images/share.png"),
                  ),

                  Container(
                    padding: EdgeInsets.all(16.0),
                    width: 500.0,
                    child: Divider(
                      height: 30.0,
                      color: Colors.white,
                    ),
                  ),

                  //
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Upload your files and be able to access them from\nanywhere in the world, with ease.",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),

                  //
                  SizedBox(height: 10.0),

                  //
                  OutlineButton.icon(
                    borderSide: BorderSide(
                        color: Colors.white,
                        style: BorderStyle.solid,
                        width: 2.0),
                    icon: Icon(
                      Icons.book,
                      size: 16.0,
                    ),
                    textColor: Colors.white,
                    label: Text(
                      "READ MORE",
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

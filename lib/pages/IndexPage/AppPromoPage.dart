import 'package:SaveYourWork/pages/IndexPage/IndexWebPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppPromoPage extends StatelessWidget {
  const AppPromoPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      padding: EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width,
      height: _isPortrait
          ? IndexWebPage.eachPageHeight + 100.0
          : IndexWebPage.eachPageHeight,
      child: Flex(
        direction: _isPortrait ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: _isPortrait ? 1 : 2,
            child: Image(
              image: AssetImage("assets/images/screens.png"),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: _isPortrait
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                //
                Text(
                  "Keep Your Files\nIn Sync.",
                  textAlign: _isPortrait ? TextAlign.center : TextAlign.start,
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //
                SizedBox(height: 12.0),
                //
                Text(
                  "Keep your files in sync using our App\nmade for your Device.",
                  textAlign: _isPortrait ? TextAlign.center : TextAlign.start,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),

                //
                SizedBox(height: 18.0),

                //
                Row(
                  mainAxisAlignment: _isPortrait
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    // ANDROID
                    FlatButton.icon(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        color: Colors.indigo,
                        textColor: Colors.white,
                        icon: FaIcon(FontAwesomeIcons.android),
                        label: Text("Android")),

                    //
                    SizedBox(width: 8.0),

                    // IOS
                    FlatButton.icon(
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        color: Colors.indigo,
                        textColor: Colors.white,
                        icon: FaIcon(FontAwesomeIcons.apple),
                        label: Text("IOS")),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

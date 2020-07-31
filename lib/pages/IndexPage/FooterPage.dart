import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class FooterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo,
      alignment: Alignment.center,
      child: Column(
        children: [
          //

          ClipPath(
            clipper: OvalTopBorderClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.indigo[700],
              padding: EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/feedback"),
                      child: Text(
                        "Feedback",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/contact"),
                      child: Text(
                        "Contact",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            color: Colors.indigo[800],
            padding: EdgeInsets.all(12.0),
            child: Text(
              "© 2020 Copyright : Sushant More - All Rights Reserved",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text("moresushant48@gmail.com"),
            accountName: Text("Sushant More"),
            otherAccountsPictures: [
              IconButton(
                  icon: Icon(Icons.brightness_4),
                  color: Colors.white,
                  onPressed: () {
                    DynamicTheme.of(context).setBrightness(
                        Theme.of(context).brightness == Brightness.dark
                            ? Brightness.light
                            : Brightness.dark);
                  })
            ],
          )
        ],
      ),
    );
  }
}

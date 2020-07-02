import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          ),

          // Logout Tile.
          ListTile(
            title: Text("Logout"),
            trailing: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Logout"),
                    content: Text("Do you really want to logout ?"),
                    actions: [
                      FlatButton(
                        child: Text("No"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      FlatButton(
                        child: Text("Yes"),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool("isLoggedIn", false);
                          Navigator.pushNamedAndRemoveUntil(context,
                              Navigator.defaultRouteName, (route) => false);
                        },
                      )
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}

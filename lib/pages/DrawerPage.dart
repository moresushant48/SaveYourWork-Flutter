import 'dart:convert';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  SharedPreferences _prefs;
  String email = "";
  String username = "";

  @override
  void initState() {
    _getDataInVariables();

    super.initState();
  }

  _getDataInVariables() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      email = _prefs.getString("email");
      username = _prefs.getString("username");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(email),
            accountName: Text(username),
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

          Divider(),

          // About tile.
          ListTile(
            title: Text("About"),
            trailing: Icon(Icons.info),
            onTap: () => Navigator.pushReplacementNamed(context, "/about"),
          ),

          Divider(),

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

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_test/API/ApiMethodsImpl.dart';
import 'package:web_test/pages/SharedUserPage.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  SharedPreferences _prefs;
  String email = "";
  String username = "";

  TextEditingController _getUsernameController = TextEditingController();

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
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/header.jpg"),
                  fit: BoxFit.cover),
            ),
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

          ListTile(
            title: Text("My Files"),
            trailing: Icon(Icons.folder),
            subtitle: Text("Access your all files."),
            onTap: () => Navigator.pushReplacementNamed(context, "/home"),
          ),

          ListTile(
            title: Text("Shared Files"),
            trailing: Icon(Icons.folder_shared),
            subtitle: Text("Click to search user's files."),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Enter Username"),
                    content: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Of User, you wish to access files.",
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                color: Colors.grey[500]),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: _getUsernameController,
                            decoration: InputDecoration(
                              hintText: "ex. moresushant48",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    actions: [
                      FlatButton(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      FlatButton(
                        child: Text("Go"),
                        onPressed: () async {
                          await ApiMethodsImpl()
                              .getUserIdByUsername(
                                  _getUsernameController.text.trim())
                              .then((value) {
                            if (value == 0) {
                              // IF USER DOES NOT EXISTS, SHOW A TOAST.
                              Fluttertoast.showToast(
                                  msg: "No such user exists.",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.TOP,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            } else {
                              // IF USER IS FOUNG, GO TO /SHARED.
                              Fluttertoast.showToast(
                                  msg: "User Found..!",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.TOP,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SharedUserFiles(value),
                                  ));
                            }
                          });
                        },
                      )
                    ],
                  );
                },
              );
            },
          ),

          Divider(),

          // About tile.
          ListTile(
            title: Text("Account"),
            trailing: Icon(Icons.account_circle),
            subtitle: Text("View account info"),
            onTap: () => Navigator.pushReplacementNamed(context, "/account"),
          ),

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

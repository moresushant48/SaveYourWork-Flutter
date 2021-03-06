import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SaveYourWork/API/ApiMethodsImpl.dart';
import 'package:SaveYourWork/pages/SharedUserPage.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  SharedPreferences _prefs;
  bool _isAuthEnabled = false;
  bool _isLoggedIn = false;
  String email = "";
  String username = "";

  TextEditingController _getUsernameController = TextEditingController();

  bool _doesPlatformHaveBiometrics = false;

  @override
  void initState() {
    _getDataInVariables();
    super.initState();
  }

  _getDataInVariables() async {
    if (kIsWeb) {
      _doesPlatformHaveBiometrics = false;
    } else
      _doesPlatformHaveBiometrics =
          await _localAuthentication.canCheckBiometrics;

    _prefs = await SharedPreferences.getInstance();

    email = _prefs.getString("email");
    username = _prefs.getString("username");

    _isAuthEnabled = _prefs.getBool("isAuthEnabled");
    if (_isAuthEnabled == null) {
      _isAuthEnabled = false;
    }
    _isLoggedIn = _prefs.getBool("isLoggedIn");
    if (_isLoggedIn == null) {
      _isLoggedIn = false;
    }
    setState(() {});
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

          Visibility(
            visible: _isLoggedIn,
            child: ListTile(
              title: Text("My Files"),
              trailing: Icon(Icons.folder),
              subtitle: Text("Access your all files."),
              onTap: () => Navigator.pushReplacementNamed(context, "/home"),
            ),
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
          Visibility(
            visible: _isLoggedIn,
            child: ListTile(
              title: Text("Account"),
              trailing: Icon(Icons.account_circle),
              subtitle: Text("View account info"),
              onTap: () => Navigator.pushReplacementNamed(context, "/account"),
            ),
          ),

          // About tile.
          ListTile(
            title: Text("About"),
            trailing: Icon(Icons.info),
            onTap: () => Navigator.pushReplacementNamed(context, "/about"),
          ),

          Divider(),

          Visibility(
            visible: _doesPlatformHaveBiometrics,
            child: SwitchListTile(
              value: _isAuthEnabled,
              title: Text("Digital Authentication"),
              subtitle: Text("Use Additional Biometric Security"),
              onChanged: (changedValue) async {
                _localAuthentication
                    .authenticateWithBiometrics(
                        localizedReason:
                            "Verification to Enable/Disable the authentication.")
                    .then((value) async {
                  if (value) {
                    setState(() => _isAuthEnabled = changedValue);
                    var prefs = await SharedPreferences.getInstance();
                    prefs.setBool("isAuthEnabled", changedValue);
                  }
                });
              },
            ),
          ),

          // Logout Tile.
          Visibility(
            visible: _isLoggedIn,
            child: ListTile(
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
            ),
          )
        ],
      ),
    );
  }
}

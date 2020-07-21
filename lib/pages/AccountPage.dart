import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_test/API/ApiMethodsImpl.dart';
import 'package:web_test/pages/DrawerPage.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  ApiMethodsImpl _api = ApiMethodsImpl();
  int _userId;
  String _username;
  String _email;
  String _pass;

  bool _isFetchingKey = false;

  @override
  void initState() {
    _fillUserData();
    super.initState();
  }

  _fillUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt("id");
    _username = prefs.getString("username");
    _email = prefs.getString("email");
    _pass = prefs.getString("pass");
    setState(() {});
  }

  _generateSharedKey() {
    setState(() {
      _isFetchingKey = true;
    });
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Generate New Key"),
            content: Text("Do you really want to generate new Shared Key ?"),
            actions: [
              FlatButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.pop(context);
                    _isFetchingKey = false;
                    setState(() {});
                  }),
              FlatButton(
                child: Text("Yes"),
                onPressed: () async {
                  Navigator.pop(context);
                  await _api.generateSharedKey(_userId).then((value) async {
                    _pass = value;
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString("pass", value);
                    _isFetchingKey = false;
                    setState(() {});
                  });
                },
              )
            ],
          );
        });
  }

  _deleteCurrentUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Account"),
          content: Text("Are you sure about deleting your account ?"),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No"),
            ),
            FlatButton(
              onPressed: () async {
                Fluttertoast.showToast(
                    msg: "Cleaning up App..!",
                    backgroundColor: Colors.red,
                    toastLength: Toast.LENGTH_SHORT,
                    textColor: Colors.white,
                    timeInSecForIosWeb: 2,
                    gravity: ToastGravity.TOP);

                await _api.deleteUserAccount(_userId).then((value) async {
                  if (value) {
                    final prefs = await SharedPreferences.getInstance();

                    prefs.clear().then((value) {
                      if (value) {
                        prefs.setBool("isLoggedIn", false);
                        Navigator.pushNamedAndRemoveUntil(context,
                            Navigator.defaultRouteName, (route) => false);
                        Fluttertoast.showToast(
                            msg: "Thank You for using our services.",
                            backgroundColor: Colors.green,
                            toastLength: Toast.LENGTH_LONG,
                            textColor: Colors.white,
                            timeInSecForIosWeb: 2,
                            gravity: ToastGravity.TOP);
                      }
                    });
                  }
                });
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Account"),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                margin: EdgeInsets.all(12.0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 18.0),
                  width: kIsWeb ? 400.0 : MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.amber,
                        child: Text(
                          _username == null
                              ? ""
                              : _username.substring(0, 1).toUpperCase(),
                          style: TextStyle(fontSize: 24.0),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        _username ?? "",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        _email ?? "",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w100,
                            color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ),

              // SHARED KEY
              Card(
                margin: EdgeInsets.all(12.0),
                child: Container(
                  width: kIsWeb ? 400.0 : MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        child: Text(
                          "Shared Key",
                          textAlign: TextAlign.start,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.vpn_key),
                        title: Center(child: Text(_pass ?? "")),
                        trailing: Visibility(
                          visible: _isFetchingKey,
                          replacement: GestureDetector(
                            onTap: _generateSharedKey, // Regenerate the key.
                            child: Icon(
                              Icons.refresh,
                              color: Colors.green,
                            ),
                          ),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        child: Text(
                          "Note : Click on Reload Icon to re-generate the key.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // PASSWORD RESET
              Card(
                margin: EdgeInsets.all(12.0),
                child: Container(
                  width: kIsWeb ? 400.0 : MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        child: Text(
                          "Password",
                          textAlign: TextAlign.start,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.visibility_off),
                        title: Center(child: Text("********")),
                        trailing: EditPassWithModal(),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        child: Text(
                          "Note : Click on Edit Icon to modify the password.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // DELETE ACC
              Card(
                margin: EdgeInsets.all(12.0),
                child: Container(
                  width: kIsWeb ? 400.0 : MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        child: Text(
                          "Delete",
                          textAlign: TextAlign.start,
                        ),
                      ),
                      OutlineButton(
                        borderSide: BorderSide(color: Colors.red),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text("Delete My Account")
                        ]),
                        onPressed: _deleteCurrentUser,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        child: Text(
                          "Note : This cannot be undone.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditPassWithModal extends StatefulWidget {
  @override
  _EditPassWithModalState createState() => _EditPassWithModalState();
}

class _EditPassWithModalState extends State<EditPassWithModal> {
  final ApiMethodsImpl api = ApiMethodsImpl();
  String _currentPassword = "";

  @override
  void initState() {
    _setPassword();
    super.initState();
  }

  _setPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentPassword = prefs.getString("password");
  }

  @override
  Widget build(BuildContext context) {
    var _passResetKey = GlobalKey<FormState>();
    var _currentPassController = TextEditingController();
    var _newPassController = TextEditingController();
    _setPassword();
    return GestureDetector(
      child: Icon(
        Icons.edit,
        color: Colors.blue,
      ),
      onTap: () {
        showBottomSheet(
          context: context,
          elevation: 20.0,
          builder: (context) {
            return SingleChildScrollView(
              child: Container(
                width: kIsWeb ? 400.0 : MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _passResetKey,
                  autovalidate: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FlatButton(
                        child: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Enter Current Password",
                          border: OutlineInputBorder(),
                        ),
                        controller: _currentPassController,
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter Current Password";
                          } else if (value != _currentPassword) {
                            return "Current password couldn't match.";
                          }
                          return null;
                        },
                        onSaved: (newValue) async {
                          var prefs = await SharedPreferences.getInstance();
                          prefs.setString("password", newValue);
                        },
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Enter New Password",
                          border: OutlineInputBorder(),
                        ),
                        controller: _newPassController,
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            // The password is empty
                            return "Enter New Password";
                          } else if (value.length < 5 || value.length > 15) {
                            return "Min 5 & Max 15 Characters";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.0),

                      // SUBMIT
                      FlatButton(
                        onPressed: () async {
                          if (_passResetKey.currentState.validate()) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await api
                                .resetPassword(prefs.getInt("id"),
                                    _newPassController.text.toString())
                                .then((value) {
                              if (value == true) //Password Changed
                              {
                                prefs.setString("password",
                                    _newPassController.text.toString());
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg: "Password changed succefully.",
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 3,
                                    toastLength: Toast.LENGTH_LONG);
                              } else {
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg: "Couldn't reset password.",
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 3,
                                    toastLength: Toast.LENGTH_LONG);
                              }
                            });
                          }
                        },
                        child: Text("Submit"),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }, // Regenerate the key.
    );
  }
}

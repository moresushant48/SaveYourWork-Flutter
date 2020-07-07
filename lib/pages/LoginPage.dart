import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_test/API/ApiMethodsImpl.dart';
import 'package:web_test/Models/User.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ApiMethodsImpl api;
  var _isVisible = true;

  final _loginFormKey = GlobalKey<FormState>();
  String username;
  String password;
  bool _autoValidate = false;
  var _obsecureText = true;

  var txtUsernameController = TextEditingController();
  var txtPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    api = ApiMethodsImpl();
  }

  void _loadingAnimation() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void _toggle() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  String _validateUsername(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Enter Username";
    } else if (value.length <= 5) {
      return "Min 5 & Max 15 Characters";
    }
    return null;
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Enter Password";
    } else if (value.length <= 5) {
      return "Min 5 & Max 15 Characters";
    }
    return null;
  }

  _saveUserInfo(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
    prefs.setInt("id", user.getId);
    prefs.setString("email", user.getEmail);
    prefs.setString("username", user.getUsername);
    prefs.setString("pass", user.getPublicPass);
  }

  _onLogin() {
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();

      // Make login request.
      _loadingAnimation(); // load the animation, hide the button.
      api.login(username.toString(), password.toString()).then((value) {
        if (value.getUsername == username) {
          _loadingAnimation();
          _saveUserInfo(value);
          Fluttertoast.showToast(
              msg: "Login Successful.",
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.green,
              textColor: Colors.white);
          Navigator.popAndPushNamed(context, "/home");
        } else {
          _loadingAnimation();
          Fluttertoast.showToast(
              msg: "Wrong credentials.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.red,
              textColor: Colors.white);
        }
      });
    } else
      setState(() => _autoValidate = true);
  }

  @override
  void dispose() {
    txtPasswordController.dispose();
    txtUsernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _orientation = MediaQuery.of(context).orientation;
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
              child: Flex(
            direction: _orientation == Orientation.portrait
                ? Axis.vertical
                : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/login.png",
                width: kIsWeb
                    ? 400.0
                    : _orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.width - 50
                        : (MediaQuery.of(context).size.width / 2) - 50,
              ),
              Form(
                key: _loginFormKey,
                autovalidate: _autoValidate,
                child: Container(
                  width: kIsWeb
                      ? 400.0
                      : _orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.width
                          : (MediaQuery.of(context).size.width / 2),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(15)],
                        controller: txtUsernameController,
                        validator: (value) => _validateUsername(value),
                        onSaved: (newValue) => username = newValue,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.supervised_user_circle),
                            alignLabelWithHint: true,
                            labelText: "Username",
                            labelStyle: TextStyle(letterSpacing: 1.0),
                            border: InputBorder.none),
                        keyboardType: TextInputType.text,
                      ),
                      TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(15)],
                        controller: txtPasswordController,
                        validator: (value) => _validatePassword(value),
                        onSaved: (newValue) => password = newValue,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.vpn_key),
                            suffixIcon: GestureDetector(
                              child: Icon(Icons.remove_red_eye),
                              onTap: () => _toggle(),
                            ),
                            alignLabelWithHint: true,
                            labelText: "Password",
                            labelStyle: TextStyle(letterSpacing: 1.0),
                            border: InputBorder.none),
                        obscureText: _obsecureText,
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 8.0),

                      // Login Button.
                      Visibility(
                        visible: _isVisible,
                        replacement: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(),
                        ),
                        child: MaterialButton(
                          elevation: 5.0,
                          color: Colors.indigoAccent,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Text("Login"),
                          onPressed: _onLogin,
                        ),
                      ),

                      SizedBox(height: 12.0),
                      GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, "/register"),
                          child: Text(
                            "Not a member ? Register",
                          ))
                    ],
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}

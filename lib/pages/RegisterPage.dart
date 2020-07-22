import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:SaveYourWork/API/ApiMethodsImpl.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  ApiMethodsImpl api;
  var _isVisible = true;

  final _registerFormKey = GlobalKey<FormState>();
  String email;
  String username;
  String password;
  bool _autoValidate = false;
  var _obsecureText = true;

  var txtEmailController = TextEditingController();
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

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      // The form is empty
      return "Enter Email Id";
    } else if (!regex.hasMatch(value))
      return 'Not a valid Email Id';
    else
      return null;
  }

  String _validateUsername(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Enter Username";
    } else if (value.length < 5) {
      return "Min 5 & Max 15 Characters";
    }
    return null;
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Enter Password";
    } else if (value.length < 5) {
      return "Min 5 & Max 15 Characters";
    }
    return null;
  }

  _onRegister() {
    if (_registerFormKey.currentState.validate()) {
      _registerFormKey.currentState.save();

      // Make login request.
      _loadingAnimation(); // load the animation, hide the button.
      api
          .register(username.toString(), email.toString(), password.toString())
          .then((value) {
        if (value == username) {
          _loadingAnimation();
          Fluttertoast.showToast(
              msg: "Username exists already.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white);
        } else if (value == email) {
          _loadingAnimation();
          Fluttertoast.showToast(
              msg: "Email Id exists already.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white);
        } else {
          _loadingAnimation();
          Fluttertoast.showToast(
              msg: "Registration Successful.",
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.green,
              textColor: Colors.white);
          Navigator.of(context).pushNamed("/login");
        }
      });
    } else
      setState(() => _autoValidate = true);
  }

  @override
  void dispose() {
    txtPasswordController.dispose();
    txtUsernameController.dispose();
    txtEmailController.dispose();
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
                "assets/images/register.png",
                width: kIsWeb
                    ? 400.0
                    : _orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.width - 50
                        : (MediaQuery.of(context).size.width / 2) - 50,
              ),
              Form(
                key: _registerFormKey,
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
                        controller: txtEmailController,
                        validator: (value) => _validateEmail(value),
                        onSaved: (newValue) => email = newValue,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            alignLabelWithHint: true,
                            labelText: "Email Id",
                            labelStyle: TextStyle(letterSpacing: 1.0),
                            border: InputBorder.none),
                        keyboardType: TextInputType.emailAddress,
                      ),
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

                      // Register Button.
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
                          child: Text("Register"),
                          onPressed: _onRegister,
                        ),
                      ),

                      SizedBox(height: 12.0),
                      GestureDetector(
                          onTap: () => Navigator.pushNamed(context, "/login"),
                          child: Text(
                            "Already a member ? Login",
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

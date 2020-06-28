import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _obsecureText = true;

  void _toggle() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/register.png",
                width: kIsWeb ? 400.0 : MediaQuery.of(context).size.width - 50,
                semanticLabel: "Hello",
              ),
              Container(
                width: kIsWeb ? 400.0 : MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          alignLabelWithHint: true,
                          labelText: "Email Id",
                          labelStyle: TextStyle(letterSpacing: 1.0),
                          border: InputBorder.none),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.supervised_user_circle),
                          alignLabelWithHint: true,
                          labelText: "Username",
                          labelStyle: TextStyle(letterSpacing: 1.0),
                          border: InputBorder.none),
                      keyboardType: TextInputType.text,
                    ),
                    TextField(
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
                    MaterialButton(
                        elevation: 5.0,
                        color: Colors.indigoAccent,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Text("Register"),
                        onPressed: () =>
                            Navigator.pushNamed(context, "/login")),
                    SizedBox(height: 12.0),
                    GestureDetector(
                        onTap: () => Navigator.pushNamed(context, "/login"),
                        child: Text(
                          "Already a member ? Login",
                        ))
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}

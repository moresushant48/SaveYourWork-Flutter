import 'package:SaveYourWork/API/ApiMethodsImpl.dart';
import 'package:SaveYourWork/pages/SharedUserPage.dart';
import 'package:flutter/material.dart';

class UserWaitPage extends StatelessWidget {
  final ApiMethodsImpl _api = ApiMethodsImpl();
  final String _username;
  //
  UserWaitPage(this._username);

  @override
  Widget build(BuildContext context) {
    print("object");
    _api.getUserIdByUsername(this._username).then((userId) {
      print("Inside");
      Future.delayed(Duration(seconds: 4), () {
        userId != 0
            ? Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => SharedUserFiles(userId)))
            : Navigator.pushReplacementNamed(context, "/");
      });
    });
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

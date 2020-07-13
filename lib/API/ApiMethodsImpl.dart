import 'dart:convert';

import 'package:web_test/Models/User.dart';
import 'package:http/http.dart' as http;
import 'package:web_test/Globals.dart' as globals;

class ApiMethodsImpl {
  // LOGIN

  Future<User> login(String username, String password) async {
    var url = "login?username=" + username + "&password=" + password;
    final response = await http.post(globals.API_URL + url);
    return response.statusCode == 200
        ? User.fromJson(response.body)
        : throw Exception();
  }

  // Register
  Future<String> register(
      String username, String email, String password) async {
    var url = "register?email=" +
        email +
        "&username=" +
        username +
        "&password=" +
        password;
    final response = await http.post(globals.API_URL + url);
    return response.statusCode == 200 ? response.body : throw Exception();
  }

  // GET : ALL USER FILES (INT USER_ID)
  Future<dynamic> getUserFilesById(int userId) async {
    var url = "list-files/" + userId.toString();
    final response = await http.get(globals.API_URL + url);
    return response.statusCode == 200
        ? jsonDecode(response.body)
        : throw Exception();
  }

  // GET : ALL USER ID BY USERNAME
  Future<int> getUserIdByUsername(String username) async {
    var url = "user/getUserId?username=" + username;
    final response = await http.get(globals.API_URL + url);
    print(response.body);
    return response.statusCode == 200
        ? Future<int>.value(int.parse(response.body))
        : throw Exception();
  }

  // GET : ALL PUBLIC USER FILES (INT USER_ID)
  Future<dynamic> getPublicData(int userId) async {
    var url = "list-files/public/" + userId.toString();
    final response = await http.get(globals.API_URL + url);
    return response.statusCode == 200
        ? jsonDecode(response.body)
        : throw Exception();
  }

  // GET : ALL SHARED USER FILES (INT USER_ID)
  Future<dynamic> getSharedData(int userId) async {
    var url = "list-files/shared/" + userId.toString();
    final response = await http.get(globals.API_URL + url);
    return response.statusCode == 200
        ? jsonDecode(response.body)
        : throw Exception();
  }

  Future<String> getSharedKey(int userId) async {
    var url = "user/account/getKey/" + userId.toString();
    final response = await http.get(globals.API_URL + url);
    return response.statusCode == 200 ? response.body : throw Exception();
  }
}

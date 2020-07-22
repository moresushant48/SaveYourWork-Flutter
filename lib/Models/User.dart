import 'dart:convert';

import 'package:SaveYourWork/Models/Role.dart';

class User {
  int id;

  String email;

  String username;

  String password;

  String publicPass;

  Role role;

  User({
    this.id,
    this.email,
    this.username,
    this.password,
    this.publicPass,
    this.role,
  });

  int get getId => id;

  set setId(int id) => this.id = id;

  String get getEmail => email;

  set setEmail(String email) => this.email = email;

  String get getUsername => username;

  set setUsername(String username) => this.username = username;

  String get getPassword => password;

  set setPassword(String password) => this.password = password;

  String get getPublicPass => publicPass;

  set setPublicPass(String publicPass) => this.publicPass = publicPass;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'password': password,
      'publicPass': publicPass,
      'role': role?.toMap(),
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      id: map['id'],
      email: map['email'],
      username: map['username'],
      password: map['password'],
      publicPass: map['publicPass'],
      role: Role.fromMap(map['role']),
    );
  }

  String toJson() => json.encode(toMap());

  static User fromJson(String source) => fromMap(json.decode(source));
}

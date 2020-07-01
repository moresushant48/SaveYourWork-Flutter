import 'dart:convert';

import 'package:web_test/Models/User.dart';

class Role {
  int id;

  String role;

  String desc;

  Role({
    this.id,
    this.role,
    this.desc,
  });

  List<User> users = List<User>();

  int get getId => id;

  set setId(int id) => this.id = id;

  String get getRole => role;

  set setRole(String role) => this.role = role;

  String get getDesc => desc;

  set setDesc(String desc) => this.desc = desc;

  List get getList => List<User>();

  set setList(List List<User>()) => this.users = List<User>();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role': role,
      'desc': desc,
    };
  }

  static Role fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Role(
      id: map['id'],
      role: map['role'],
      desc: map['desc'],
    );
  }

  String toJson() => json.encode(toMap());

  static Role fromJson(String source) => fromMap(json.decode(source));
}

// To parse this JSON data, do
//
//     final usersResModel = usersResModelFromJson(jsonString);

import 'dart:convert';

import 'package:streax/model/user.dart';

UsersResModel usersResModelFromJson(String str) =>
    UsersResModel.fromJson(json.decode(str));

String usersResModelToJson(UsersResModel data) => json.encode(data.toJson());

class UsersResModel {
  final bool success;
  final String message;
  final List<User>? users;

  UsersResModel({
    required this.success,
    required this.message,
    this.users,
  });

  factory UsersResModel.fromJson(Map<String, dynamic> json) => UsersResModel(
        success: json["success"],
        message: json["message"],
        users: json["data"] == null
            ? []
            : List<User>.from(json["data"]!.map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data":
            users == null ? [] : List<User>.from(users!.map((x) => x.toJson())),
      };
}

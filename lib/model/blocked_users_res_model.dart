// To parse this JSON data, do
//
//     final blockedUsersResModel = blockedUsersResModelFromJson(jsonString);

import 'dart:convert';

import 'package:streax/model/user.dart';

BlockedUsersResModel blockedUsersResModelFromJson(String str) =>
    BlockedUsersResModel.fromJson(json.decode(str));

String blockedUsersResModelToJson(BlockedUsersResModel data) =>
    json.encode(data.toJson());

class BlockedUsersResModel {
  final bool success;
  final String message;
  final List<User>? users;

  BlockedUsersResModel({
    required this.success,
    required this.message,
    this.users,
  });

  factory BlockedUsersResModel.fromJson(Map<String, dynamic> json) =>
      BlockedUsersResModel(
        success: json["success"],
        message: json["message"],
        users: json["data"] == null
            ? []
            : List<User>.from(json["data"]!.map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
      };
}


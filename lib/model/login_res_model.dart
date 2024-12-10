// To parse this JSON data, do
//
//     final loginResModel = loginResModelFromJson(jsonString);

import 'dart:convert';

import 'package:streax/model/user.dart';

LoginResModel loginResModelFromJson(String str) => LoginResModel.fromJson(json.decode(str));

String loginResModelToJson(LoginResModel data) => json.encode(data.toJson());

class LoginResModel {
  final bool success;
  final String message;
  final User? user;

  LoginResModel({
   required this.success,
   required this.message,
    this.user,
  });

  factory LoginResModel.fromJson(Map<String, dynamic> json) => LoginResModel(
    success: json["success"],
    message: json["message"],
    user: json["data"] == null ? null : User.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": user?.toJson(),
  };
}


// To parse this JSON data, do
//
//     final profileResModel = profileResModelFromJson(jsonString);

import 'dart:convert';

import 'package:streax/model/user.dart';

ProfileResModel profileResModelFromJson(String str) => ProfileResModel.fromJson(json.decode(str));

String profileResModelToJson(ProfileResModel data) => json.encode(data.toJson());

class ProfileResModel {
  final bool success;
  final String message;
  final User? user;

  ProfileResModel({
   required this.success,
   required this.message,
    this.user,
  });

  factory ProfileResModel.fromJson(Map<String, dynamic> json) => ProfileResModel(
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


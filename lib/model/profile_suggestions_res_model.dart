// To parse this JSON data, do
//
//     final profileSuggestionsResModel = profileSuggestionsResModelFromJson(jsonString);

import 'dart:convert';

import 'package:streax/model/user.dart';

ProfileSuggestionsResModel profileSuggestionsResModelFromJson(String str) => ProfileSuggestionsResModel.fromJson(json.decode(str));

String profileSuggestionsResModelToJson(ProfileSuggestionsResModel data) => json.encode(data.toJson());

class ProfileSuggestionsResModel {
  final bool success;
  final String message;
  final List<User>? users;

  ProfileSuggestionsResModel({
   required this.success,
   required this.message,
    this.users,
  });

  factory ProfileSuggestionsResModel.fromJson(Map<String, dynamic> json) => ProfileSuggestionsResModel(
    success: json["success"],
    message: json["message"],
    users: json["data"] == null ? [] : List<User>.from(json["data"]!.map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": users == null ? [] : List<User>.from(users!.map((x) => x.toJson())),
  };
}


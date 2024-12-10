// To parse this JSON data, do
//
//     final storiesResModel = storiesResModelFromJson(jsonString);

import 'dart:convert';
import 'package:streax/model/user.dart';

StoriesResModel storiesResModelFromJson(String str) => StoriesResModel.fromJson(json.decode(str));

String storiesResModelToJson(StoriesResModel data) => json.encode(data.toJson());

class StoriesResModel {
  final bool success;
  final String message;
  final List<User>? stories;

  StoriesResModel({
   required this.success,
    required this.message,
    this.stories,
  });

  factory StoriesResModel.fromJson(Map<String, dynamic> json) => StoriesResModel(
    success: json["success"],
    message: json["message"],
    stories: json["data"] == null ? [] : List<User>.from(json["data"]!.map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": stories == null ? [] : List<dynamic>.from(stories!.map((x) => x.toJson())),
  };
}



// To parse this JSON data, do
//
//     final myStoriesResModel = myStoriesResModelFromJson(jsonString);

import 'dart:convert';

import 'package:streax/model/story/story.dart';

MyStoriesResModel myStoriesResModelFromJson(String str) => MyStoriesResModel.fromJson(json.decode(str));

String myStoriesResModelToJson(MyStoriesResModel data) => json.encode(data.toJson());

class MyStoriesResModel {
  final bool success;
  final String message;
  final List<Story>? stories;

  MyStoriesResModel({
   required this.success,
  required  this.message,
    this.stories,
  });

  factory MyStoriesResModel.fromJson(Map<String, dynamic> json) => MyStoriesResModel(
    success: json["success"],
    message: json["message"],
    stories: json["data"] == null ? [] : List<Story>.from(json["data"]!.map((x) => Story.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": stories == null ? [] : List<dynamic>.from(stories!.map((x) => x.toJson())),
  };
}


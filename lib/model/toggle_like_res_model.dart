// To parse this JSON data, do
//
//     final toggleLikeResModel = toggleLikeResModelFromJson(jsonString);

import 'dart:convert';

ToggleLikeResModel toggleLikeResModelFromJson(String str) => ToggleLikeResModel.fromJson(json.decode(str));

String toggleLikeResModelToJson(ToggleLikeResModel data) => json.encode(data.toJson());

class ToggleLikeResModel {
  final bool success;
  final String message;
  final Data? data;

  ToggleLikeResModel({
   required this.success,
   required this.message,
    this.data,
  });

  factory ToggleLikeResModel.fromJson(Map<String, dynamic> json) => ToggleLikeResModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final int? isLiked;

  Data({
    this.isLiked,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    isLiked: json["isLiked"],
  );

  Map<String, dynamic> toJson() => {
    "isLiked": isLiked,
  };
}

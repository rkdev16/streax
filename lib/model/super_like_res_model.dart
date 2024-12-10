// To parse this JSON data, do
//
//     final superLikeResModel = superLikeResModelFromJson(jsonString);

import 'dart:convert';

SuperLikeResModel superLikeResModelFromJson(String str) => SuperLikeResModel.fromJson(json.decode(str));

String superLikeResModelToJson(SuperLikeResModel data) => json.encode(data.toJson());

class SuperLikeResModel {
  final bool? success;
  final String? message;
  final Data? data;

  SuperLikeResModel({
    this.success,
    this.message,
    this.data,
  });

  factory SuperLikeResModel.fromJson(Map<String, dynamic> json) => SuperLikeResModel(
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
  final int? superLike;

  Data({
    this.superLike,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    superLike: json["superLike"],
  );

  Map<String, dynamic> toJson() => {
    "superLike": superLike,
  };
}

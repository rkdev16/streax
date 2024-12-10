// To parse this JSON data, do
//
//     final baseResModel = baseResModelFromJson(jsonString);

import 'dart:convert';

BaseResModel baseResModelFromJson(String str) => BaseResModel.fromJson(json.decode(str));

String baseResModelToJson(BaseResModel data) => json.encode(data.toJson());

class BaseResModel {
  final bool success;
  final String message;

  BaseResModel({
    required this.success,
    required this.message,
  });

  factory BaseResModel.fromJson(Map<String, dynamic> json) => BaseResModel(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}

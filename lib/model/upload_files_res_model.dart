// To parse this JSON data, do
//
//     final uploadFilesResModel = uploadFilesResModelFromJson(jsonString);

import 'dart:convert';

UploadFilesResModel uploadFilesResModelFromJson(String str) => UploadFilesResModel.fromJson(json.decode(str));

String uploadFilesResModelToJson(UploadFilesResModel data) => json.encode(data.toJson());

class UploadFilesResModel {
  bool success;
  String message;
  List<ploadFilesData>? data;

  UploadFilesResModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory UploadFilesResModel.fromJson(Map<String, dynamic> json) => UploadFilesResModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<ploadFilesData>.from(json["data"]!.map((x) => ploadFilesData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ploadFilesData {
  String? name;
  String? originalName;

  ploadFilesData({
    this.name,
    this.originalName,
  });

  factory ploadFilesData.fromJson(Map<String, dynamic> json) => ploadFilesData(
    name: json["name"],
    originalName: json["originalName"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "originalName": originalName,
  };
}

// To parse this JSON data, do
//
//     final verifyEmailResModel = verifyEmailResModelFromJson(jsonString);

import 'dart:convert';

VerifyEmailResModel verifyEmailResModelFromJson(String str) => VerifyEmailResModel.fromJson(json.decode(str));

String verifyEmailResModelToJson(VerifyEmailResModel data) => json.encode(data.toJson());

class VerifyEmailResModel {
  final bool success;
  final String message;
  final Data? data;

  VerifyEmailResModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory VerifyEmailResModel.fromJson(Map<String, dynamic> json) => VerifyEmailResModel(
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
  final String? email;
  final String? otp;

  Data({
    this.email,
    this.otp,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    email: json["email"],
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "otp": otp,
  };
}

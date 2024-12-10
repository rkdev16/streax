// To parse this JSON data, do
//
//     final signupResModel = signupResModelFromJson(jsonString);

import 'dart:convert';

SignupResModel signupResModelFromJson(String str) => SignupResModel.fromJson(json.decode(str));

String signupResModelToJson(SignupResModel data) => json.encode(data.toJson());

class SignupResModel {
  final bool success;
  final String message;
  final SignupData? signupData;

  SignupResModel({
   required this.success,
    required this.message,
    this.signupData,
  });

  factory SignupResModel.fromJson(Map<String, dynamic> json) => SignupResModel(
    success: json["success"],
    message: json["message"],
    signupData: json["data"] == null ? null : SignupData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": signupData?.toJson(),
  };
}

class SignupData {
  final String? token;

  SignupData({
    this.token,
  });

  factory SignupData.fromJson(Map<String, dynamic> json) => SignupData(
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
  };
}

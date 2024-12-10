// To parse this JSON data, do
//
//     final verifyMobileResModel = verifyMobileResModelFromJson(jsonString);

import 'dart:convert';

VerifyMobileResModel verifyMobileResModelFromJson(String str) => VerifyMobileResModel.fromJson(json.decode(str));

String verifyMobileResModelToJson(VerifyMobileResModel data) => json.encode(data.toJson());

class VerifyMobileResModel {
  final bool success;
  final String message;
  final Data? data;

  VerifyMobileResModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory VerifyMobileResModel.fromJson(Map<String, dynamic> json) => VerifyMobileResModel(
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
  final String? countryCode;
  final String? mobile;
  final String? otp;

  Data({
    this.countryCode,
    this.mobile,
    this.otp,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    countryCode: json["countryCode"],
    mobile: json["mobile"],
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "countryCode": countryCode,
    "mobile": mobile,
    "otp": otp,
  };
}

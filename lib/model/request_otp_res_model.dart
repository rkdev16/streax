// To parse this JSON data, do
//
//     final requestOtpResModel = requestOtpResModelFromJson(jsonString);

import 'dart:convert';

RequestOtpResModel requestOtpResModelFromJson(String str) => RequestOtpResModel.fromJson(json.decode(str));

String requestOtpResModelToJson(RequestOtpResModel data) => json.encode(data.toJson());

class RequestOtpResModel {
  final bool success;
  final String message;
  final OtpData? otpData;

  RequestOtpResModel({
   required this.success,
   required this.message,
    this.otpData,
  });

  factory RequestOtpResModel.fromJson(Map<String, dynamic> json) => RequestOtpResModel(
    success: json["success"],
    message: json["message"],
    otpData: json["data"] == null ? null : OtpData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": otpData?.toJson(),
  };
}

class OtpData {
  final String? countryCode;
  final String? mobile;
  final String? email;
  final String? otp;

  OtpData({
    this.countryCode,
    this.mobile,
    this.email,
    this.otp,
  });

  factory OtpData.fromJson(Map<String, dynamic> json) => OtpData(
    countryCode: json["countryCode"],
    mobile: json["mobile"],
    email: json["email"],
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "countryCode": countryCode,
    "mobile": mobile,
    "email": email,
    "otp": otp,
  };
}

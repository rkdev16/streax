
// To parse this JSON data, do
//
//     final deleteAccountOtpResModel = deleteAccountOtpResModelFromJson(jsonString);

import 'dart:convert';

DeleteAccountOtpResModel deleteAccountOtpResModelFromJson(String str) => DeleteAccountOtpResModel.fromJson(json.decode(str));

String deleteAccountOtpResModelToJson(DeleteAccountOtpResModel data) => json.encode(data.toJson());

class DeleteAccountOtpResModel {
  final bool success;
  final String message;
  final String? otp;

  DeleteAccountOtpResModel({
   required this.success,
   required this.message,
    this.otp,
  });

  factory DeleteAccountOtpResModel.fromJson(Map<String, dynamic> json) => DeleteAccountOtpResModel(
    success: json["success"],
    message: json["message"],
    otp: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": otp,
  };
}

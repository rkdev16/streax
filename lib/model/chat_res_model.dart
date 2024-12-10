// To parse this JSON data, do
//
//     final chatResModel = chatResModelFromJson(jsonString);

import 'dart:convert';

import 'package:streax/model/chat_dialogs_res_model.dart';

ChatResModel chatResModelFromJson(String str) => ChatResModel.fromJson(json.decode(str));

String chatResModelToJson(ChatResModel data) => json.encode(data.toJson());

class ChatResModel {
  final bool success;
  final String message;
  final List<Message>? messages;

  ChatResModel({
   required this.success,
   required this.message,
    this.messages,
  });

  factory ChatResModel.fromJson(Map<String, dynamic> json) => ChatResModel(
    success: json["success"],
    message: json["message"],
    messages: json["data"] == null ? [] : List<Message>.from(json["data"]!.map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": messages == null ? [] : List<dynamic>.from(messages!.map((x) => x.toJson())),
  };
}


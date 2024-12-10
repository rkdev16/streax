// To parse this JSON data, do
//
//     final messageSentResModel = messageSentResModelFromJson(jsonString);

import 'dart:convert';

import 'package:streax/model/chat_dialogs_res_model.dart';

MessageSentResModel messageSentResModelFromJson(String str) => MessageSentResModel.fromJson(json.decode(str));

String messageSentResModelToJson(MessageSentResModel data) => json.encode(data.toJson());

class MessageSentResModel {
  final bool success;
  final String message;
  final Message? chatMessage;

  MessageSentResModel({
    required this.success,
    required this.message,
    this.chatMessage,
  });

  factory MessageSentResModel.fromJson(Map<String, dynamic> json) =>
      MessageSentResModel(
        success: json["success"],
        message: json["message"],
        chatMessage: json["data"] == null ? null : Message.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "success": success,
        "message": message,
        "data": chatMessage?.toJson(),
      };
}

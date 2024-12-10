// To parse this JSON data, do
//
//     final notificationCountResModel = notificationCountResModelFromJson(jsonString);

import 'dart:convert';

NotificationCountResModel notificationCountResModelFromJson(String str) => NotificationCountResModel.fromJson(json.decode(str));

String notificationCountResModelToJson(NotificationCountResModel data) => json.encode(data.toJson());

class NotificationCountResModel {
  bool? success;
  String? message;
  NotificationCount? data;

  NotificationCountResModel({
    this.success,
    this.message,
    this.data,
  });

  factory NotificationCountResModel.fromJson(Map<String, dynamic> json) => NotificationCountResModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : NotificationCount.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class NotificationCount {
  int? notificationCount;

  NotificationCount({
    this.notificationCount,
  });

  factory NotificationCount.fromJson(Map<String, dynamic> json) => NotificationCount(
    notificationCount: json["notificationCount"],
  );

  Map<String, dynamic> toJson() => {
    "notificationCount": notificationCount,
  };
}

// To parse this JSON data, do
//
//     final messageCountResModel = messageCountResModelFromJson(jsonString);

MessageCountResModel messageCountResModelFromJson(String str) => MessageCountResModel.fromJson(json.decode(str));

String messageCountResModelToJson(MessageCountResModel data) => json.encode(data.toJson());

class MessageCountResModel {
  bool? success;
  String? message;
  MessageCount? data;

  MessageCountResModel({
    this.success,
    this.message,
    this.data,
  });

  factory MessageCountResModel.fromJson(Map<String, dynamic> json) => MessageCountResModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : MessageCount.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class MessageCount {
  int? totalUnreadMessages;
  int? requestCount;

  MessageCount({
    this.totalUnreadMessages,
    this.requestCount,
  });

  factory MessageCount.fromJson(Map<String, dynamic> json) => MessageCount(
    totalUnreadMessages: json["totalUnreadMessages"],
    requestCount: json["requestCount"],
  );

  Map<String, dynamic> toJson() => {
    "totalUnreadMessages": totalUnreadMessages,
    "requestCount": requestCount,
  };
}


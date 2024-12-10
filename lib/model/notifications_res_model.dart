// To parse this JSON data, do
//
//     final notificationsResModel = notificationsResModelFromJson(jsonString);

import 'dart:convert';

NotificationsResModel notificationsResModelFromJson(String str) => NotificationsResModel.fromJson(json.decode(str));

String notificationsResModelToJson(NotificationsResModel data) => json.encode(data.toJson());

class NotificationsResModel {
  final bool success;
  final String message;
  final List<AppNotification>? notifications;

  NotificationsResModel({
   required this.success,
   required this.message,
    this.notifications,
  });

  factory NotificationsResModel.fromJson(Map<String, dynamic> json) => NotificationsResModel(
    success: json["success"],
    message: json["message"],
    notifications: json["data"] == null ? [] : List<AppNotification>.from(json["data"]!.map((x) => AppNotification.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toJson())),
  };
}

class AppNotification {
  final String? id;
  final String? userId;
  final String? title;
  final String? image;
  final String? type;
  final bool? isRead;
  final DateTime? time;
  final int? v;

  AppNotification({
    this.id,
    this.userId,
    this.title,
    this.image,
    this.type,
    this.isRead,
    this.time,
    this.v,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    id: json["_id"],
    userId: json["userId"],
    title: json["title"],
    image: json["image"],
    type: json["type"],
    isRead: json["isRead"],
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "title": title,
    "image": image,
    "type": type,
    "isRead": isRead,
    "time": time?.toIso8601String(),
    "__v": v,
  };
}

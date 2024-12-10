// To parse this JSON data, do
//
//     final chatDialogsResModel = chatDialogsResModelFromJson(jsonString);

import 'dart:convert';

import 'package:streax/consts/enums.dart';
import 'package:streax/model/story/story.dart';
import 'package:streax/model/user.dart';

ChatDialogsResModel chatDialogsResModelFromJson(String str) =>
    ChatDialogsResModel.fromJson(json.decode(str));

String chatDialogsResModelToJson(ChatDialogsResModel data) =>
    json.encode(data.toJson());

class ChatDialogsResModel {
  final bool success;
  final String message;
  final List<ChatDialog>? chatDialogs;

  ChatDialogsResModel({
    required this.success,
    required this.message,
    this.chatDialogs,
  });

  factory ChatDialogsResModel.fromJson(Map<String, dynamic> json) =>
      ChatDialogsResModel(
        success: json["success"],
        message: json["message"],
        chatDialogs: json["data"] == null
            ? []
            : List<ChatDialog>.from(
                json["data"]!.map((x) => ChatDialog.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": chatDialogs == null
            ? []
            : List<dynamic>.from(chatDialogs!.map((x) => x.toJson())),
      };
}

class ChatDialog {
  final String? id;
  final String? fullName;
  final String? userName;
  final String? role;
  final String? roomId;
  final String? image;
  final Message? chatMessage;
  final int? unreadMessage;
  final int? streak;
  int? iLiked;
  int? likedMe;
  bool? isOnline;
  bool? streakReminder;

  ChatDialog(
      {this.id,
      this.fullName,
      this.userName,
      this.roomId,
      this.role,
      this.image,
      this.chatMessage,
      this.unreadMessage,
      this.streak,
      this.iLiked,
      this.isOnline,
      this.streakReminder,
      this.likedMe});

  factory ChatDialog.fromJson(Map<String, dynamic> json) => ChatDialog(
        id: json["_id"],
        fullName: json["fullName"],
        userName: json["userName"],
        roomId: json["roomId"],
        role: json["role"],
        image: json["image"],
        chatMessage:
            json["chat"] == null ? null : Message.fromJson(json["chat"]),
        unreadMessage: json["unreadMessage"],
        streak: json["streak"],
        iLiked: json['iLiked'],
        isOnline: json['isOnline'],
        streakReminder: json['streakReminder'],
        likedMe: json['likedMe'],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "userName": userName,
        "roomId": roomId,
        "role": role,
        "image": image,
        "chat": chatMessage?.toJson(),
        "unreadMessage": unreadMessage,
        "streak": streak,
        "iLiked": iLiked,
        "isOnline": isOnline,
        "streakReminder": streakReminder,
        "likedMe": likedMe,
      };
}

var messageTypeValues = EnumValues({
  'IMAGE': MessageType.image,
  'VIDEO': MessageType.video,
  'AUDIO': MessageType.audio,
  'LOCATION': MessageType.location,
  'TEXT': MessageType.text,
  'HANGOUT_REQUEST': MessageType.hangoutRequest,
  'STORY': MessageType.story,
});

class Message {
  final String? id;
  final String? room;
  final User? user;
  final String? message;
  MessageType? type;
  final String? mediaUrl;
  final String? thumbnail;
  final bool? isSeen;
  bool? isSeenStatus;
  final DateTime? time;
  final int? v;
  final List<String>? deletedBy;
  final Story? story;
  final String? response;
  final Hangout? hangout;
  bool? isMediaViewed;
  final bool? camera;
  final String? key;

  Message(
      {this.id,
      this.room,
      this.user,
      this.message,
      this.type,
      this.mediaUrl,
      this.thumbnail,
      this.isSeen,
      this.isSeenStatus = false,
      this.time,
      this.v,
      this.deletedBy,
      this.story,
      this.response,
      this.hangout,
      this.isMediaViewed,
      this.key,
      this.camera});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["_id"],
        room: json["room"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        message: json["message"],
        type: messageTypeValues.map[json["type"]],
        mediaUrl: json["mediaUrl"],
        thumbnail: json["thumbnail"],
        isSeen: json["isSeen"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
        v: json["__v"],
        deletedBy: json["deletedBy"] == null
            ? []
            : List<String>.from(json["deletedBy"]!.map((x) => x)),
        story: json["story"] == null ? null : Story.fromJson(json["story"]),
        hangout:
            json["hangout"] == null ? null : Hangout.fromJson(json["hangout"]),
        response: json["response"],
        isMediaViewed: json["isMediaViewed"],
        camera: json["camera"],
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "room": room,
        "user": user?.toJson(),
        "message": message,
        "thumbnail": thumbnail,
        "type": messageTypeValues.reverse[type],
        "mediaUrl": mediaUrl,
        "isSeen": isSeen,
        "time": time?.toIso8601String(),
        "__v": v,
        "deletedBy": deletedBy == null
            ? []
            : List<dynamic>.from(deletedBy!.map((x) => x)),
        "story": story?.toJson(),
        "hangout": hangout?.toJson(),
        "response": response,
        "isMediaViewed": isMediaViewed,
        "camera": camera,
        "key": key,
      };
}

class Hangout {
  final String? id;
  final String? location;
  final String? place;
  final String? message;
  final DateTime? time;
  final dynamic latitude;
  final dynamic longitude;
  final DateTime? date;
  final String? comment;

  Hangout(
      {this.id,
      this.location,
      this.place,
      this.message,
      this.time,
      this.latitude,
      this.longitude,
      this.date,
      this.comment});

  factory Hangout.fromJson(Map<String, dynamic> json) => Hangout(
        id: json["_id"],
        location: json["location"],
        place: json["place"],
        message: json["message"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
        latitude: json["latitude"],
        longitude: json["longitude"],
        comment: json["comment"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "location": location,
        "place": place,
        "message": message,
        "time": time?.toIso8601String(),
        "latitude": latitude,
        "longitude": longitude,
        "comment": comment,
        "date": date?.toIso8601String(),
      };
}

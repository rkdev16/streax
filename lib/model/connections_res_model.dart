// To parse this JSON data, do
//
//     final connectionsResModel = connectionsResModelFromJson(jsonString);

import 'dart:convert';

import 'package:streax/model/user.dart';


ConnectionsResModel connectionsResModelFromJson(String str) => ConnectionsResModel.fromJson(json.decode(str));

String connectionsResModelToJson(ConnectionsResModel data) => json.encode(data.toJson());

class ConnectionsResModel {
  final bool success;
  final String message;
  final ConnectionsData? connectionsData;

  ConnectionsResModel({
   required this.success,
   required this.message,
    this.connectionsData,
  });

  factory ConnectionsResModel.fromJson(Map<String, dynamic> json) => ConnectionsResModel(
    success: json["success"],
    message: json["message"],
    connectionsData: json["data"] == null ? null : ConnectionsData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": connectionsData?.toJson(),
  };
}

class ConnectionsData {
  final List<User>? mutual;
  final List<User>? likedMe;
  final List<User>? iLiked;

  ConnectionsData({
    this.mutual,
    this.likedMe,
    this.iLiked,
  });

  factory ConnectionsData.fromJson(Map<String, dynamic> json) => ConnectionsData(
    mutual: json["mutual"] == null ? [] : List<User>.from(json["mutual"]!.map((x) => User.fromJson(x))),
    likedMe: json["likedMe"] == null ? [] : List<User>.from(json["likedMe"]!.map((x) => User.fromJson(x))),
    iLiked: json["iLiked"] == null ? [] : List<User>.from(json["iLiked"]!.map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "mutual": mutual == null ? [] : List<User>.from(mutual!.map((x) => x.toJson())),
    "likedMe": likedMe == null ? [] : List<User>.from(likedMe!.map((x) => x.toJson())),
    "iLiked": iLiked == null ? [] : List<User>.from(iLiked!.map((x) => x.toJson())),
  };
}



// To parse this JSON data, do
//
//     final hangoutRequestResModel = hangoutRequestResModelFromJson(jsonString);

import 'dart:convert';

HangoutRequestResModel hangoutRequestResModelFromJson(String str) => HangoutRequestResModel.fromJson(json.decode(str));

String hangoutRequestResModelToJson(HangoutRequestResModel data) => json.encode(data.toJson());

class HangoutRequestResModel {
  final bool success;
  final String message;
  final HangoutRequest? hangoutRequest;

  HangoutRequestResModel({
   required this.success,
   required this.message,
    this.hangoutRequest,
  });

  factory HangoutRequestResModel.fromJson(Map<String, dynamic> json) => HangoutRequestResModel(
    success: json["success"],
    message: json["message"],
    hangoutRequest: json["data"] == null ? null : HangoutRequest.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": hangoutRequest?.toJson(),
  };
}

class HangoutRequest {
  final String? id;
  final bool? isDeleted;
  final String? user;
  final String? hangoutRequest;
  final String? location;
  final String? place;
  final String? message;
  final DateTime? time;
  final int? v;
  final double? latitude;
  final double? longitude;
  final DateTime? date;

  HangoutRequest({
    this.id,
    this.isDeleted,
    this.user,
    this.hangoutRequest,
    this.location,
    this.place,
    this.message,
    this.time,
    this.v,
    this.latitude,
    this.longitude,
    this.date,
  });

  factory HangoutRequest.fromJson(Map<String, dynamic> json) => HangoutRequest(
    id: json["_id"],
    isDeleted: json["isDeleted"],
    user: json["user"],
    hangoutRequest: json["hangoutRequest"],
    location: json["location"],
    place: json["place"],
    message: json["message"],
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    v: json["__v"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "isDeleted": isDeleted,
    "user": user,
    "hangoutRequest": hangoutRequest,
    "location": location,
    "place": place,
    "message": message,
    "time": time?.toIso8601String(),
    "__v": v,
    "latitude": latitude,
    "longitude": longitude,
    "date": date?.toIso8601String(),
  };
}

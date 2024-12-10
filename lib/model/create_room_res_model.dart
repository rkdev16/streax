// To parse this JSON data, do
//
//     final createRoomResModel = createRoomResModelFromJson(jsonString);

import 'dart:convert';

CreateRoomResModel createRoomResModelFromJson(String str) =>
    CreateRoomResModel.fromJson(json.decode(str));

String createRoomResModelToJson(CreateRoomResModel data) =>
    json.encode(data.toJson());

class CreateRoomResModel {
  final bool success;
  final String message;
  final RoomData? roomData;

  CreateRoomResModel({
    required this.success,
    required this.message,
    this.roomData,
  });

  factory CreateRoomResModel.fromJson(Map<String, dynamic> json) =>
      CreateRoomResModel(
        success: json["success"],
        message: json["message"],
        roomData: json["data"] == null ? null : RoomData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": roomData?.toJson(),
      };
}

class RoomData {
  final String? id;

  RoomData({
    this.id,
  });

  factory RoomData.fromJson(Map<String, dynamic> json) => RoomData(
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
      };
}

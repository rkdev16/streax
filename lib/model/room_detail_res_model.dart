// To parse this JSON data, do
//
//     final roomDetailResModel = roomDetailResModelFromJson(jsonString);

import 'dart:convert';

import 'package:streax/model/chat_dialogs_res_model.dart';

RoomDetailResModel roomDetailResModelFromJson(String str) => RoomDetailResModel.fromJson(json.decode(str));

String roomDetailResModelToJson(RoomDetailResModel data) => json.encode(data.toJson());

class RoomDetailResModel {
  final bool success;
  final String message;
  final ChatDialog? dialog;

  RoomDetailResModel({
   required this.success,
   required this.message,
    this.dialog,
  });

  factory RoomDetailResModel.fromJson(Map<String, dynamic> json) => RoomDetailResModel(
    success: json["success"],
    message: json["message"],
    dialog: json["data"] == null ? null : ChatDialog.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": dialog?.toJson(),
  };
}



//
// class RoomDetail {
//   final String? id;
//   final String? fullName;
//   final String? userName;
//   final String? image;
//
//   RoomDetail({
//     this.id,
//     this.fullName,
//     this.userName,
//     this.image
//   });
//
//   factory RoomDetail.fromJson(Map<String, dynamic> json) => RoomDetail(
//     id: json["_id"],
//     fullName: json["fullName"],
//     userName: json["userName"],
//     image: json["image"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "fullName": fullName,
//     "userName": userName,
//     "image": image,
//   };
// }


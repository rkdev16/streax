// To parse this JSON data, do
//
//     final oneTimePurchasesResModel = oneTimePurchasesResModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/model/subscription_plans_res_model.dart';

OneTimePurchasesResModel oneTimePurchasesResModelFromJson(String str) =>
    OneTimePurchasesResModel.fromJson(json.decode(str));

String oneTimePurchasesResModelToJson(OneTimePurchasesResModel data) =>
    json.encode(data.toJson());

class OneTimePurchasesResModel {
  final bool success;
  final String message;
  final List<OneTimePlansData>? oneTimePlansData;

  OneTimePurchasesResModel({
    required this.success,
    required this.message,
    this.oneTimePlansData,
  });

  factory OneTimePurchasesResModel.fromJson(Map<String, dynamic> json) =>
      OneTimePurchasesResModel(
        success: json["success"],
        message: json["message"],
        oneTimePlansData: json["data"] == null
            ? []
            : List<OneTimePlansData>.from(
                json["data"]!.map((x) => OneTimePlansData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": oneTimePlansData == null
            ? []
            : List<dynamic>.from(oneTimePlansData!.map((x) => x.toJson())),
      };
}

var oneTimePlanTypeValues = EnumValues({
  "DATE_REQUEST": OneTimePurchaseType.dateRequest,
  "CRUSH": OneTimePurchaseType.crush,
  "TRAVEL_MODE": OneTimePurchaseType.travelMode,
  "INSTANT_CHAT": OneTimePurchaseType.instantChat,
  "CENTER_STAGE": OneTimePurchaseType.centerStage,
});

class OneTimePlansData {
  final OneTimePurchaseType? id;
  final List<OneTimePlan>? records;

  OneTimePlansData({
    this.id,
    this.records,
  });

  factory OneTimePlansData.fromJson(Map<String, dynamic> json) =>
      OneTimePlansData(
        id: oneTimePlanTypeValues.map[json["_id"]],
        records: json["records"] == null
            ? []
            : List<OneTimePlan>.from(
                json["records"]!.map((x) => OneTimePlan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": oneTimePlanTypeValues.reverse[id],
        "records": records == null
            ? []
            : List<dynamic>.from(records!.map((x) => x.toJson())),
      };
}

class OneTimePlan extends InAppPlan {
  final String? id;
  final String? name;
  final String? description;
  final int? quantity;
  final double? price;
  final String? productType;
  final String? iosProductId;
  final String? androidProductId;
  final bool? isDeleted;
  final DateTime? sortOrder;
  final DateTime? time;
  final int? v;
  final int? savingBy;
  final String? promotionalTag;
  final String? image;
  RxBool loading = false.obs;

  OneTimePlan({
    this.id,
    this.name,
    this.description,
    this.quantity,
    this.price,
    this.productType,
    this.iosProductId,
    this.androidProductId,
    this.isDeleted,
    this.sortOrder,
    this.time,
    this.v,
    this.savingBy,
    this.promotionalTag,
    this.image
  });

  factory OneTimePlan.fromJson(Map<String, dynamic> json) => OneTimePlan(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
        productType: json["productType"],
        iosProductId: json["iosProductId"],
        androidProductId: json["androidProductId"],
        isDeleted: json["isDeleted"],
        sortOrder: json["sortOrder"] == null
            ? null
            : DateTime.parse(json["sortOrder"]),
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
        v: json["__v"],
        savingBy: json["savingBy"],
    promotionalTag: json["promotionalTag"],
    image: json["image"],

      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "quantity": quantity,
        "price": price,
        "productType": productType,
        "iosProductId": iosProductId,
        "androidProductId": androidProductId,
        "isDeleted": isDeleted,
        "sortOrder": sortOrder?.toIso8601String(),
        "time": time?.toIso8601String(),
        "__v": v,
        "savingBy": savingBy,
        "promotionalTag": promotionalTag,
        "image": image,
      };
}

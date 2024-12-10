// To parse this JSON data, do
//
//     final subscriptionPlansResModel = subscriptionPlansResModelFromJson(jsonString);

import 'dart:convert';





SubscriptionPlansResModel subscriptionPlansResModelFromJson(String str) => SubscriptionPlansResModel.fromJson(json.decode(str));

String subscriptionPlansResModelToJson(SubscriptionPlansResModel data) => json.encode(data.toJson());

class SubscriptionPlansResModel  {
  final bool success;
  final String message;
  final List<SubscriptionPlan>? subscriptionPlans;

  SubscriptionPlansResModel({
   required this.success,
   required this.message,
    this.subscriptionPlans,
  });

  factory SubscriptionPlansResModel.fromJson(Map<String, dynamic> json) => SubscriptionPlansResModel(
    success: json["success"],
    message: json["message"],
    subscriptionPlans: json["data"] == null ? [] : List<SubscriptionPlan>.from(json["data"]!.map((x) => SubscriptionPlan.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": subscriptionPlans == null ? [] : List<dynamic>.from(subscriptionPlans!.map((x) => x.toJson())),
  };
}

class SubscriptionPlan extends InAppPlan {
  final String? id;
  final String? name;
  final String? description;
  final double? price;
  final int? days;
  final List<String>? features;
  final int? instantChat;
  final int? crush;
  final int? dateRequest;
  final int? centerStage;
  final String? iosPlanId;
  final String? androidPlanId;
  final bool? isDeleted;
  final DateTime? sortOrder;
  final DateTime? time;
  final int? v;
  final double? pricePerWeek;
  final String? savingBy;

  SubscriptionPlan({
    this.id,
    this.name,
    this.description,
    this.price,
    this.days,
    this.features,
    this.instantChat,
    this.crush,
    this.dateRequest,
    this.centerStage,
    this.iosPlanId,
    this.androidPlanId,
    this.isDeleted,
    this.sortOrder,
    this.time,
    this.v,
    this.savingBy,
    this.pricePerWeek,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) => SubscriptionPlan(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    price: json["price"]?.toDouble(),
    days: json["days"],
    features: json["features"] == null ? [] : List<String>.from(json["features"]!.map((x) => x)),
    instantChat: json["instantChat"],
    crush: json["crush"],
    dateRequest: json["dateRequest"],
    centerStage: json["centerStage"],
    iosPlanId: json["iosPlanId"],
    androidPlanId: json["androidPlanId"],
    isDeleted: json["isDeleted"],
    sortOrder: json["sortOrder"] == null ? null : DateTime.parse(json["sortOrder"]),
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    v: json["__v"],
    pricePerWeek: json["pricePerWeek"],
    savingBy: json["savingBy"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "price": price,
    "days": days,
    "features": features == null ? [] : List<dynamic>.from(features!.map((x) => x)),
    "instantChat": instantChat,
    "crush": crush,
    "dateRequest": dateRequest,
    "centerStage": centerStage,
    "iosPlanId": iosPlanId,
    "androidPlanId": androidPlanId,
    "isDeleted": isDeleted,
    "sortOrder": sortOrder?.toIso8601String(),
    "time": time?.toIso8601String(),
    "__v": v,
    "pricePerWeek": pricePerWeek,
    "savingBy": savingBy,
  };
}

class InAppPlan{}

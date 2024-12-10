import 'package:streax/consts/enums.dart';
import 'package:streax/model/user.dart';

var mediaTypeValues = EnumValues({
  'image':MediaType.image,
  'video':MediaType.video,
});

class Story {
  final String? id;
  final String? user;
  final MediaType? mediaType;
  String? mediaUrl;
  final String? thumbnail;
  final String? redisId;
  final bool? isDeleted;
  bool? seenStory;
  final DateTime? time;
  final int? v;
  final int? mediaDuration;
  final List<User>? storyView;

  Story({
    this.id,
    this.user,
    this.mediaType,
    this.mediaUrl,
    this.thumbnail,
    this.isDeleted,
    this.seenStory,
    this.time,
    this.v,
    this.redisId,
    this.mediaDuration,
    this.storyView
  });

  factory Story.fromJson(Map<String, dynamic> json) => Story(
    id: json["_id"],
    user: json["user"],
    mediaType: mediaTypeValues.map[json["mediaType"]],
    mediaUrl: json["mediaUrl"],
    thumbnail: json["thumbnail"],
    mediaDuration: json["mediaDuration"],
    isDeleted: json["isDeleted"],
    seenStory: json["seenStory"],
    redisId: json["redisId"],
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    v: json["__v"],
    storyView: json["storyView"] == null ? [] : List<User>.from(json["storyView"]!.map((x) => User.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "mediaType": mediaTypeValues.reverse[mediaType],
    "mediaUrl": mediaUrl,
    "thumbnail": thumbnail,
    "seenStory": seenStory,
    "mediaDuration": mediaDuration,
    "isDeleted": isDeleted,
    "time": time?.toIso8601String(),
    "redisId": redisId,
    "storyView": storyView == null ? [] : List<User>.from(storyView!.map((x) => x.toJson())),
    "__v": v,
  };
}
import 'package:streax/consts/enums.dart';
import 'package:streax/model/story/story.dart';


var genderValues = EnumValues({
  "MAN": Gender.man,
  "WOMAN": Gender.woman,
  "NON_BINARY": Gender.nonBinary,
});


var interestedInValues = EnumValues({
  "MEN": Gender.men,
  "WOMEN": Gender.women,
  "everyone": Gender.everyone,
});


var loginTypeValues = EnumValues({
  "MANUAL":LoginType.manual,
  "GOOGLE":LoginType.google,
  "APPLE":LoginType.apple,
});

class User {
  final String? id;
  final String? countryCode;
  final String? mobile;
  String? fullName;
  final String? dob;
  String? image;
  final List<String>? gallery;
  final String? introVideo;
  final String? introVideoThumbnail;
  final String? role;
  final List<String?>? socketIds;
  final bool? isActive;
  final bool? isDeleted;
  final int? instantChat;
  final int?  crush;
  int? centerStage;
  final int? dateRequest;
  final DateTime? time;
  final int? v;
  final LoginType? loginType;
  final String? token;
  final String? email;
  final String? password;
  final String? school;
  final String? aboutMe;
  final String? fcmToken;
  final String? from;
  final Gender? gender;
  final Gender? interestedIn;
  final String? livesIn;
  final String? userName;
  final String? worksAt;
  bool? isSelected;
  final Range? age;
  final dynamic distance;
  final bool? travelMode;
  final bool? mutualMatchNotification;
  final bool? likedMeNotification;
  final bool? chatNotification;
  final bool? storyNotification;
  final Subscription? subscription;
  bool videoMuted;

  // Extra params

  int? iLiked;
  final int? likedMe;
  int? superLike;
  int? isCenterStage;
  final List<Story>? stories;

  User({
    this.id,
    this.countryCode,
    this.mobile,
    this.fullName,
    this.dob,
    this.image,
    this.gallery,
    this.introVideo,
    this.introVideoThumbnail,
    this.role,
    this.socketIds,
    this.isActive,
    this.isDeleted,
    this.instantChat,
    this.crush,
    this.dateRequest,
    this.centerStage,

    this.time,
    this.v,
    this.loginType,
    this.token,
    this.email,
    this.password,
    this.school,
    this.aboutMe,
    this.fcmToken,
    this.from,
    this.gender,
    this.interestedIn,
    this.livesIn,
    this.userName,
    this.worksAt,
    this.age,
    this.distance,
    this.travelMode,
    this.mutualMatchNotification,
    this.likedMeNotification,
    this.chatNotification,
    this.storyNotification,
    this.subscription,
    this.videoMuted = true,
    //extra param
    this.iLiked,
    this.likedMe,
    this.superLike,
    this.isCenterStage,
    this.stories,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      User(
        id: json["_id"],
        countryCode: json["countryCode"],
        mobile: json["mobile"],
        fullName: json["fullName"],
        dob: json["dob"],
        image: json["image"],
        gallery: json["gallery"] == null
            ? []
            : List<String>.from(json["gallery"]!.map((x) => x)),
        introVideo: json["introVideo"],
        introVideoThumbnail: json["introVideoThumbnail"],
        role: json["role"],
        socketIds: json["socketIds"] == null
            ? []
            : List<String>.from(json["socketIds"]!.map((x) => x)),
        isActive: json["isActive"],
        isDeleted: json["isDeleted"],
        instantChat: json["instantChat"],
        crush: json["crush"],
        centerStage: json["centerStage"],
        dateRequest: json["dateRequest"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
        v: json["__v"],
        loginType: loginTypeValues.map[json["loginType"]],
        token: json["token"],
        email: json["email"],
        password: json["password"],
        school: json["School"],
        aboutMe: json["aboutMe"],
        fcmToken: json["fcmToken"],
        from: json["from"],
        gender: genderValues.map[json["gender"]],
        interestedIn: interestedInValues.map[json["interestedIn"]],
        livesIn: json["livesIn"],
        userName: json["userName"],
        worksAt: json["worksAt"],
        travelMode: json["travelMode"],
        mutualMatchNotification: json["mutualMatchNotification"],
        likedMeNotification: json["likedMeNotification"],
        chatNotification: json["chatNotification"],
        storyNotification: json["storyNotification"],
        subscription: json["subscription"] == null ? null : Subscription.fromJson(json["subscription"]),
        //Extra param
        iLiked: json['iLiked'],
        likedMe: json['likedMe'],
        superLike: json['superLike'],
        isCenterStage: json['centerstage'],
        age: json["age"] == null ? null : Range.fromJson(json["age"]),
        distance: json["distance"] ,
        stories: json["stories"] == null
            ? []
            : List<Story>.from(json["stories"]!.map((x) => Story.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        "_id": id,
        "countryCode": countryCode,
        "mobile": mobile,
        "fullName": fullName,
        "dob": dob,
        "image": image,
        "gallery":
        gallery == null ? [] : List<dynamic>.from(gallery!.map((x) => x)),
        "introVideo": introVideo,
        "introVideoThumbnail": introVideoThumbnail,
        "role": role,
        "socketIds": socketIds == null
            ? []
            : List<dynamic>.from(socketIds!.map((x) => x)),
        "isActive": isActive,
        "isDeleted": isDeleted,
        "instantChat": instantChat,
        "crush": crush,
        "centerStage": centerStage,
        "dateRequest": dateRequest,
        "time": time?.toIso8601String(),
        "__v": v,
        "loginType": loginTypeValues.reverse[loginType],
        "token": token,
        "email": email,
        "password": password,
        "School": school,
        "aboutMe": aboutMe,
        "fcmToken": fcmToken,
        "from": from,
        "gender": genderValues.reverse[gender],
        "interestedIn": interestedInValues.reverse[interestedIn],
        "livesIn": livesIn,
        "userName": userName,
        "worksAt": worksAt,
        "travelMode": travelMode,
        "mutualMatchNotification": mutualMatchNotification,
        "likedMeNotification": likedMeNotification,
        "chatNotification": chatNotification,
        "storyNotification": storyNotification,
        "subscription": subscription?.toJson(),
        //Extra param
        "iLiked": iLiked,
        "likedMe": likedMe,
        "superLike": superLike,
        "centerstage": isCenterStage,
        "age": age?.toJson(),
        "distance": distance,
        "stories": stories == null
            ? []
            : List<Story>.from(stories!.map((x) => x.toJson())),
      };
}

class Range {
  final int? min;
  final int? max;

  Range({
    this.min,
    this.max,
  });

  factory Range.fromJson(Map<String, dynamic> json) =>
      Range(
        min: json["min"],
        max: json["max"],
      );

  Map<String, dynamic> toJson() =>
      {
        "min": min,
        "max": max,
      };
}

class Subscription {
  final String? id;
  final String? plan;
  final String? platform;
  final DateTime? startOn;
  final DateTime? subscriptionExpireOn;
  final int? instantChat;
  final int? crush;
  final int? dateRequest;
  final int? centerStage;
  final bool? travelMode;
  final String? description;

  Subscription({
    this.id,
    this.plan,
    this.platform,
    this.startOn,
    this.subscriptionExpireOn,
    this.instantChat,
    this.crush,
    this.dateRequest,
    this.centerStage,
    this.travelMode,
    this.description,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    id: json["_id"],
    plan: json["plan"],
    platform: json["platform"],
    startOn: json["startOn"] == null ? null : DateTime.parse(json["startOn"]),
    subscriptionExpireOn: json["subscriptionExpireOn"] == null ? null : DateTime.parse(json["subscriptionExpireOn"]),
    instantChat: json["instantChat"],
    crush: json["crush"],
    dateRequest: json["dateRequest"],
    centerStage: json["centerStage"],
    travelMode: json["travelMode"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "plan": plan,
    "platform": platform,
    "startOn": startOn?.toIso8601String(),
    "subscriptionExpireOn": subscriptionExpireOn?.toIso8601String(),
    "instantChat": instantChat,
    "crush": crush,
    "dateRequest": dateRequest,
    "centerStage": centerStage,
    "travelMode": travelMode,
    "description": description,
  };
}

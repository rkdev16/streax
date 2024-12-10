enum AuthFormType { signIn, signUp }
enum AuthType { phone, email }

enum OtpVerificationFor { forgotPassword, signup }
enum ConnectionType{
  mutual,iLiked,likedMe,none
}


enum LoginType{
  google,apple,manual
}

enum Gender {
  men,women,nonBinary,everyone,man,woman
}

enum RecordVideoFor{
  profileSetup,editProfile
}

enum MediaType{
  image,video
}

enum SourceType{
  local,global
}


enum FilterType{
  all,mutual,iLiked,likedMe
}

enum MessageType{
  image,video,audio,location,text,hangoutRequest,story
}
enum ChatUserType{
  local,remote
}

enum DeleteMessageType{
  deleteForMe,deleteForEveryone
}


enum ChatState{
  pendingRequest,allowChat,acceptRequest,adminChat
}

enum OneTimePurchaseType{
  dateRequest,crush,travelMode,instantChat,centerStage
}

enum InAppProductType{
  consumable,nonConsumable
}


enum PremiumType{
  instantChat,crush,centerStage,dateRequest,travelMode
}

enum MediaSource {
  camera,gallery
}


class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> _reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    _reverseMap = map.map((k, v) => MapEntry(v, k));
    return _reverseMap;
  }
}



//
//
// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> _reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     _reverseMap = map.map((key, value) => MapEntry(value, key));
//     return _reverseMap;
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/model/user.dart';
import 'package:streax/utils/preference_manager.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../consts/app_consts.dart';

class Helpers {
  Helpers._();

  static String getCompleteUrl(String? url) {
    if (url == null) return "";

    if (url.startsWith('http')) {
      debugPrint("Url complete = $url");

      return url;
    } else {
      debugPrint("Url complete added  = https://cdnblob-hed0h9hkephzg9ar.z01.azurefd.net/bucketstreax/$url");
      return 'https://cdnblob-hed0h9hkephzg9ar.z01.azurefd.net/bucketstreax/$url';
    }
  }

  static printLog({required String screenName, required String message}) {
    if (AppConsts.isDebug) debugPrint("$screenName ==== $message");
  }

  static bool isResponseSuccessful(int code) {
    return code >= 200 && code < 300;
  }

  static String getImgUrl(String? url) {
    debugPrint("url ======= = $url");

    if (url == null) return '';
    if (url.startsWith('http')) {
      return url;
    } else {
      // return 'https://bucketapp.blob.core.windows.net/bucketstreax/$url';
      return 'https://cdnblob-hed0h9hkephzg9ar.z01.azurefd.net/bucketstreax/$url';
    }
  }

  static String getTimeAgo(DateTime? time) {
    if (time == null) return '';

    String timeAgo = '';
    var minutes = DateTime.now().difference(time).inMinutes;
    if (minutes < 60) {
      if (minutes.round() == 0) {
        timeAgo = "Just now";
      } else {
        timeAgo = "${minutes.round()} minutes ago";
      }
    } else if (minutes < 1440) {
      timeAgo = "${(minutes / 60).round()} hours ago";
    } else if (minutes < 43800) {
      timeAgo = "${(minutes / 1440).round()} days ago";
    } else if (minutes < 525800) {
      timeAgo = "${(minutes / 43800).round()} months ago";
    } else {
      timeAgo = "${(minutes / 525800).round()} years ago";
    }
    return timeAgo;
  }

  static String calculateAge(String? source) {
    debugPrint("SourceDate = $source");
    if (source == null || source.isEmpty) return "NA";
    var dob = DateTime.parse(source);
    return (DateTime.now().difference(dob).inDays ~/ 365).toString();
  }

  static ConnectionType getConnectionType(User user) {
    debugPrint("ConnectionType = iLiked = ${user.iLiked}");
    debugPrint("ConnectionType = likedMe = ${user.likedMe}");
    if (user.iLiked == 1 && user.likedMe == 1) {
      return ConnectionType.mutual;
    } else if (user.iLiked == 1 && user.likedMe == 0) {
      return ConnectionType.iLiked;
    } else {
      return ConnectionType.likedMe;
    }
  }

  static Future<String?> createVideoThumbnail(String url) async {
    debugPrint("create Video Thumbnail Url = $url");
    var dirPath = await getTemporaryDirectory();
    final fileName = await VideoThumbnail.thumbnailFile(
      video: url,
      thumbnailPath: dirPath.path,
      imageFormat: ImageFormat.PNG,
      maxWidth: 200,
      quality: 80,
    );

    return fileName;
  }

  static String formatPrice(dynamic price) {
    var priceFormatter = NumberFormat.currency(locale: "en_US", symbol: "\$");

    return priceFormatter.format(price ?? 0);
  }

  static bool canUsePremium(PremiumType premiumType) {
    final user = PreferenceManager.user;
    final subscription = user?.subscription;

    bool isAvailable = false;

    switch (premiumType) {
      case PremiumType.travelMode:
        isAvailable = subscription != null;
        break;

      case PremiumType.instantChat:
        final availableCount =
            (subscription?.instantChat ?? 0) + (user?.instantChat ?? 0);
        isAvailable = availableCount > 0;
        break;

      case PremiumType.crush:
        final availableCount = (subscription?.crush ?? 0) + (user?.crush ?? 0);
        isAvailable = availableCount > 0;
        break;

      case PremiumType.centerStage:
        final availableCount =
            (subscription?.centerStage ?? 0) + (user?.centerStage ?? 0);
        isAvailable = availableCount > 0;
        break;

      case PremiumType.dateRequest:
        final availableCount =
            (subscription?.dateRequest ?? 0) + (user?.dateRequest ?? 0);
        isAvailable = availableCount > 0;
        break;
    }

    return isAvailable;
  }
}

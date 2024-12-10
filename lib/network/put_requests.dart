import 'package:streax/model/base_res_model.dart';
import 'package:streax/model/profile_res_model.dart';
import 'package:streax/network/api_urls.dart';
import 'package:streax/network/remote_services.dart';

class PutRequests {
  PutRequests._();

  static Future<ProfileResModel?> updateProfile(
      Map<String, dynamic> requestBody) async {
    var apiResponse =
    await RemoteService.simplePut(requestBody, ApiUrls.updateProfile);

    if (apiResponse != null) {
      return profileResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }



  static Future<BaseResModel?> deleteMessage(String messageId,Map<String, dynamic> requestBody) async {
    var apiResponse =
    await RemoteService.simplePut(requestBody, ApiUrls.deleteMessage+messageId);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<BaseResModel?> viewChatMedia(String messageId) async {
    var apiResponse =
    await RemoteService.simplePut({}, ApiUrls.viewChatMedia+messageId);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<BaseResModel?> notificationReadAll() async {

    var apiResponse = await RemoteService.simplePut({},ApiUrls.notificationsReadAll);
    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else{
      return null;
    }
  }
}
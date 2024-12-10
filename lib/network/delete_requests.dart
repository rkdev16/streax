
import 'package:streax/model/base_res_model.dart';
import 'package:streax/network/api_urls.dart';
import 'package:streax/network/remote_services.dart';

class DeleteRequests{
  DeleteRequests._();

  static Future<BaseResModel?> deleteStory(String storyId) async {

    var apiResponse = await RemoteService.simpleDelete(endUrl: ApiUrls.deleteStory+storyId);
    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else{
      return null;
    }
  }


  static Future<BaseResModel?> deleteAccount(Map<String,dynamic> requestBody) async {

    var apiResponse = await RemoteService.simpleDelete(endUrl: ApiUrls.deleteAccount,requestBody: requestBody);
    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else{
      return null;
    }
  }

}
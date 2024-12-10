
import 'dart:io';

import 'package:streax/model/base_res_model.dart';
import 'package:streax/model/hangout_request_res_model.dart';
import 'package:streax/model/login_res_model.dart';
import 'package:streax/model/message_sent_res_model.dart';
import 'package:streax/model/request_otp_res_model.dart';
import 'package:streax/model/signup_res_model.dart';
import 'package:streax/model/upload_files_res_model.dart';
import 'package:streax/network/api_urls.dart';
import 'package:streax/network/remote_services.dart';


class PostRequests {
  PostRequests._();
  static Future<bool>  checkEmailExist(String email) async {
    var requestBody = {'email': email};
    var apiResponse =
    await RemoteService.simplePost(requestBody, ApiUrls.checkEmailExist);

    if (apiResponse != null) {
      var response = baseResModelFromJson(apiResponse.response!);
      return response.success;
    } else {
      return true;
    }
  }
  static Future<bool> checkPhoneExist( String countryCode,String mobile) async {
    var requestBody = { "countryCode": countryCode, "mobile" : mobile};
    var apiResponse = await RemoteService.simplePost(requestBody, ApiUrls.checkMobileExist);
    if (apiResponse != null) {
      var response = baseResModelFromJson(apiResponse.response!);
      return response.success;
    } else {
      return true;
    }
  }

  static Future<bool>  checkUsernameExist(String username) async {
    var requestBody = {'userName': username};
    var apiResponse =
    await RemoteService.simplePost(requestBody, ApiUrls.checkUsernameExists);

    if (apiResponse != null) {
      var response = baseResModelFromJson(apiResponse.response!);
      return response.success;
    } else {
      return true;
    }
  }

  static Future<RequestOtpResModel?> requestOtpEmail( String email) async {
    var requestBody = { "email": email};
    var apiResponse = await RemoteService.simplePost(requestBody, ApiUrls.requestOtpEmail);
    if (apiResponse != null) {
      return requestOtpResModelFromJson(apiResponse.response!);
    } else{
      return null;
    }
  }


  static Future<RequestOtpResModel?> requestOtpMobile( String countryCode,String mobile) async {
    var requestBody = { "countryCode": countryCode, "mobile" : mobile};
    var apiResponse = await RemoteService.simplePost(requestBody, ApiUrls.requestOtpMobile);
    if (apiResponse != null) {
      return requestOtpResModelFromJson(apiResponse.response!);
    } else{
      return null;
    }
  }


  static Future<SignupResModel?> registerWithEmail(Map<String,dynamic> requestBody) async {

    var apiResponse = await RemoteService.simplePost(requestBody, ApiUrls.registerWithEmail);
    if (apiResponse != null) {
      return signupResModelFromJson(apiResponse.response!);
    } else{
      return null;
    }
  }

  static Future<SignupResModel?> registerWithMobile(Map<String,dynamic> requestBody) async {

    var apiResponse = await RemoteService.simplePost(requestBody, ApiUrls.registerWithMobile);
    if (apiResponse != null) {
      return signupResModelFromJson(apiResponse.response!);
    } else{
      return null;
    }
  }


  static Future<UploadFilesResModel?> uploadFiles({String? uploadKey, required List<String> paths}) async {
    var apiResponse = await RemoteService.uploadFiles(endUrl: ApiUrls.uploadFiles, paths: paths,uploadKey: uploadKey);
    if (apiResponse != null) {
      return uploadFilesResModelFromJson(apiResponse.response!);
    } else{
      return null;
    }
  }

  static Future<BaseResModel?> centerStage(String id) async {
    var apiResponse = await RemoteService.simplePost({}, ApiUrls.centerStage + id);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }


  static Future<LoginResModel?> login(Map<String,dynamic> requestBody) async {

    var apiResponse = await RemoteService.simplePost(requestBody,ApiUrls.login);
    if (apiResponse != null) {
      return loginResModelFromJson(apiResponse.response!);
    } else{
      return null;
    }
  }

  static Future<LoginResModel?> socialSignIn(Map<String,dynamic> requestBody) async {

    var apiResponse = await RemoteService.simplePost(requestBody,ApiUrls.socialLogin);
    if (apiResponse != null) {
      return loginResModelFromJson(apiResponse.response!);
    } else{
      return null;
    }
  }


  static Future<RequestOtpResModel?> forgotPassword(Map<String,dynamic> requestBody) async {

    var apiResponse = await RemoteService.simplePost(requestBody,ApiUrls.forgotPassword);
    if (apiResponse != null) {
      return requestOtpResModelFromJson(apiResponse.response!);
    } else{
      return null;
    }
  }

  static Future<RequestOtpResModel?> resetPassword(Map<String,dynamic> requestBody) async {

    var apiResponse = await RemoteService.simplePost(requestBody,ApiUrls.resetPassword);
    if (apiResponse != null) {
      return requestOtpResModelFromJson(apiResponse.response!);
    } else{
      return null;
    }
  }


  static Future<BaseResModel?> postStory(Map<String,dynamic> requestBody) async {

    var apiResponse = await RemoteService.simplePost(requestBody,ApiUrls.postStory);
    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else{
      return null;
    }
  }




  static Future<BaseResModel?> blockUnBlock(Map<String,dynamic> requestBody) async {
    var apiResponse =

    await RemoteService.simplePost(requestBody,ApiUrls.blockUnblock);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }



  static Future<BaseResModel?> reportUser(Map<String,dynamic> requestBody) async {
    var apiResponse =

    await RemoteService.simplePost(requestBody,ApiUrls.reportUser);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<MessageSentResModel?> sendMessage(String roomId,Map<String,dynamic> requestBody) async {
    var apiResponse =

    await RemoteService.simplePost(requestBody,ApiUrls.sendMessage+roomId);

    if (apiResponse != null) {
      return messageSentResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<HangoutRequestResModel?> sendHangoutRequest(String userId,Map<String,dynamic> requestBody) async {
    var apiResponse =

    await RemoteService.simplePost(requestBody,ApiUrls.sendHangoutRequest+userId);

    if (apiResponse != null) {
      return hangoutRequestResModelFromJson(apiResponse.response!);
    } else {
      return null;

    }
  }



  static Future<BaseResModel?> changePassword(Map<String,dynamic> requestBody) async {
    var apiResponse =

    await RemoteService.simplePost(requestBody,ApiUrls.changePassword);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;

    }
  }

  static Future<BaseResModel?> acceptChatRequest(Map<String,dynamic> requestBody) async {
    var apiResponse =

    await RemoteService.simplePost(requestBody,ApiUrls.acceptChatRequest);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;

    }
  }

  static Future<BaseResModel?> updateOneTimePurchaseSuccess(Map<String,dynamic> requestBody) async {
    var apiResponse =

    await RemoteService.simplePost(requestBody,ApiUrls.updateOneTimePurchaseSuccess);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;

    }
  }


  static Future<BaseResModel?> updateSubscriptionPurchaseSuccess(Map<String,dynamic> requestBody) async {
    var apiResponse =

    await RemoteService.simplePost(requestBody,Platform.isAndroid ? ApiUrls.updateSubscriptionPurchaseSuccess : ApiUrls.updateSubscriptionPurchaseSuccessIos);
    // await RemoteService.simplePost(requestBody,ApiUrls.updateSubscriptionPurchaseSuccess);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;

    }
  }








}

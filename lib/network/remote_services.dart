
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:streax/network/api_urls.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/utils/internet_connections.dart';
import 'package:streax/utils/preference_manager.dart';
import '../model/common_res_model.dart';
class RemoteService{
  RemoteService._();
  static var client = http.Client();
 static const _baseUrl = ApiUrls.baseUrl;
  static Map<String, String> getHeaders (){
  Map<String, String> headers = {
  "Accept": "application/json",
  "Content-Type": "application/json;charset=utf-8"
  };
    headers.addAll({"Authorization": "Bearer ${PreferenceManager.token}"});
    debugPrint('Token = ${PreferenceManager.token}');

    return headers;
  }



  static Future<Map<String, String>> getHeadersFileUpload() async {
    String? bearerToken =
    await PreferenceManager.getPref(PreferenceManager.prefKeyUserToken)
    as String?;
    Map<String, String> headers = {
      // "Accept": "application/json",
      // "Content-Type": "application/json;charset=utf-8"
    };

    if (bearerToken != null) {
      headers.addAll({"Authorization": "Bearer $bearerToken"});
    }
    return headers;
  }




  static Future<CommonResModel?> simpleGet(String endUrl) async {
    var isConnected = await InternetConnection.isConnected();

    debugPrint('IsConnected = $isConnected');

    if (!isConnected) {
      return null;
    }

    debugPrint('Url = ${Uri.parse(_baseUrl + endUrl)}');
    final response =
    await http.get(Uri.parse(_baseUrl + endUrl), headers: getHeaders());


    debugPrint('Response = ${response.statusCode} ====>>>>  ${_baseUrl + endUrl}');
    Helpers.printLog(
        screenName: 'Remote_Service_simple_get',
        message: "response = ${response.body}");
    debugPrint('request_url = ${_baseUrl + endUrl}');
    debugPrint('request_headers = ${getHeaders().toString()}');
    var responseCode = response.statusCode;
    if (Helpers.isResponseSuccessful(responseCode)) {
      return CommonResModel(statusCode: responseCode, response: response.body);
    } else {

      return null;
    }
  }

  static Future<CommonResModel?> simpleDelete(
      {required String endUrl, Map<String, dynamic>? requestBody}) async {
    var isConnected = await InternetConnection.isConnected();

    debugPrint('IsConnected = $isConnected');

    if (!isConnected) {
      return null;
    }
    Uri url = Uri.parse(_baseUrl + endUrl);
    debugPrint('Url = $url');

    var body = jsonEncode(requestBody??{});
    final response =
    await http.delete(url,
        headers: getHeaders(),
      body: body
    );


    debugPrint('Response = ${response.statusCode}');
    Helpers.printLog(
        screenName: 'Remote_Service_simple_get',
        message: "response = ${response.body}");
    debugPrint('request_url = ${_baseUrl + endUrl}');
    debugPrint('request_headers = ${getHeaders().toString()}');
    var responseCode = response.statusCode;
    if (Helpers.isResponseSuccessful(responseCode)) {
      return CommonResModel(statusCode: responseCode, response: response.body);
    } else {

      return null;
    }
  }



  static Future<CommonResModel?> simplePost(
      Map<String, dynamic> requestBody, String endUrl) async {
    debugPrint("it worked");
    var isConnected = await InternetConnection.isConnected();
    debugPrint('IsConnected = $isConnected');

    if (!isConnected) {
      return null;
    }

    Helpers.printLog(
        screenName: 'Remote_Service_simple_post',
        message: "request_data = $requestBody");
    debugPrint('request_url = ${_baseUrl + endUrl}');
    var body = json.encode(requestBody);
    final response = await http.post(Uri.parse(_baseUrl + endUrl),
        headers: getHeaders(), body: body);

    Helpers.printLog(
        screenName: 'Remote_Service_simple_post',
        message: "response = ${response.body}");


    debugPrint('request_url = ${_baseUrl + endUrl}  || Status Code = ${response.statusCode}');

    var responseCode = response.statusCode;
    if (Helpers.isResponseSuccessful(responseCode)) {
      return CommonResModel(statusCode: responseCode, response: response.body);
    } else {
      return null;
    }
  }


  static Future<CommonResModel?> uploadFiles(
  {
    String? httpMethod,
   required String endUrl,
     String? uploadKey,
    required List<String> paths,

}
      ) async {
    var isConnected = await InternetConnection.isConnected();

    if (!isConnected) {
      return null;
    }

    http.MultipartRequest request =
    http.MultipartRequest(httpMethod??'POST', Uri.parse(_baseUrl + endUrl));
    request.headers.addAll(await getHeadersFileUpload());

    for (String path in paths) {
      request.files.add(await http.MultipartFile.fromPath(uploadKey??'files', path));
    }
    debugPrint('FileUrl = $request');
    debugPrint('${request.files}');
    debugPrint('${request.files.first.filename}');
    debugPrint('${request.files.first.contentType}');
    debugPrint('${request.files.first}');
    http.StreamedResponse streamedResponse = await request.send();
    // var responseBytes = await streamedResponse.stream.toBytes();
    // var responseString =  utf8.decode(responseBytes);

    var response = await http.Response.fromStream(streamedResponse);
    Helpers.printLog(
        screenName: 'Remote_Service_upload_photos_post',
        message: "response = ${response.body}");
    var responseCode = response.statusCode;
    if (Helpers.isResponseSuccessful(responseCode)) {
      return CommonResModel(statusCode: responseCode, response: response.body);
    } else {
      AppAlerts.error(message: 'message_server_error'.tr);
      return null;
    }
  }


  static Future<CommonResModel?> simplePut(
      Map<String, dynamic> requestBody, String endUrl) async {
    var isConnected = await InternetConnection.isConnected();

    if (!isConnected) {
      return null;
    }

    Helpers.printLog(
        screenName: 'Remote_Service_simple_put',
        message: "request_data = $requestBody");
    debugPrint('request_url = ${_baseUrl + endUrl}');
    var body = json.encode(requestBody);
    final response = await http.put(Uri.parse(_baseUrl + endUrl),
        headers: getHeaders(), body: body);

    Helpers.printLog(
        screenName: 'Remote_Service_simple_put',
        message: "response = ${response.body}");
    debugPrint('request_url = ${_baseUrl + endUrl}');

    var responseCode = response.statusCode;
    debugPrint('responseCode = $responseCode  ===>>>> ${_baseUrl + endUrl}');
    if (Helpers.isResponseSuccessful(responseCode)) {
      return CommonResModel(statusCode: responseCode, response: response.body);
    } else {
      return null;
    }
  }






}
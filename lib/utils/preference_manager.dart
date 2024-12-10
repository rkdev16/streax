import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streax/model/user.dart';

class PreferenceManager {
  static const prefKeyIsLogin = 'pref_key_is_user_login';
  static const prefKeyIsFirstLaunch = 'pref_key_is_first_launch';
  static const prefKeyUserToken = 'pref_key_user_token';
  static const prefKeyFcmToken = 'pref_fcm_token';
  static const prefKeyLatitude = 'pref_latitude';
  static const prefKeyLongitude = 'pref_longitude';
  static const prefKeyUser= 'pref_key_user';
  static const prefKeyIsAllowAppNotification= 'pref_key_is_allow_app_notification';
  static const prefKeyCurrentLocation = 'pref_key_current_location';

  static late SharedPreferences _prefs;

  PreferenceManager._();

  static Future<SharedPreferences> _getInstance() {
    return SharedPreferences.getInstance();
  }

  static Future<bool> init() async {
    _prefs = await _getInstance();
    return Future.value(true);
  }
  static bool isFirstTimeLaunch() {
    bool? isFirstLaunch = getPref(prefKeyIsFirstLaunch) as bool?;
    return isFirstLaunch ?? true;
  }

  static void save2Pref(String key, dynamic value) {
    if (value is bool) {
      _prefs.setBool(key, value);
    } else if (value is int) {
      _prefs.setInt(key, value);
    } else if (value is double) {
      _prefs.setDouble(key, value);
    } else if (value is String) {
      // print('key = $key, value = $value');
      _prefs.setString(key, value);
    } else {
      // throw Exception("Attempting to save non-primitive preference");
    }
  }

  static Object? getPref(String key) {
    return _prefs.get(key);
  }
  static String get userToken => _prefs.getString(prefKeyUserToken)??'';
  static  set userToken(String? token){
    _prefs.setString(prefKeyUserToken, token??'');
  }





  static User? get user {
    String? user = _prefs.getString(prefKeyUser);
    if(user !=null){
      return User.fromJson(jsonDecode(user));
    }else{
      return null;
    }
  }

  static set user(User? user){
    if(user !=null){
      _prefs.setString(prefKeyUser,jsonEncode(user.toJson()));
    }else{
      _prefs.remove(prefKeyUser);
    }
  }









  static String get token => (getPref(prefKeyUserToken)??'') as String;
  static set token(String? token){
    _prefs.setString(prefKeyUserToken, token??'');
  }

  static String get fcmToken => (getPref(prefKeyFcmToken)??'') as String;
  static set fcmToken(String? token){
    _prefs.setString(prefKeyFcmToken, token??'');
  }




  static bool get isFirstLaunch  => (getPref(prefKeyIsFirstLaunch)??true) as bool;
  static set  isFirstLaunch(bool isFirstLaunch) {
    _prefs.setBool(prefKeyIsFirstLaunch, isFirstLaunch);

  }




  static bool get isAllowAppNotification  => (getPref(prefKeyIsAllowAppNotification)??true) as bool;
  static set  isAllowAppNotification(bool isAllowAppNotification) {
    _prefs.setBool(prefKeyIsAllowAppNotification, isAllowAppNotification);
  }


  static LatLng? get currentLocation => LatLng.fromJson(json.encode(_prefs.getString(prefKeyCurrentLocation)));
  static set currentLocation(LatLng? currentLocation){
    _prefs.setString(prefKeyCurrentLocation, json.encode(currentLocation?.toJson()));

  }


  static void clean() {
    _prefs.clear();
  }

  static void logoutUser() {
    _prefs.remove(prefKeyUserToken);
    _prefs.remove(prefKeyIsLogin);
    //  prefs.remove(prefIsFistLaunch);
  }
}

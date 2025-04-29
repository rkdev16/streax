import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streax/consts/enums.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';


import '../config/size_config.dart';

class AppConsts {

  AppConsts._();


  static const String appName = 'STREAX';
  static const double tabFontFactor = 1.5;
  static const double mobileFontFactor = 1.0;

  static const String googleApiKey = "<Your Google API KEY>";

  static double commonFontSizeFactor = SizeConfig.isMobile ? mobileFontFactor : tabFontFactor;

  static const String baseUrl = "";
  static const String urlTerms = "<TERMS AND CONDITIONS>";
  static const String urlPrivacyPolicy = "<Privacy Policy>";


  static const String stripePK =
      "<STRIPE KEY>";

  //false on release

  static const bool isLog = true;
  static const bool isDebug = true;


  static const double mapCameraTilt = 50.440717697143555;
  static const double mapCameraZoom = 19.151926040649414;


  static var systemOverlayStyle = SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark
  );


  static  var defaultAgeRange = const  SfRangeValues(20.0, 28.0);
  static double defaultDistanceValue = 30;




  //Global keys


  static const defaultMediaDuration = 5;


  static  const keyIsBusinessSetup = "key_is_business_setup";


  static const keyPreferredCountry = 'key_preferred_country';

  static const bulgariaCities = 'assets/raw/bulgaria_cities.json';
  static const greeceCities = 'assets/raw/greece_cities.json';
  static const cyprusCities = 'assets/raw/cyprus_cities.json';





  static const methodChannelName = '<STREAX METHOD CHANNEL>';






  static const keyOtpVerificationFor = 'key_otp_verification_for';
  static const keyOtpData = 'key_otp_data';
  static const keyPassword = 'key_password';
  static const keyAuthType = 'key_auth_type';
  static const keyRecordVideoFor = 'key_record_video_for';
  static const keyVideoPath = 'key_video_path';
  static const keyConnectionsType = 'key_connection_type';
  static const keyIsMyStory = 'key_is_my_story';
  static const keyStoriesData = 'key_stories_data';
  static const keyUser = 'key_user';
  static const keyIndex = 'key_index';
  static const keyListData = 'key_list_data';
  static const keyDuration = 'key_duration';


  static const Map<String,dynamic> genderValuesMap  ={
    'man':'MAN',
    'woman':'WOMAN',
    'non_binary':'NON_BINARY',

  };

  static const Map<String,dynamic> interestedInValuesMap  ={
    'men':'MEN',
    'women':'WOMEN',
    'everyone':'EVERYONE',
  };


  static const Map<Gender,String> interestedInTitleMap = {

    Gender.men: 'men',
    Gender.women: 'women',
    Gender.everyone: 'everyone',



  };






}

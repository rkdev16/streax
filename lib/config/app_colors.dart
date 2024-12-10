
import 'package:flutter/material.dart';

class AppColors{
  AppColors._();



  static const Color kPrimaryColor =   Color(0xffF62A43);

  static const Color colorTextPrimary = Color(0xff2E2E2E);
  static const Color colorTextSecondary = Color(0xff6F6F6F);
  static const Color backgroundColor = Color(0xffFFFFFF);
  static const Color colorC2 = Color(0xffC2C2C2);
  static const Color colorCE = Color(0xffCECECE);
  static const Color color2A = Color(0xff0F172A);
  static const Color colorF3 = Color(0xffF3F3F3);
  static const Color colorF4 = Color(0xffdad5d5);
  static const Color color95 = Color(0xff959595);
  static const Color colorE8 = Color(0xffE8E8E8);
  static const Color colorF6 = Color(0xffF3F6F6);
  static const Color colorEA = Color(0xffE8E6EA);
  static const Color dividerColor = Color(0xffEDF1F4);
  static const Color  color6F = Color(0xff6F6F6F);
  static const Color  color81 = Color(0xff818181);
  static const Color  colorEF = Color(0xffEFEFEF);
  static const colorRed = Color(0xffD83C3D);
  static const colorGreen = Color(0xff63D968);




  static LinearGradient gradientImgOverlay =   LinearGradient(colors: [
     Colors.black.withOpacity(0.8),
     Colors.black.withOpacity(0.1),
  ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    tileMode: TileMode.decal
  );



  static LinearGradient gradientStoryToolbar =   LinearGradient(colors: [
    Colors.black.withOpacity(0.8),
    Colors.black.withOpacity(0.01),
    Colors.black.withOpacity(0),

  ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      tileMode: TileMode.decal
  );


  static LinearGradient gradientBlurOverlay =   LinearGradient(colors: [
    Colors.white.withOpacity(0.17),
    Colors.black.withOpacity(0.34),
  ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,

  );




}
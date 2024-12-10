import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streax/config/size_config.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'app_colors.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.kPrimaryColor,

    // colorScheme: const ColorScheme.light(background: AppColors.backgroundColor),
    colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.kPrimaryColor,
        brightness: Brightness.light,
        background: AppColors.backgroundColor,
        secondary: AppColors.kPrimaryColor

    ),
    scaffoldBackgroundColor: AppColors.backgroundColor,
    appBarTheme: appBarTheme(),
    buttonTheme: _buttonThemeData(),
    fontFamily: 'Plus Jakarta Sans',
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(context),
    visualDensity: VisualDensity.adaptivePlatformDensity,

  );
}

InputDecorationTheme inputDecorationTheme(BuildContext context) {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: AppColors.kPrimaryColor),
    gapPadding: 10,
  );
  OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: AppColors.kPrimaryColor),
    gapPadding: 10,
  );

  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    contentPadding: EdgeInsets.symmetric(
        horizontal: 2 * SizeConfig.widthMultiplier,
        vertical: 2 * SizeConfig.heightMultiplier),
    enabledBorder: outlineInputBorder,
    focusedBorder: enabledBorder,
    hintStyle: Theme.of(context).textTheme.bodyLarge,
    labelStyle: Theme.of(context).textTheme.bodyLarge,
    errorStyle:
        Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red),
    border: outlineInputBorder,

  );
}

TextTheme textTheme() {
  return TextTheme(

    displayLarge: TextStyle(
        color: AppColors.kPrimaryColor,
        fontSize:28.fontMultiplier,
        fontWeight: FontWeight.w700,
        fontFamily: 'Plus Jakarta Sans'),

    displayMedium: TextStyle(
        color: AppColors.colorTextPrimary,
        fontSize:22.fontMultiplier,
        fontWeight: FontWeight.w600,
        fontFamily: 'Plus Jakarta Sans'),

    displaySmall: TextStyle(
        color: AppColors.colorTextPrimary,
        fontSize:20.fontMultiplier,
        fontWeight: FontWeight.w500,
        fontFamily: 'Plus Jakarta Sans'),


    headlineMedium: TextStyle(
        color: AppColors.colorTextPrimary,
        fontSize:18.fontMultiplier,
        fontWeight: FontWeight.w500,
        fontFamily: 'Plus Jakarta Sans'),

    headlineSmall: TextStyle(
        color: AppColors.colorTextPrimary,
        fontSize:14.fontMultiplier,
        fontWeight: FontWeight.w400,
        fontFamily: 'Plus Jakarta Sans'),

    titleLarge: TextStyle(
        // color: AppColors.textColorPrimary,
        fontSize: 12.fontMultiplier,
        fontWeight: FontWeight.w500,
        fontFamily: 'Plus Jakarta Sans'),

    titleMedium: TextStyle(
        color: AppColors.colorTextPrimary,
        fontSize: 14.fontMultiplier,
        fontWeight: FontWeight.w300,
        fontFamily: 'Plus Jakarta Sans'),


    bodyMedium: const TextStyle(
        color: AppColors.colorTextPrimary, fontFamily: 'Plus Jakarta Sans'),
    bodySmall: const TextStyle(
        color: AppColors.colorTextPrimary, fontFamily: 'Plus Jakarta Sans'),


    labelLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 15.fontMultiplier,
      fontFamily: 'Plus Jakarta Sans',
    ),

    labelSmall: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 13.fontMultiplier,
      fontFamily: 'Plus Jakarta Sans',
    ),

  );




}

ButtonThemeData _buttonThemeData() {
  return ButtonThemeData(
    buttonColor: AppColors.kPrimaryColor,
    textTheme: ButtonTextTheme.normal,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: AppColors.backgroundColor),
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16.0));
}



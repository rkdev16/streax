import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:streax/controller/home/home_controller.dart';
import 'package:streax/controller/location/location_controller.dart';

import '../views/dialogs/common/common_alert_dialog.dart';

class PermissionHandler {
  static Future<bool> requestCameraPermission() async {
    //  final serviceStatus = await Permission.camera.isGranted;
    //  final status1 = await Permission.camera.request();
    // bool isCameraOn = serviceStatus == ServiceStat us.enabled;
    await Permission.camera.request();
    var status = await Permission.camera.status;
    if (status.isGranted) {
      debugPrint('---------> permission  granted');
      return true;
    }
    else if (status.isLimited) {
      debugPrint('---------> permission  granted limited');
      return true;
    }
    else if (status.isDenied) {
      debugPrint('---------> permission  denied');
      await Permission.camera.request();
    }
    else if (status.isPermanentlyDenied) {
      debugPrint('---------> permission  denied permanently');
      CommonAlertDialog.showDialog(
          title: 'allow_permissions'.tr,
          message: 'go_to_settings'.tr,
          positiveText: 'open_settings'.tr,
          positiveBtCallback: () async {
            await openAppSettings();
          });

//      await openAppSettings();
    }
    return false;
  }

  static Future<bool> requestLocationPermission() async {
    //  final serviceStatus = await Permission.camera.isGranted;
    //  final status1 = await Permission.camera.request();
    // bool isCameraOn = serviceStatus == ServiceStatus.enabled;

    var status = await Permission.location.status;

    if (status.isGranted) {
      print('Permission Granted');
      return true;
    }
    else if (status.isLimited) {
      print('Permission Granted');
      return true;
    }
     else if (status.isDenied) {
      print('Permission denied');
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      }else{
        return false;
      }
    }
    else if (status.isPermanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    } /*else {
      print('Permission denied');
      var status = await Permission.location.request();

      if (status == PermissionStatus.granted) {
        return true;
      } else {
        showInstructionsDialog();
      }
    }*/
    return false;
  }
}

void showInstructionsDialog() {
  CommonAlertDialog.showDialog(
      title: 'allow_permissions'.tr,
      message: 'go_to_settings'.tr,
      positiveText: 'open_settings'.tr,
      positiveBtCallback: () async {
        await openAppSettings();
        Get.back();
      });
}

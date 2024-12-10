import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/model/user.dart';
import 'package:streax/views/dialogs/common/common_alert_dialog.dart';

class AppAlerts {
  AppAlerts._();

  static success({required String message}) {
    Get.closeAllSnackbars();
    Get.snackbar(
      'success'.tr,
      message,
      backgroundColor: Colors.white.withOpacity(0.5),
    );
  }

  static error({required String message}) {
    Get.closeAllSnackbars();
    Get.snackbar('error'.tr, message,
        backgroundColor: Colors.white.withOpacity(0.5));
  }

  static alert({required String message}) {
    Get.closeAllSnackbars();
    Get.snackbar(
      'alert'.tr,
      message,
      backgroundColor: Colors.white.withOpacity(0.5),
    );
  }

  static custom({required String title, required String message}) {
    Get.closeAllSnackbars();
    Get.snackbar(title.tr, message,
        backgroundColor: Colors.white.withOpacity(0.5));
  }

 static blockUserAlert({
   required User user,
   required VoidCallback onBlockTap}) {
    CommonAlertDialog.showDialog(
        title: '${'block'.tr} ${user.userName}? ',
        message: 'message_block_user'.tr,
        negativeText: 'block',
        positiveText: 'dismiss'.tr,
        positiveBtCallback: () {
          Get.back();
        },
        negativeBtCallback: () {
          Get.back();
          onBlockTap();
        });
  }

  static unblockUserAlert({required User user, required VoidCallback onUnblockTap}) {
    CommonAlertDialog.showDialog(
        title: '${'unblock'.tr} ${user.userName}? ',
        message: 'message_unblock_user'.tr,
        negativeText: 'unblock',
        positiveText: 'dismiss'.tr,
        positiveBtCallback: () {
          Get.back();
        },
        negativeBtCallback: () {
          Get.back();
          onUnblockTap();
        });
  }
}

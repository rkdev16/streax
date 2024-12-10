import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/utils/app_alerts.dart';

class ImagePickerHelper {
  late ImagePicker? _picker;

  ImagePickerHelper() {
    _picker = ImagePicker();
  }

  Future<String?> pickImg({required ImageSource source}) async {
    String? imagePath;
    try {
      XFile? selectedImage =
          await _picker?.pickImage(source: source, imageQuality: 75);
      imagePath = await cropImage(selectedImage?.path);
    } on Exception catch (e) {
      debugPrint('Error $e');
      AppAlerts.error(message: 'message_error_processing_image'.tr);
    }

    return imagePath;
  }

  Future<String?> cropImage(String? path) async {
    if (path == null) return null;

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 9, ratioY: 16),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'image_cropper'.tr,
            toolbarColor: AppColors.kPrimaryColor,
            toolbarWidgetColor: Colors.white,
            showCropGrid: false,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'image_cropper',
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );

    return croppedFile?.path;
  }
}

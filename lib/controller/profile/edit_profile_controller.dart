import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:streax/controller/profile/profile_controller.dart';
import 'package:streax/main.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/network/put_requests.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/image_picker_helper.dart';
import 'package:streax/utils/permission_handler.dart';
import 'package:streax/utils/preference_manager.dart';
import 'package:streax/views/dialogs/common/common_loader.dart';

class EditProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController dobController;
  late TextEditingController workAtController;
  late TextEditingController schoolController;
  late TextEditingController livesInController;
  late TextEditingController fromController;
  late TextEditingController aboutMeController;

  Rx<String?> introVideoUrl = Rx<String?>(null);
  Rx<String?> introVideoThumbnail = Rx<String?>(null);
  Rx<String?> userImageUrl = Rx<String?>(null);
  var gallery = <String>[].obs;

  bool isProfileUpdated = false; // reload profile only if updated

  ImagePickerHelper? _picker;

  @override
  void onInit() {
    super.onInit();
    initTextEditingControllers();
    _picker = ImagePickerHelper();
    setupProfileData();
  }

  @override
  void onClose() {
    disposeTextEditingControllers();
    super.onClose();
  }

  setupProfileData() {
    var user = PreferenceManager.user;

    userImageUrl.value = user?.image;
    introVideoUrl.value = user?.introVideo;
    introVideoThumbnail.value = user?.introVideoThumbnail;
    nameController.text = user?.fullName ?? "";
    workAtController.text = user?.worksAt ?? "";
    schoolController.text = user?.school ?? "";
    livesInController.text = user?.livesIn ?? "";
    fromController.text = user?.from ?? "";
    aboutMeController.text = user?.aboutMe ?? "";
    gallery.assignAll(user?.gallery ?? []);
  }

  initTextEditingControllers() {
    nameController = TextEditingController();
    dobController = TextEditingController();
    workAtController = TextEditingController();
    schoolController = TextEditingController();
    livesInController = TextEditingController();
    fromController = TextEditingController();
    aboutMeController = TextEditingController();
  }

  disposeTextEditingControllers() {
    nameController.dispose();
    dobController.dispose();
    workAtController.dispose();
    schoolController.dispose();
    livesInController.dispose();
    fromController.dispose();
    aboutMeController.dispose();
  }

  Future<String?> picImage(ImageSource source) async {
    var isHavingPermissions = await PermissionHandler.requestCameraPermission();
    if (isHavingPermissions) {
      var imagePath = await _picker?.pickImg(source: source);
      return imagePath;
      // uploadImage(selectedImage!.path);
    }
    return null;
  }

  Future<List<String>> uploadFile(String path) async {
    List<String>? uploadedFiles = [];
    try {
      CommonLoader.show();
      var dirPath = await getApplicationCacheDirectory();
      debugPrint(
          'Original size: ================>>>>>>>>>>>> ${getVideoSize(file: File(path))}');
      await FlutterImageCompress.compressAndGetFile(
        path,
        '${dirPath.path}/(1)${path.toString().split('/').last}',
        quality: 80,
      ).then((value) async {
        debugPrint(
            'Size after compression: ================>>>>>>>>>>>> ${getVideoSize(file: File(value!.path))}');

        var result = await PostRequests.uploadFiles(paths: [value.path]);
        if (result != null) {
          if (result.success) {
            List<String> files = [];
            result.data?.forEach((element) {
              files.add(element.name ?? '');
            });
            uploadedFiles.assignAll(files);

          } else {
            AppAlerts.error(message: result.message);
          }
        } else {
          AppAlerts.error(message: 'message_server_error'.tr);
        }
      });
    } finally {
      CommonLoader.dismiss();
    }
    return uploadedFiles;
  }

  Future<void> validateForm(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (gallery.length < 2) {
      AppAlerts.alert(message: 'minimum_2_images_gallery_required'.tr);
      return;
    }

    await updateProfileData(context);
  }

  Future<void> updateProfileData(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      Map<String, dynamic> requestBody = {
        "fullName": nameController.text.toString().trim(),
        "userName": nameController.text.toString().trim(),
        "dob": dobController.text.toString().trim(),
        "image": userImageUrl.value,
        "gallery": gallery,
        "worksAt": workAtController.text.toString().trim(),
        "School": schoolController.text.toString().trim(),
        "livesIn": livesInController.text.toString().trim(),
        "from": fromController.text.toString().trim(),
        "aboutMe": aboutMeController.text.toString().trim(),
        "introVideo": introVideoUrl.value,
        "introVideoThumbnail": introVideoThumbnail.value,
      };

      debugPrint("update_profile_request_body  =$requestBody");
      CommonLoader.show();
      var result = await PutRequests.updateProfile(requestBody);

      CommonLoader.dismiss();
      if (result != null) {
        if (result.success) {
          isProfileUpdated = true;
          PreferenceManager.user = result.user;
          Get.find<ProfileController>().user.value = result.user;

          AppAlerts.success(message: result.message);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      CommonLoader.dismiss();
    }
  }
}

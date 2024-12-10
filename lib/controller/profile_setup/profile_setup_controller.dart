import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/main.dart';
import 'package:streax/model/common_options_model.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/network/put_requests.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/image_picker_helper.dart';
import 'package:streax/utils/permission_handler.dart';
import 'package:streax/utils/preference_manager.dart';
import 'package:streax/views/bottomsheets/common_options_bottom_sheet.dart';
import 'package:streax/views/dialogs/common/common_loader.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ProfileSetupController extends GetxController {
  GlobalKey<FormState> basicInfoFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> additionalInfoFormKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController userNameController;
  late TextEditingController dobController;
  late TextEditingController workAtController;
  late TextEditingController schoolController;
  late TextEditingController livesInController;
  late TextEditingController fromController;
  late TextEditingController aboutMeController;
  late TextEditingController genderController;
  late TextEditingController interestedInController;

  RxBool isLoading = false.obs;
  RxBool isLoadingUploadFiles = false.obs;

  Rx<SfRangeValues> ageRangeValues =
      Rx<SfRangeValues>(AppConsts.defaultAgeRange);
  Rx<num> distancePreferenceValue = Rx<num>(AppConsts.defaultDistanceValue);
  RxList<String> genderArr = ["man", "woman", "non_binary"].obs;
  RxList<String> interestedInArr = ["men", "women", "everyone"].obs;
  String? selectedGender;
  String? selectedInterestedIn;
  DateTime? selectedDob;
  Rx<String?> profileImage = Rx<String?>(null);
  var additionalImages = <String>[].obs;

  ImagePickerHelper? _picker;

  final RxBool isUserExists = false.obs;
  Worker? checkUserAvailabilityWorker;

  final RxString userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _picker = ImagePickerHelper();
    initTextEditingControllers();
    initWorkers();
  }

  @override
  void onClose() {
    disposeWorkers();
    disposeTextEditingController();

    super.onClose();
  }

  void initWorkers() {
    checkUserAvailabilityWorker =
        debounce(userName, (callback) => checkEmailExist(userName.value));
    userNameController.addListener(() {
      isUserExists.value = false;
      userName.value = userNameController.text.toString().trim();
    });
  }

  disposeWorkers() {
    checkUserAvailabilityWorker?.dispose();
  }

  initTextEditingControllers() {
    nameController = TextEditingController( text: PreferenceManager.user?.fullName ?? '');
    userNameController = TextEditingController(text: PreferenceManager.user?.userName ?? '');
    dobController = TextEditingController();
    workAtController = TextEditingController();
    schoolController = TextEditingController();
    livesInController = TextEditingController();
    fromController = TextEditingController();
    aboutMeController = TextEditingController();
    genderController = TextEditingController();
    interestedInController = TextEditingController();

    if(Get.arguments !=  null) {
      nameController = TextEditingController( text: Get.arguments['displayName']);
    }
  }

  disposeTextEditingController() {
    nameController.dispose();
    userNameController.dispose();
    dobController.dispose();
    workAtController.dispose();
    schoolController.dispose();
    livesInController.dispose();
    fromController.dispose();
    aboutMeController.dispose();
    genderController.dispose();
    interestedInController.dispose();
  }

  checkEmailExist(String username) async {
    if (userName.isNotEmpty) {
      isUserExists.value = await PostRequests.checkUsernameExist(username);
    }
  }

  Future<String?> picImage(ImageSource source) async {
    debugPrint('---------> Ask permission');

    var isHavingPermissions = await PermissionHandler.requestCameraPermission();
    debugPrint('---------> permission $isHavingPermissions');

    if (isHavingPermissions) {
      String? pickedImagePath = await _picker?.pickImg(source: source);
      return pickedImagePath;
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

  selectDob(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime(now.year - 30, 1, 1),
        firstDate: DateTime(now.year - 80, 1, 1),
        lastDate: DateTime(now.year - 18, 1, 1));
    if (pickedDate != null) {
      selectedDob = pickedDate;
      dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  validateBasicInfoForm() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (basicInfoFormKey.currentState!.validate()) {
      if (isUserExists.value) {
        return;
      }

      if (selectedGender == null) {
        AppAlerts.alert(message: 'message_select_gender'.tr);
        return;
      }

      if (selectedInterestedIn == null) {
        AppAlerts.alert(message: 'message_select_interested_gender'.tr);
        return;
      }

      Get.toNamed(AppRoutes.routeSetupProfileImagesScreen);
    }
  }

  validatePicturesForm() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (profileImage.value == null) {
      AppAlerts.alert(message: 'message_add_profile_image'.tr);
      return;
    }

    if (additionalImages.length < 2) {
      AppAlerts.alert(message: 'minimum_2_images_gallery_required'.tr);
      return;
    }

    Get.toNamed(AppRoutes.routeSetupAdditionalInfoScreen);
  }

  validateAdditionalInfoForm() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (additionalInfoFormKey.currentState!.validate()) {
      try {
        Map<String, dynamic> requestBody = {
          "fullName": nameController.text.toString().trim(),
          "userName": userNameController.text.toString().trim(),
          "dob": dobController.text.toString().trim(),
          "gender": AppConsts.genderValuesMap[selectedGender],
          "interestedIn": AppConsts.interestedInValuesMap[selectedInterestedIn],
          "image": profileImage.value,
          "gallery": additionalImages,
          "worksAt": workAtController.text.toString().trim(),
          "School": schoolController.text.toString().trim(),
          "livesIn": livesInController.text.toString().trim(),
          "from": fromController.text.toString().trim(),
          "aboutMe": aboutMeController.text.toString().trim(),
          "age": {
            'min': ageRangeValues.value.start,
            'max': ageRangeValues.value.end,
          },
          "distance": distancePreferenceValue.value
        };

        debugPrint("update_profile_request_body  =$requestBody");

        CommonLoader.show();
        var result = await PutRequests.updateProfile(requestBody);
        CommonLoader.dismiss();
        if (result != null) {
          if (result.success) {
            Get.offAllNamed(AppRoutes.routeIntroVideoGuidelineScreen,
                arguments: {
                  AppConsts.keyRecordVideoFor: RecordVideoFor.profileSetup
                });
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

  showGenderOptions(Function(String gender) onChange) {
    CommonOptionsBottomSheet.show(options: [
      OptionModel('man'.tr, () {
        onChange('man');
      }),
      OptionModel('woman'.tr, () {
        onChange('woman');
      }),
      OptionModel('non_binary'.tr, () {
        onChange('non_binary');
      })
    ]);
  }

  showInterestedInOptions(Function(String interestedIn) onChange) {
    CommonOptionsBottomSheet.show(options: [
      OptionModel('men'.tr, () {
        onChange('men');
      }),
      OptionModel('women'.tr, () {
        onChange('women');
      }),
      OptionModel('everyone'.tr, () {
        onChange('everyone');
      })
    ]);
  }
}

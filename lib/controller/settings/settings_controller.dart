import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/model/common_options_model.dart';
import 'package:streax/model/user.dart';
import 'package:streax/network/get_requests.dart';
import 'package:streax/network/put_requests.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/preference_manager.dart';
import 'package:streax/views/dialogs/common/common_alert_dialog.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';



class SettingsController extends GetxController {

  final RxBool isLoading = false.obs;

  final RefreshController refreshController = RefreshController(initialRefresh: false);

  late List<OptionModel> settingOptions;

  Rx<Gender?> interestedIn = Rx<Gender?>(null);

  Rx<SfRangeValues> ageRangeValues = Rx<SfRangeValues>(AppConsts.defaultAgeRange);
  Rx<num> distancePreferenceValue =
      Rx<num>(AppConsts.defaultDistanceValue);

  Worker? ageChangeWorker;
  Worker? distanceChangeWorker;



  RxInt oneTimeInstantChatLeft =0.obs;
  RxInt oneTimeCrushLeft =0.obs;
  RxInt oneTimeCenterStageLeft = 0.obs;
 RxInt oneTimeDateRequestsLeft = 0.obs;

 Rx<Subscription?> userSubscription = Rx<Subscription?>(null);





  @override
  void onInit() {
    super.onInit();
    initOptions();
    setupProfileData();
    initWorkers();
  }

  @override
  void onClose() {
    disposeWorkers();
    super.onClose();
  }

  setupProfileData() {
    User? user = PreferenceManager.user;

    debugPrint("User = $user");
    if (user == null) return;

    oneTimeInstantChatLeft.value = user.instantChat??0;
    oneTimeCrushLeft.value = user.crush??0;
    oneTimeCenterStageLeft.value = user.centerStage??0;
    oneTimeDateRequestsLeft.value = user.dateRequest??0;
    userSubscription.value = user.subscription;

    interestedIn.value = user.interestedIn;

    debugPrint("interestedIn = ${interestedIn.value}");
    distancePreferenceValue.value =
        user.distance ?? AppConsts.defaultDistanceValue.toDouble();
    Range? ageRange = user.age;


    if (ageRange != null && ageRange.min != null && ageRange.max != null) {
      ageRangeValues.value =
          SfRangeValues(ageRange.min?.toDouble(), ageRange.max?.toDouble());
    }
    refreshController.refreshCompleted();
  }




  initWorkers() {
    ageChangeWorker = debounce(ageRangeValues, (callback) => updateAge());
    distanceChangeWorker =
        debounce(distancePreferenceValue, (callback) => updateDistance());
  }

  disposeWorkers() {
    ageChangeWorker?.dispose();
    distanceChangeWorker?.dispose();
  }




  void initOptions() {
    settingOptions = [
      OptionModel('notifications',
          () => Get.toNamed(AppRoutes.routeNotificationsSettingScreen)),
      OptionModel(
          'blocked', () => Get.toNamed(AppRoutes.routeBlockedUsersScreen)),
      if (PreferenceManager.user?.loginType == LoginType.manual) OptionModel(
          'change_password', () => Get.toNamed(AppRoutes.routeChangePassword)),

      //todo work on email and mobile update in Phase 2
      // OptionModel('update_mobile_number',
      //     () => Get.toNamed(AppRoutes.routeUpdateMobileNumberScreen)),

      OptionModel(
          'legal_notice', () => Get.toNamed(AppRoutes.routeLegalNoticeScreen)),
      OptionModel('delete_account',
          () => Get.toNamed(AppRoutes.routeDeleteAccountScreen)),

      OptionModel(
          'Logout', () => showLogoutDialog()),
      // OptionModel('App Version 1.0', () {}),
    ];
  }





  updateInterest() {
    Map<String, dynamic> requestBody = {
      'interestedIn': interestedInValues.reverse[interestedIn.value]
    };
    updateProfile(requestBody);
  }

  updateAge() {
    Map<String, dynamic> requestBody = {
      "age": {
        'min': ageRangeValues.value.start,
        'max': ageRangeValues.value.end,
      }
    };
    updateProfile(requestBody);
  }

  updateDistance() {
    Map<String, dynamic> requestBody = {
      "distance": distancePreferenceValue.value
    };

    updateProfile(requestBody);
  }

  Future<void> updateProfile(Map<String, dynamic> requestBody) async {
    try {
      var result = await PutRequests.updateProfile(requestBody);
      if (result != null) {
        if (result.success) {
          PreferenceManager.user = result.user;
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } on Exception catch (e) {
      debugPrint("Exception while updating user profile==> $e");
    }
  }

  showLogoutDialog() {
    CommonAlertDialog.showDialog(
        title: '${'logout'.tr}?',
        message: 'message_logout'.tr,
        negativeText: 'logout'.tr,
        positiveText: 'dismiss'.tr,
        negativeBtCallback: () {
          Get.back();
          logout();
        },
        positiveBtCallback: () {
          Get.back();
        });
  }

  logout() async{

    try{
      isLoading.value = true;
      var result = await GetRequests.logout();
      if(result !=null){
        if(result.success){
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            PreferenceManager.token =null;
            PreferenceManager.user = null;
            Get.offAllNamed(AppRoutes.routeSignInScreen);
          });
        }else{
          AppAlerts.error(message: result.message);
        }

      }else{
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    }finally{

      isLoading.value = false;
    }

  }
}

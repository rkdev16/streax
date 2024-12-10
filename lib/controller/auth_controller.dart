import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/model/user.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/preference_manager.dart';
import 'package:streax/views/dialogs/common/common_loader.dart';

class AuthController extends GetxController {
  late GoogleSignIn _googleSignIn;
  final storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    _googleSignIn = GoogleSignIn();
  }

  loginWithApple() async {
    try {
      var email = await storage.read(key: 'email');
      var fullName = await storage.read(key: 'fullName');
      var userIdentifier = await storage.read(key: 'userIdentifier');

      Map<String, dynamic> requestBody = {};

      if (email == null && fullName == null) {
        var isAvailable = await SignInWithApple.isAvailable();
        if (isAvailable) {
          AuthorizationCredentialAppleID credential =
              await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );

          var email = credential.email;
          var fullName =
              '${credential.givenName ?? ""} ${credential.familyName ?? ""}'
                  .trim();
          debugPrint('Email = $email');
          debugPrint('FullName = $fullName');
          await storage.write(key: 'email', value: email);
          await storage.write(key: 'fullName', value: fullName);
          await storage.write(
              key: 'userIdentifier', value: credential.userIdentifier);

          if (credential.email != null) {
            requestBody.assignAll({
              'email': credential.email,
              "login_type": loginTypeValues.reverse[LoginType.apple],
              "social_id": credential.userIdentifier,
            });
            PreferenceManager.user?.fullName = credential.givenName;

            debugPrint("requestBody  =$requestBody");

            socialSignIn(requestBody, credential.givenName);
          }
        } else {
          AppAlerts.alert(message: 'message_apple_sign_in_no_available');
        }
      } else {
        requestBody.assignAll({
          'email': email,
          "loginType": loginTypeValues.reverse[LoginType.apple],
          "socialId": userIdentifier,
        });
      }

      debugPrint("RequestBody = $requestBody");
      socialSignIn(requestBody, fullName);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  void loginUsingGoogle() async {
    await _googleSignIn.signOut();

    try {

      GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();
      if (googleAccount != null) {
        debugPrint("Google_Signin_account = $googleAccount");
        Map<String, dynamic> requestBody = {
          'email': googleAccount.email,
          "loginType": loginTypeValues.reverse[LoginType.google],
          "socialId": googleAccount.id,
        };
        PreferenceManager.user?.fullName = googleAccount.displayName;
        socialSignIn(requestBody, googleAccount.displayName);
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }
  void socialSignIn(Map<String, dynamic> requestBody, name) async {
    debugPrint("socialLoginRequest = $requestBody");

    try {
      CommonLoader.show();
      var response = await PostRequests.socialSignIn(requestBody);
      CommonLoader.dismiss();
      if (response != null) {
        if (response.success) {
          saveDataToPref(response.user!);

          debugPrint("Token = ${PreferenceManager.token}");
          debugPrint("UserName = ${response.user?.userName}");

          if (response.user?.userName == null) {
            Get.offNamed(AppRoutes.routeSetupBasicInfoScreen, arguments: {
              'displayName' : name
            });
          } else {
            debugPrint("Else Executed");
            Get.offNamed(AppRoutes.routeDashBoardScreen);
          }
        } else {
          AppAlerts.error(message: response.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      CommonLoader.dismiss();
    }
  }

  void saveDataToPref(User? user) {
    PreferenceManager.userToken = user?.token;
    PreferenceManager.user = user;

  }
}

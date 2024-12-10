import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:streax/bindings/auth_binding.dart';
import 'package:streax/bindings/blocked_users_binding.dart';
import 'package:streax/bindings/custom_gallery_binding.dart';
import 'package:streax/bindings/edit_profile_binding.dart';
import 'package:streax/bindings/new_match_binding.dart';
import 'package:streax/bindings/public_profile_binding.dart';
import 'package:streax/bindings/report_binding.dart';
import 'package:streax/bindings/search_connections_binding.dart';
import 'package:streax/bindings/story_views_binding.dart';
import 'package:streax/bindings/update_mobile_binding.dart';
import 'package:streax/controller/connections/connections_controller.dart';
import 'package:streax/views/pages/chat/chat_requests_screen.dart';
import 'package:streax/views/pages/chat/chat_screen.dart';
import 'package:streax/views/pages/chat/recent_chat_dialogs_screen.dart';
import 'package:streax/views/pages/connections/connections_screen.dart';
import 'package:streax/views/pages/connections/search_connections_screen.dart';
import 'package:streax/views/pages/connections/view_all_connnections_screen.dart';
import 'package:streax/views/pages/dashboard/dashboard_screen.dart';
import 'package:streax/views/pages/location/request_location_permission_screen.dart';
import 'package:streax/views/pages/location/search_location_screen.dart';
import 'package:streax/views/pages/new_match/new_match_screen.dart';
import 'package:streax/views/pages/permium/one_time_purchase_screen.dart';
import 'package:streax/views/pages/permium/subscription_plans_screen.dart';
import 'package:streax/views/pages/profile/edit_profile_screen.dart';
import 'package:streax/views/pages/forgot_password/reset_password_screen.dart';
import 'package:streax/views/pages/forgot_password/password_changed_screen.dart';
import 'package:streax/views/pages/legal_notice/legal_notice_screen.dart';
import 'package:streax/views/pages/profile/public_profile_screen.dart';
import 'package:streax/views/pages/profile_setup/intro_video_guideline_screen.dart';
import 'package:streax/views/pages/profile_setup/setup_basic_info_screen.dart';
import 'package:streax/views/pages/profile_setup/video_playback_screen.dart';
import 'package:streax/views/pages/report/report_screen.dart';
import 'package:streax/views/pages/settings/block/bocked_users_screen.dart';
import 'package:streax/views/pages/settings/settings_screen.dart';
import 'package:streax/views/pages/settings/update_mobile_screen.dart';
import 'package:streax/views/pages/splash/splash_screen.dart';
import 'package:streax/views/pages/story/share_story_screen.dart';
import 'package:streax/views/pages/story/story_viewer_pager_screen.dart';
import 'package:streax/views/pages/story/story_views_screen.dart';
import '../bindings/change_password_binding.dart';
import '../bindings/dashboard_binding.dart';
import '../bindings/delete_account_binding.dart';
import '../bindings/forgot_password_binding.dart';
import '../bindings/notification_binding.dart';
import '../bindings/otp_verification_binding.dart';
import '../bindings/profile_setup_binding.dart';
import '../bindings/subscriptions_binding.dart';
import '../bindings/signin_binding.dart';
import '../bindings/signup_binding.dart';
import '../views/pages/change_password/change_password_screen.dart';
import '../views/pages/delete_account/delete_account_screen.dart';
import '../views/pages/forgot_password/forgot_password_screen.dart';
import '../views/pages/get_started/get_started_screen.dart';
import '../views/pages/notifications/notifications_screen.dart';
import '../views/pages/notifications/notifications_setting_screen.dart';
import '../views/pages/otp_verification/otp_verification_screen.dart';
import '../views/pages/profile_setup/setup_profile_images_screen.dart';
import '../views/pages/profile_setup/setup_additional_info_screen.dart';
import '../views/pages/signin/signIn_screen.dart';
import '../views/pages/signup/signup_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const int _transitionDuration = 400;

  static var pages = <GetPage>[
    GetPage(
        name: AppRoutes.routeSignUpScreen,
        page: () => SignUpScreen(),
        bindings:[
          SignUpBinding(),
          AuthBinding()
        ] ,
        curve: Curves.ease,
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeSignInScreen,
        page: () => SignInScreen(),
        bindings:[
          SignInBinding(),
          AuthBinding()
        ] ,
        curve: Curves.ease,
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeForgotPasswordScreen,
        page: () => ForgotPasswordScreen(),
        binding: ForgotPasswordBinding(),
        curve: Curves.ease,
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeOtpVerificationScreen,
        page: () => OtpVerificationScreen(),
        binding: OtpVerificationBinding(),
        curve: Curves.ease,
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.resetPasswordScreen,
        page: () => ResetPasswordScreen(),
        binding: ForgotPasswordBinding(),
        curve: Curves.ease,
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeGetStartedScreen,
        page: () => const GetStartedScreen(),
        //  binding: DashboardBinding(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routePasswordChangedScreen,
        page: () => const PasswordChangedScreen(),
        //  binding: DashboardBinding(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeEmailSignUpScreen,
        page: () => SignUpScreen(),
        //  binding: DashboardBinding(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),


    GetPage(
        name: AppRoutes.routeSetupBasicInfoScreen,
        page: () => const SetupBasicInfoScreen(),
        binding: ProfileSetupBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),


    GetPage(
        name: AppRoutes.routeSetupProfileImagesScreen,
        page: () =>  SetupProfileImagesScreen(),
        binding: ProfileSetupBinding(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeSetupAdditionalInfoScreen,
        page: () => SetupAdditionalInfo(),
        binding: ProfileSetupBinding(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    // GetPage(
    //     name: AppRoutes.routeRecordIntroScreen,
    //     page: () => const RecordIntroScreen(),
    //     transition: Transition.rightToLeft,
    //     curve: Curves.ease,
    //     transitionDuration: const Duration(milliseconds: _transitionDuration)),


    GetPage(
        name: AppRoutes.routeVideoPlaybackScreen,
        page: () => const VideoPlaybackScreen(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeDashBoardScreen,
        page: () => DashBoardScreen(),
        binding: DashBoardBinding(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeNotificationsSettingScreen,
        page: () => const NotificationsSettingScreen(),
        binding: NotificationBindings(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeChangePassword,
        page: () => ChangePasswordScreen(),
        binding: ChangePasswordBinding(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeLegalNoticeScreen,
        page: () => const LegalNoticeScreen(),
        //  binding: DashBoardBinding(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeDeleteAccountScreen,
        page: () => DeleteAccountScreen(),
          binding: DeleteAccountBinding(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeUpdateMobileNumberScreen,
        page: () => UpdateMobileScreen(),
        binding: UpdateMobileBinding(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeSplashScreen,
        page: () => const SplashScreen(),
        //  binding: SignUpBinding(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeViewAllConnectionsScreen,
        page: () =>  const ViewAllConnectionsScreen(),
        binding: BindingsBuilder((){
          Get.lazyPut(() => ConnectionsController());
        }),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeEditProfileScreen,
        page: () => const EditProfileScreen(),
        binding: EditProfileBinding(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeOneTimePurchaseScreen,
        page: () => OneTimePurchaseScreen(),
        binding: SubscriptionsBinding(),
        transition: Transition.downToUp,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),

    GetPage(
        name: AppRoutes.routeSubscriptionPlansScreen,
        page: () => SubscriptionPlansScreen(),
         binding: SubscriptionsBinding(),
        transition: Transition.downToUp,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeStoriesScreen,
        page: () =>  ConnectionsScreen(),
        binding: DashBoardBinding(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),
    GetPage(
        name: AppRoutes.routeRecentChatDialogsScreen,
        page: () =>  const RecentChatDialogsScreen(),
        binding:DashBoardBinding(),
        transition: Transition.leftToRight,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),



    GetPage(
        name: AppRoutes.routeChatScreen,
        page: () =>  const ChatScreen(),
        transition: Transition.leftToRight,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),

    GetPage(
        name: AppRoutes.routeNotificationScreen,
        page: () =>  NotificationsScreen(),
        //binding: InstantChatBinding(),
        transition: Transition.leftToRight,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),


    // GetPage(
    //     name: AppRoutes.routeCustomGalleryScreen,
    //     page: () =>  CustomGalleryScreen(),
    //     binding: CustomGalleryBinding(),
    //     transition: Transition.downToUp,
    //     curve: Curves.ease,
    //     transitionDuration: const Duration(milliseconds: _transitionDuration)),


    GetPage(
        name: AppRoutes.routeShareStoryScreen,
        page: () =>  ShareStoryScreen(),
        transition: Transition.downToUp,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),


    GetPage(
        name: AppRoutes.routeStoryViewerPagerScreen,
        page: () =>  StoryViewerPagerScreen(),
        binding: DashBoardBinding(),
        transition: Transition.downToUp,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),


    GetPage(
        name: AppRoutes.routeNewMatchScreen,
        page: () =>  NewMatchScreen(),
        binding: NewMatchBinding(),
        transition: Transition.downToUp,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),


    GetPage(
        name: AppRoutes.routeStoryViewersScreen,
        page: () =>  StoryViewsScreen(),
        binding: StoryViewsBinding(),
        transition: Transition.leftToRight,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),



    GetPage(
        name: AppRoutes.routeReportScreen,
        page: () =>  ReportScreen(),
        binding: ReportBinding(),
        transition: Transition.downToUp,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),

    GetPage(
        name: AppRoutes.routeBlockedUsersScreen,
        page: () =>  BlockedUsersScreen(),
        binding: BlockedUsersBinding(),
        transition: Transition.leftToRight,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),

    GetPage(
        name: AppRoutes.routePublicProfileScreen,
        page: () =>   PublicProfileScreen(),
        binding: PublicProfileBinding(),
        transition: Transition.leftToRight,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),

    GetPage(
        name: AppRoutes.routeSettingsScreen,
        page: () =>   SettingsScreen(),
        binding: DashBoardBinding(),
        transition: Transition.leftToRight,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),

    GetPage(
        name: AppRoutes.routeRequestLocationPermissionScreen,
        page: () =>   RequestLocationPermissionScreen(),
        binding: DashBoardBinding(),
        transition: Transition.downToUp,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),

    GetPage(
        name: AppRoutes.routeSearchLocationScreen,
        page: () =>   SearchLocationScreen(),
        binding: DashBoardBinding(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),

    GetPage(
        name: AppRoutes.routeIntroVideoGuidelineScreen,
        page: () => const   IntroVideoGuidelineScreen(),
        binding: CustomGalleryBinding(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),


    GetPage(
        name: AppRoutes.routeSearchConnectionsScreen,
        page: () =>    SearchConnectionsScreen(),
        binding: SearchConnectionsBinding(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),

    GetPage(
        name: AppRoutes.routeChatRequestsScreen,
        page: () =>    ChatRequestsScreen(),
        binding: DashBoardBinding(),
        transition: Transition.rightToLeft,
        curve: Curves.ease,
        transitionDuration: const Duration(milliseconds: _transitionDuration)),


  ];
}

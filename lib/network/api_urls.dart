class ApiUrls {
  ApiUrls._();


  static const String baseUrl = "<API URL>";

  static const String privacyPolicy = "<PRIVACY POLICY>";
  static const String termsOfUse = "<TERMS OF USE>";
  static const String checkEmailExist = "api/user/check/email";
  static const String checkMobileExist = "api/user/check/mobile";
  static const String checkUsernameExists = "api/user/check/username";
  static const String requestOtpEmail = "api/user/otp-request/email";
  static const String requestOtpMobile = "api/user/otp-request/mobile";
  static const String registerWithEmail = "api/user/register/email";
  static const String registerWithMobile = "api/user/register/mobile";
  static const String uploadFiles = "api/user/upload-files";
  static const String updateProfile = "api/user";
  static const String fetchProfile = "api/user";
  static const String login = "api/user/login";
  static const String socialLogin = "api/user/social-login";
  static const String forgotPassword = "api/user/forgot-password";
  static const String resetPassword = "api/user/reset-password";
  static const String profileSuggestions = "api/user/suggested";
  static const String toggleLike = "api/user/like-unlike/";
  static const String fetchConnections = "api/user/connection";
  static const String postStory = "api/user/story";
  static const String fetchMyStories = "api/user/my-stories";
  static const String fetchConnectionsStories = "api/user/connections-stories";
  static const String deleteStory = "api/user/story/";
  static const String viewStory = "api/user/story-view"; //increase the view count of other person
  static const String blockUnblock = "api/user/block-unblock";
  static const String reportUser = "api/user/report";
  static const String superLike = "api/user/super-like/";
  static const String centerStage = "api/user/center-stage/";
  static const String chatDialogs = "api/user/dialogue";
  static const String chatRequests = "api/user/chat-request";
  static const String roomDetail = "api/user/room-detail/";
  static const String roomChat = "api/user/messages/";
  static const String sendMessage = "api/user/send-message/";
  static const String createRoom = "api/user/room/";
  static const String deleteMessage = "api/user/delete/";
  static const String sendHangoutRequest = "api/user/hangout-request/";
  static const String readMessages = "api/user/read-messages/";
  static const String blockedUsers = "api/user/blocked-users";
  static const String changePassword = "api/user/change-password";
  static const String sendOtpDeleteAccount = "api/user/otp";
  static const String deleteAccount = "api/user/delete-account";
  static const String logout = "api/user/logout";
  static const String publicProfile = "api/user/public-profile/";
  static const String searchConnections = "api/user/connection-search";
  static const String acceptChatRequest = "api/user/request";
  static const String oneTimePlans = "api/user/one-time-purchase";
  static const String subscriptionPlans = "api/user/plan";
  static const String updateOneTimePurchaseSuccess = "api/user/one-time-purchase/success";
  static const String updateSubscriptionPurchaseSuccess = "api/user/subscribe/android";
  static const String updateSubscriptionPurchaseSuccessIos = "api/user/subscribe/ios";
  static const String viewChatMedia = "api/user/media-view/";
  static const String notifications = "api/user/notifications";
  static const String notificationsCount = "api/user/notification-count";
  static const String notificationsReadAll = "api/user/notification-read-all/";
  static const String streakCount = "api/user/streakCreateAndBreak";

  static const String chatMessageCount = "api/user/unread-messages-count";
  static const String teamStreaxMessages = "api/user/announcement";

}

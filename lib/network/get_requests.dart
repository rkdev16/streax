import 'package:streax/model/base_res_model.dart';
import 'package:streax/model/blocked_users_res_model.dart';
import 'package:streax/model/chat_dialogs_res_model.dart';
import 'package:streax/model/chat_res_model.dart';
import 'package:streax/model/connections_res_model.dart';
import 'package:streax/model/create_room_res_model.dart';
import 'package:streax/model/delete_account_otp_res_model.dart';
import 'package:streax/model/my_stories_res_model.dart';
import 'package:streax/model/notification_count_res_model.dart';
import 'package:streax/model/notifications_res_model.dart';
import 'package:streax/model/one_time_purchases_res_model.dart';
import 'package:streax/model/room_detail_res_model.dart';
import 'package:streax/model/story/stories_res_model.dart';
import 'package:streax/model/profile_res_model.dart';
import 'package:streax/model/profile_suggestions_res_model.dart';
import 'package:streax/model/subscription_plans_res_model.dart';
import 'package:streax/model/super_like_res_model.dart';
import 'package:streax/model/toggle_like_res_model.dart';
import 'package:streax/model/users_res_model.dart';
import 'package:streax/network/api_urls.dart';
import 'package:streax/network/remote_services.dart';

class GetRequests {
  GetRequests._();

  static Future<ProfileResModel?> fetchUserProfile() async {
    var apiResponse = await RemoteService.simpleGet(ApiUrls.fetchProfile);

    if (apiResponse != null) {
      return profileResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<ProfileSuggestionsResModel?> fetchProfileSuggestions() async {
    var apiResponse = await RemoteService.simpleGet(ApiUrls.profileSuggestions);

    if (apiResponse != null) {
      return profileSuggestionsResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<ToggleLikeResModel?> toggleLike(String id) async {
    var apiResponse = await RemoteService.simpleGet(ApiUrls.toggleLike + id);

    if (apiResponse != null) {
      return toggleLikeResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<ConnectionsResModel?> fetchConnections() async {
    var apiResponse = await RemoteService.simpleGet(ApiUrls.fetchConnections);

    if (apiResponse != null) {
      return connectionsResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<MyStoriesResModel?> fetchMyStories() async {
    var apiResponse = await RemoteService.simpleGet(ApiUrls.fetchMyStories);

    if (apiResponse != null) {
      return myStoriesResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<StoriesResModel?> fetchConnectionsStories() async {
    var apiResponse =
        await RemoteService.simpleGet(ApiUrls.fetchConnectionsStories);

    if (apiResponse != null) {
      return storiesResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<SuperLikeResModel?> superLikeUser(String id) async {
    var apiResponse = await RemoteService.simpleGet(ApiUrls.superLike + id);

    if (apiResponse != null) {
      return superLikeResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<ChatDialogsResModel?> fetchChatDialogs() async {
    var apiResponse = await RemoteService.simpleGet(ApiUrls.chatDialogs);

    if (apiResponse != null) {
      return chatDialogsResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<ChatDialogsResModel?> streakCount() async {
    var apiResponse = await RemoteService.simpleGet(ApiUrls.streakCount);

    if (apiResponse != null) {
      return chatDialogsResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<ChatDialogsResModel?> fetchChatRequests() async {
    var apiResponse = await RemoteService.simpleGet(ApiUrls.chatRequests);

    if (apiResponse != null) {
      return chatDialogsResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<RoomDetailResModel?> fetchRoomDetail(String roomId) async {
    var apiResponse =
        await RemoteService.simpleGet(ApiUrls.roomDetail + roomId);

    if (apiResponse != null) {
      return roomDetailResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<ChatResModel?> fetchRoomChat(String roomId, int pageNo) async {
    var apiResponse = await RemoteService.simpleGet(
        "${ApiUrls.roomChat}$roomId?page=$pageNo");

    if (apiResponse != null) {
      return chatResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<ChatResModel?> teamStreaxChat() async {
    var apiResponse = await RemoteService.simpleGet(ApiUrls.teamStreaxMessages);

    if (apiResponse != null) {
      return chatResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<CreateRoomResModel?> createRoom(String userId) async {
    var apiResponse =
        await RemoteService.simpleGet(ApiUrls.createRoom + userId);
    if (apiResponse != null) {
      return createRoomResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<BaseResModel?> readMessages(String roomId) async {
    var apiResponse =
        await RemoteService.simpleGet(ApiUrls.readMessages + roomId);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<BlockedUsersResModel?> fetchBlockedUsers() async {
    var apiResponse = await RemoteService.simpleGet(ApiUrls.blockedUsers);

    if (apiResponse != null) {
      return blockedUsersResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<DeleteAccountOtpResModel?> sendOtpDeleteAccount() async {
    var apiResponse =
        await RemoteService.simpleGet(ApiUrls.sendOtpDeleteAccount);

    if (apiResponse != null) {
      return deleteAccountOtpResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<BaseResModel?> logout() async {
    var apiResponse = await RemoteService.simpleGet(ApiUrls.logout);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<BaseResModel?> viewStory(
      String? userId, String? storyId) async {
    var apiResponse = await RemoteService.simpleGet(
        "${ApiUrls.viewStory}?user=$userId&storyId=$storyId");
    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<ProfileResModel?> fetchPublicProfile(String userId) async {
    var apiResponse =
        await RemoteService.simpleGet(ApiUrls.publicProfile + userId);
    if (apiResponse != null) {
      return profileResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<UsersResModel?> searchConnections(String keyword) async {
    var apiResponse = await RemoteService.simpleGet(
        "${ApiUrls.searchConnections}?search=$keyword");
    if (apiResponse != null) {
      return usersResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<OneTimePurchasesResModel?> fetchOneTimePlans() async {
    var apiResponse = await RemoteService.simpleGet(ApiUrls.oneTimePlans);
    if (apiResponse != null) {
      return oneTimePurchasesResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<SubscriptionPlansResModel?> fetchSubscriptions() async {
    var apiResponse = await RemoteService.simpleGet(ApiUrls.subscriptionPlans);
    if (apiResponse != null) {
      return subscriptionPlansResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<NotificationsResModel?> fetchNotifications() async {
    var apiResponse = await RemoteService.simpleGet(ApiUrls.notifications);
    if (apiResponse != null) {
      return notificationsResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<NotificationCountResModel?> fetchNotificationsCount() async {
    var apiResponse = await RemoteService.simpleGet(ApiUrls.notificationsCount);
    if (apiResponse != null) {
      return notificationCountResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<MessageCountResModel?> fetchChatCount() async {
    var apiResponse = await RemoteService.simpleGet(ApiUrls.chatMessageCount);
    if (apiResponse != null) {
      return messageCountResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }
}

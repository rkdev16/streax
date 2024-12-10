import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/controller/chat/chat_controller.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:streax/controller/dashboard/dashboard_controller.dart';
import 'package:streax/model/chat_dialogs_res_model.dart';
import 'package:streax/model/user.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/helpers.dart';

import '../config/app_colors.dart';

class NotificationService {
  NotificationService._internal();

  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  bool _notificationsEnabled = false;

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      "high_importance_channel_streax", "High Importance Notifications Streax",
      description:
          'This channel is used for important notifications. for Streax',
      importance: Importance.high,
      playSound: true);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (Platform.isAndroid) {
      initAndroidSettings();
    } else if (Platform.isIOS) {
      initIOSSettings();
    }

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');

    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    /*  var androidDetail = AndroidNotificationDetails(
      channel.id,
      channel.name,
    );

    var iosDetail = const DarwinNotificationDetails();
    var generalNotificationDetail =
        NotificationDetails(android: androidDetail, iOS: iosDetail);
*/
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        debugPrint("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          if (message.notification != null) {
            debugPrint(message.notification!.title);
            debugPrint(message.notification!.body);
            if (message.data['type'] == 'CHAT') {
              Get.find<ChatController>().selectedChatDialog = ChatDialog(
                  fullName: message.data['name'],
                  image: message.data['image'],
                  roomId: message.data['roomId'],
                  iLiked: 1,
                  likedMe: 1);
              Get.toNamed(AppRoutes.routeChatScreen, arguments: {
                'isOnline':
                Get.find<ChatController>().selectedChatDialog?.isOnline ??
                    false
              });
            } else if (message.data['type'] == 'MUTUALLIKE') {
              Get.toNamed(AppRoutes.routeNewMatchScreen, arguments: {
                AppConsts.keyUser: User(
                  id: message.data['id'],
                  fullName: message.data['name'],
                  image: message.data['image'],
                  dob: message.data['dob'],
                )
              });
            } else if (message.data['type'] == 'LIKE' ||
                message.data['type'] == 'STORY') {
              Get.offAllNamed(AppRoutes.routeDashBoardScreen,
                  arguments: {'selectedTab': 3});
            }
          }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        debugPrint("--> Message  = ${message}");
        if (message.data['image'] != null) getImage(message);
        debugPrint("Message  =${message.data}");
        Future.delayed(const Duration(milliseconds: 200),
            () => showFlutterNotification(message));
        // showFlutterNotification(message);
        Get.find<DashBoardController>().fetchNotificationsCount();
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        debugPrint("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          debugPrint('====> ');

          debugPrint(message.notification!.title);
          debugPrint(message.notification!.body);
          if (message.data['type'] == 'CHAT') {
            Get.find<ChatController>().selectedChatDialog = ChatDialog(
                fullName: message.data['name'],
                image: message.data['image'],
                roomId: message.data['roomId'],
                iLiked: 1,
                likedMe: 1);
            Get.toNamed(AppRoutes.routeChatScreen, arguments: {
              'isOnline':
                  Get.find<ChatController>().selectedChatDialog?.isOnline ??
                      false
            });
          } else if (message.data['type'] == 'MUTUALLIKE') {
            Get.toNamed(AppRoutes.routeNewMatchScreen, arguments: {
              AppConsts.keyUser: User(
                id: message.data['id'],
                fullName: message.data['name'],
                image: message.data['image'],
                dob: message.data['dob'],
              )
            });
          } else if (message.data['type'] == 'LIKE' ||
              message.data['type'] == 'STORY') {
            Get.offAllNamed(AppRoutes.routeDashBoardScreen,
                arguments: {'selectedTab': 3});
          }
        }
      },
    );
  }

  Future<String> downloadAndSaveImage(String imageUrl) async {
    final response = await http.get(Uri.parse(Helpers.getCompleteUrl(imageUrl)));
    if (response.statusCode == 200) {
      final appDir = await getApplicationDocumentsDirectory();
      final File file = File('${appDir.path}/image.png');
      await file.writeAsBytes(response.bodyBytes);
      debugPrint('Image downloaded and saved at: ${file.path}');
      return file.path; // Return the local path of the saved image
    } else {
      throw Exception('Failed to download image');
    }
  }

  String imagePath = '';

  getImage(RemoteMessage message) async {
    imagePath = await downloadAndSaveImage(message.data['image']);
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            color: AppColors.kPrimaryColor,
            channelDescription: channel.description,
            styleInformation: /*message.data['image'] != null
                ? BigPictureStyleInformation(
                    FilePathAndroidBitmap(imagePath),
                    contentTitle: notification.body,
                  )
                :*/ BigTextStyleInformation(notification.body ?? ''),
            icon: '@drawable/ic_notification',
          ),
        ),
        payload: jsonEncode(message.data)
      );
    }
  }


  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    Map<String, dynamic> message = json.decode(notificationResponse.payload!);
    if (message.isNotEmpty) {
      if (message['type'] == 'CHAT') {
        Get.find<ChatController>().selectedChatDialog = ChatDialog(
            fullName: message['name'],
            image: message['image'],
            roomId: message['roomId'],
            iLiked: 1,
            likedMe: 1);
        Get.toNamed(AppRoutes.routeChatScreen, arguments: {
          'isOnline':
          Get.find<ChatController>().selectedChatDialog?.isOnline ??
              false
        });
      } else if (message['type'] == 'MUTUALLIKE') {
        Get.toNamed(AppRoutes.routeNewMatchScreen, arguments: {
          AppConsts.keyUser: User(
            id: message['id'],
            fullName: message['name'],
            image: message['image'],
            dob: message['dob'],
          )
        });
      } else if (message['type'] == 'LIKE' ||
          message['type'] == 'STORY') {
        Get.offAllNamed(AppRoutes.routeDashBoardScreen,
            arguments: {'selectedTab': 3});
      }
    }

  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    showDialog(
        context: Get.context!,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title ?? ''),
              content: Text(body ?? ''),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text("Ok"),
                  onPressed: () async {
                    /*  Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondScreen(payload),
                  ),
                );*/
                  },
                )
              ],
            ));
  }

  Future<void> cancelAllNotification() async {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> initAndroidSettings() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  Future<void> initIOSSettings() async {
    DarwinInitializationSettings initializationSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> _isAndroidPermissionsGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      _notificationsEnabled = granted;
    }
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? isGranted = await androidImplementation?.requestNotificationsPermission();
      _notificationsEnabled = isGranted ?? false;
    }
  }
}

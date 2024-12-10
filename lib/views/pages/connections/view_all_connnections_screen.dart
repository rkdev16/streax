import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/connections/connections_controller.dart';
import 'package:streax/model/user.dart';
import 'package:streax/views/pages/connections/component/connection_tile.dart';
import 'package:streax/views/widgets/common_app_bar.dart';

class ViewAllConnectionsScreen extends StatefulWidget {
  const ViewAllConnectionsScreen({super.key});

  @override
  State<ViewAllConnectionsScreen> createState() =>
      _ViewAllConnectionsScreenState();
}

class _ViewAllConnectionsScreenState extends State<ViewAllConnectionsScreen> {
  final _connections = Get.find<ConnectionsController>();

  ConnectionType? connectionType;

  getArguments() {
    Map<String, dynamic>? data = Get.arguments;
    if (data != null) {
      connectionType = data[AppConsts.keyConnectionsType];
    }
  }

  String getTitle() {
    switch (connectionType) {
      case ConnectionType.mutual:
        return 'matches'.tr;
      case ConnectionType.iLiked:
        return 'i_liked'.tr;
      case ConnectionType.likedMe:
        return 'liked_me'.tr;
      default:
        return '';
    }
  }

  RxList<User> getConnections() {
    switch (connectionType) {
      case ConnectionType.mutual:
        return _connections.mutual;
      case ConnectionType.iLiked:
        return _connections.iLiked;
      case ConnectionType.likedMe:
        return _connections.likedMe;
      default:
        return RxList();
    }
  }

  @override
  void initState() {
    super.initState();
    getArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: getTitle(),
        onBackTap: () {
          Get.back();
        },
      ),
      body: Obx(
        () => GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 230,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12),
            itemCount: getConnections().length,
            itemBuilder: (context, index) {
              return ConnectionTile(
                  user: getConnections()[index],
                  width: Get.width *0.45,
                  connectionType: connectionType ?? ConnectionType.iLiked);
            }),
      ),
    );
  }
}

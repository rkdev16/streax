import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/connections/connections_controller.dart';
import 'package:streax/controller/story/stories_controller.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/pages/connections/component/connections_section_widget.dart';
import 'package:streax/views/widgets/empty_screen_widget.dart';
import 'package:streax/views/widgets/shimmer/connections_screen_loading_widget.dart';

import '../../../config/size_config.dart';
import '../../../consts/app_icons.dart';
import '../../widgets/common_app_bar.dart';
import 'component/user_stories_widget.dart';

class ConnectionsScreen extends StatefulWidget {
  ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  final _storiesController = Get.find<StoriesController>();
  final _connectionsController = Get.find<ConnectionsController>();

  @override
  void initState() {
    super.initState();
    _connectionsController.getConnections();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Scaffold(
      appBar: CommonAppBar(
        leading: const SizedBox.shrink(),
        backgroundColor: Colors.white,
        systemUiOverlayStyle:
            SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white),
        title: 'stories'.tr,
        titleTextStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontSize: 28.fontMultiplier,
            color: AppColors.colorTextPrimary,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter'),
        leadingWidth: 16,
        centerTitle: false,
        actions: [
          // IconButton(
          //     padding: const EdgeInsets.only(right: 8),
          //     onPressed: () {},
          //     icon: SvgPicture.asset(
          //       AppIcons.icNotifications,
          //       height: 24,
          //       colorFilter:
          //           const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          //     )),
          IconButton(
              padding: const EdgeInsets.only(right: 16),
              onPressed: () {
                Get.toNamed(AppRoutes.routeSearchConnectionsScreen);
              },
              icon: SvgPicture.asset(
                AppIcons.icSearch,
                height: 24,
                colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              )),
        ],
      ),
      body: Obx(
        () => _connectionsController.isLoading.value
            ? const ConnectionsScreenLoadingWidget()
            : SmartRefresher(
                enablePullDown: true,
                controller: _connectionsController.refreshController,
                onRefresh: () {
                  debugPrint("onRefresh");
                  _connectionsController.getConnections();
                  _storiesController.getConnectionsStories();
                },
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Obx(
                        () => UserStoriesWidget(
                          stories: _storiesController.connectionStories.value,
                        ),
                      ),
                    ),
                    // show Empty Screen if mutual/iliked,liked me empty
                    if (_connectionsController.mutual.isEmpty &&
                        _connectionsController.iLiked.isEmpty &&
                        _connectionsController.likedMe.isEmpty)
                      EmptyScreenWidget(
                        height: SizeConfig.heightMultiplier * 70,
                      ),

                    Visibility(
                      visible: _connectionsController.mutual.isNotEmpty,
                      child: ConnectionsSectionWidget(
                          title: 'matches'.tr,
                          connections: _connectionsController.mutual,
                          connectionType: ConnectionType.mutual),
                    ),
                    Visibility(
                      visible: _connectionsController.likedMe.isNotEmpty,
                      child: ConnectionsSectionWidget(
                          title: 'liked_me'.tr,
                          connections: _connectionsController.likedMe,
                          connectionType: ConnectionType.likedMe),
                    ),
                    Visibility(
                      visible: _connectionsController.iLiked.isNotEmpty,
                      child: ConnectionsSectionWidget(
                          title: 'i_liked'.tr,
                          connections: _connectionsController.iLiked,
                          connectionType: ConnectionType.iLiked),
                    )
                  ],
                ),
              ),
      ),
    ));
  }
}

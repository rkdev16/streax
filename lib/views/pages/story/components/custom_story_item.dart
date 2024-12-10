import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/model/common_options_model.dart';
import 'package:streax/model/story/story.dart';
import 'package:streax/model/user.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/utils/preference_manager.dart';
import 'package:streax/views/bottomsheets/common_options_bottom_sheet.dart';
import 'package:streax/views/pages/story/components/my_story_bottom_bar.dart';
import 'package:streax/views/pages/story/components/story_action_widget.dart';
import 'package:streax/views/pages/story/components/story_view/story_controller.dart';
import 'package:streax/views/pages/story/components/story_view/story_image.dart';
import 'package:streax/views/pages/story/components/story_view/story_video.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';

class CustomStoryItem {
  /// Specifies how long the page should be displayed. It should be a reasonable
  /// amount of time greater than 0 milliseconds.
  final Duration duration;

  /// Has this page been shown already? This is used to indicate that the page
  /// has been displayed. If some pages are supposed to be skipped in a story,
  /// mark them as shown `shown = true`.
  ///
  /// However, during initialization of the story view, all pages after the
  /// last unshown page will have their `shown` attribute altered to false. This
  /// is because the next item to be displayed is taken by the last unshown
  /// story item.
  bool shown;
  User user;
  Story story;

  /// The page content
  final Widget view;

  CustomStoryItem(
    this.view, {
    this.shown = false,
    required this.user,
    required this.story,
    required this.duration,
  });

  /// Factory constructor for page images. [controller] should be same instance as
  /// one passed to the `StoryView`
  factory CustomStoryItem.content({
    required User user,
    required Story story,
    required StoryController controller,
    Key? key,
    BoxFit imageFit = BoxFit.contain,
    bool shown = false,
    Map<String, dynamic>? requestHeaders,
    Duration? duration,
  }) {
    return CustomStoryItem(
      Container(
        key: key,
        color: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  if (story.mediaType == MediaType.image)
                    StoryImage.url(
                      Helpers.getCompleteUrl(story.mediaUrl),
                      controller: controller,
                      fit: imageFit,
                      requestHeaders: requestHeaders,
                    ),
                  if (story.mediaType == MediaType.video)
                    StoryVideo.url(
                      Helpers.getCompleteUrl(story.mediaUrl),
                      controller: controller,
                      requestHeaders: requestHeaders,
                    ),
                  Container(
                    height: 140,
                    decoration:
                        BoxDecoration(gradient: AppColors.gradientStoryToolbar),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 140,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.fromBorderSide(BorderSide(
                                    color: AppColors.kPrimaryColor, width: 2))),
                            height: 60,
                            width: 60,
                            child: CommonImageWidget(
                              url: user.image ?? "",
                              borderRadius: 100,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    user.role == "ADMIN"
                                        ? (user.fullName ?? '')
                                        : (user.userName ?? "NA"),
                                    style: Theme.of(Get.context!)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                            fontSize: 14.fontMultiplier,
                                            color: Colors.white),
                                  ),
                                  Text(
                                    Helpers.getTimeAgo(story.time),
                                    style: Theme.of(Get.context!)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                            fontSize: 12.fontMultiplier,
                                            color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          user.id == PreferenceManager.user?.id ? SizedBox():  InkWell(
                            onTap: (){
                              CommonOptionsBottomSheet.show(options: [
                                OptionModel('report'.tr, () async {
                                  Get.toNamed(
                                      AppRoutes.routeReportScreen,
                                      arguments: {
                                        'story_id': story.id,
                                        AppConsts.keyUser: User(
                                            id: user.id,
                                            userName: user.userName,
                                            fullName: user.fullName)
                                      });
                                }),
                              ]);
                            },
                            borderRadius: BorderRadius.circular(100),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.more_vert_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            user.role == "ADMIN"
                ? Container()
                : (user.iLiked ?? 0) == 0 && (user.likedMe ?? 0) == 0
                    ? MyStoryBottomBar(
                        users: story.storyView ?? [],
                      )
                    : StoryActionWidget(
                        connectionType: Helpers.getConnectionType(user),
                        user: user,
                        story: story,
                      ),
          ],
        ),
      ),
      user: user,
      story: story,
      shown: shown,
      duration: duration ?? const Duration(seconds: 5),
    );
  }
}

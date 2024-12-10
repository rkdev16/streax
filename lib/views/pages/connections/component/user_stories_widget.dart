import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/controller/story/stories_controller.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/preference_manager.dart';
import 'package:streax/views/pages/story/components/custom_story_item.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';

class UserStoriesWidget extends StatelessWidget {
  const UserStoriesWidget({Key? key, required this.stories}) : super(key: key);

  final List<List<CustomStoryItem>> stories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            if (index == 0) {
              return AddStoryWidget();
            } else {
              return StoryWidget(
                stories: stories[index - 1],
                position: index - 1,
              );
            }
          },
          separatorBuilder: (context, index) {
            return const Gap(12);
          },
          itemCount: stories.length + 1),
    );
  }
}

class AddStoryWidget extends StatelessWidget {
  AddStoryWidget({super.key});

  final _storiesController = Get.find<StoriesController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoriesController>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              debugPrint('MyStories = ${_storiesController.myStories.isEmpty}');
              if (_storiesController.myStories.isEmpty) {
                _storiesController.pickMediaForPost();
              } else {
                Get.toNamed(AppRoutes.routeStoryViewerPagerScreen, arguments: {
                  AppConsts.keyIsMyStory: true,
                  AppConsts.keyStoriesData: _storiesController.myStories,
                });
              }
            },
            child: Stack(
              // fit: StackFit.expand,
              children: [
                Container(
                  width: 75,
                  height: 75,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(BorderSide(
                          color: _storiesController.myStories.isEmpty
                              ? Colors.transparent
                              : AppColors.kPrimaryColor,
                          width: 2))),
                  child: CommonImageWidget(
                    url: PreferenceManager.user?.image ?? '',
                    borderRadius: 100,
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: _storiesController.isLoadingPostStory.value,
                    child: const CommonProgressBar(
                      size: 75,
                      strokeWidth: 3,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      _storiesController.pickMediaForPost();
                    },
                    child: Container(
                        height: 28,
                        width: 28,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_circle_rounded,
                          color: AppColors.kPrimaryColor,
                          size: 28,
                        )),
                  ),
                ),
              ],
            ),
          ),
          const Gap(7),
          SizedBox(
            width: 80,
            child: Text(
              'add_story'.tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 12.fontMultiplier,
                  color: AppColors.colorTextPrimary),
            ),
          )
        ],
      );
    });
  }
}

class StoryWidget extends StatelessWidget {
  StoryWidget({
    super.key,
    required this.stories,
    required this.position,
  });

  final List<CustomStoryItem> stories;
  final int position;

  final _storiesController = Get.find<StoriesController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoriesController>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.routeStoryViewerPagerScreen, arguments: {
                AppConsts.keyIsMyStory: false,
                AppConsts.keyIndex: position,
                AppConsts.keyStoriesData: _storiesController.connectionStories,
              });
            },
            child: Container(
              width: 75,
              height: 75,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(BorderSide(
                      color: stories.isNotEmpty
                          ? (stories.last.story.seenStory ?? false)
                              ? Colors.grey
                              : AppColors.kPrimaryColor
                          : Colors.transparent,
                      width: 2))),
              child: CommonImageWidget(
                url: stories.first.user.image ?? "",
                borderRadius: 100,
              ),
            ),
          ),
          const Gap(7),
          SizedBox(
            width: 80,
            child: Text(
              stories.first.user.fullName ?? "",
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 12.fontMultiplier,
                  color: AppColors.colorTextPrimary),
            ),
          )
        ],
      );
    });
  }
}

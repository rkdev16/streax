
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/controller/connections/connections_controller.dart';
import 'package:streax/controller/story/stories_controller.dart';
import 'package:streax/views/pages/story/components/custom_story_item.dart';
import 'package:streax/views/pages/story/components/custom_story_view.dart';
import 'package:streax/views/pages/story/components/story_view/utils.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';

class StoryViewerWidget extends StatelessWidget {
  StoryViewerWidget({super.key,
  required this.isMyStory,
 required this.stories,
  });

  bool isMyStory =  false; // flag to check if viewing my story or another person story
  List<CustomStoryItem> stories;

  final _storiesController = Get.find<StoriesController>();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        body: Stack(
          children: [
            CustomStoryView(
                storyItems: stories,
                controller: _storiesController.storyController,
                onStoryShow: (s) {
                  _storiesController.currentShowingStory.value = s;
                  debugPrint('fdvdfvdfvdfv ${s.story.mediaUrl}');
                  //will get current showing storyItems
                },
                onPlay: () {
                  debugPrint("OnPlayCalled");
                  Get.find<StoriesController>().getConnectionsStories();
                  Get.find<StoriesController>().getMyStories();
                  Get.find<ConnectionsController>().getConnections();
                },
                onComplete: () {
                  debugPrint("OnCompleteCalled");
                 _storiesController.moveToNextPage(context,isMyStory);
                //  Navigator.pop(context);
                },
                onVerticalSwipeComplete: (direction) {
                  if (direction == Direction.down) {
                    Get.back(result: true);
                  }
                }),

            Obx(() => _storiesController.isLoading.value
                ? const CommonProgressBar()
                : const SizedBox.shrink())
          ],
        ),
      ),
    );
  }
}

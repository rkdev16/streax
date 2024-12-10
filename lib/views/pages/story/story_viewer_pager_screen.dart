import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/story/stories_controller.dart';
import 'package:streax/views/pages/story/components/custom_story_item.dart';
import 'package:streax/views/pages/story/components/story_viewer_widget.dart';

class StoryViewerPagerScreen extends StatefulWidget {
  StoryViewerPagerScreen({super.key});

  @override
  State<StoryViewerPagerScreen> createState() => _StoryViewerPagerScreenState();
}

class _StoryViewerPagerScreenState extends State<StoryViewerPagerScreen> {
  final _storiesController = Get.find<StoriesController>();

  bool isMyStory = false;
  // flag to check if viewing my story or another person story
  List<List<CustomStoryItem>> stories = [];
  ConnectionType connectionType = ConnectionType.mutual;
  int pageIndex = 0;

  late StreamSubscription<bool> keyboardSubscription;

  getArguments() {
    Map<String, dynamic>? data = Get.arguments;
    if (data != null) {
      isMyStory = data[AppConsts.keyIsMyStory];
      stories = data[AppConsts.keyStoriesData];
      pageIndex = data[AppConsts.keyIndex] ?? 0;

      debugPrint("PageIndex = $pageIndex");
    }
  }

  initKeyboardSubscription() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {
        _storiesController.storyController.pause();
      } else {
        _storiesController.storyController.play();
      }
      debugPrint("IsKeyboardVisible = $visible");
    });
  }

  disposeKeyboardSubscription() {
    keyboardSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    getArguments();
    _storiesController.storyPagesLength = stories.length;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _storiesController.pageController.jumpToPage(pageIndex);
    });
    initKeyboardSubscription();
  }

  @override
  void dispose() {
    disposeKeyboardSubscription();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      // StoryPageView(
      // itemBuilder: (context, pageIndex, storyIndex) {
      //   return
    //       Center(
    //       child: Column(
    //         children: [
    //           Text(
    //               "Index of PageView: $pageIndex Index of story on each page: $storyIndex"),
    //           Expanded(
    //             child: stories[pageIndex][storyIndex].story.mediaType ==
    //                     MediaType.image
    //                 ? CommonImageWidget(
    //                     url: Helpers.getCompleteUrl(
    //                         stories[pageIndex][storyIndex].story.mediaUrl),
    //                     height: double.infinity,
    //                     width: double.infinity,
    //                   )
    //                 : VideoWidget(
    //                     controller: CachedVideoPlayerController.network(
    //                        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4')),
    //           )
    //         ],
    //       ),
    //     );
    //   },
    //   storyLength: (pageIndex) {
    //     return stories[pageIndex].length;
    //   },
    //   pageLength: stories.length,
    // );

      PageView(

      controller: _storiesController.pageController,
        onPageChanged: (int index){
        _storiesController.currentStoryPageIndex = index;
        },
        children:
    List.generate(stories.length,
            (index) => StoryViewerWidget(
                isMyStory: isMyStory,
                stories: stories[index])));
  }
}

import 'package:get/get.dart';
import 'package:streax/controller/story/story_views_controller.dart';

class StoryViewsBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut(() => StoryViewsController());
  }

}
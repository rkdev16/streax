
import 'package:get/get.dart';
import 'package:streax/utils/custom_gallery/media_picker_controller.dart';

class CustomGalleryBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut(() => MediaPickerController());
  }

}
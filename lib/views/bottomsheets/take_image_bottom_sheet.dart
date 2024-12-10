import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/common_button.dart';

enum ImageSourceOptions { camera, gallery }
class TakeImageBottomSheet{
  static show ({ required BuildContext context , required Function(ImageSource) imageSource}){
    Get.bottomSheet(TakeImageBottomSheetContent(imageSource:imageSource ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(24))
      )
    );
    
  }
  
}



class TakeImageBottomSheetContent extends StatelessWidget {
  TakeImageBottomSheetContent({
    super.key,
    required this.imageSource,
  });
  Function(ImageSource) imageSource;



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonButton(
              margin: const EdgeInsets.only(
                  top: 30, left: 16, right: 16, bottom: 8),
              text: 'take_a_photo'.tr,
              onPressed: () {
                imageSource(ImageSource.camera);
                //_myProfileController.pickImage(ImageSource.camera);
              }),
          CommonButton(
              margin: const EdgeInsets.only(
                  top: 20, left: 16, right: 16, bottom: 8),
              text: 'choose_from_gallery'.tr,
              onPressed: () {
                imageSource(ImageSource.gallery);
                //  _myProfileController.pickImage(ImageSource.gallery);
              }),
          CommonButton(
              margin: const EdgeInsets.only(
                  top: 20, left: 16, right: 16, bottom: 30),
              text: 'cancel'.tr,
              onPressed: () {
                Navigator.of(context).pop(true);
              }),
        ],
      ),
    );
  }
}

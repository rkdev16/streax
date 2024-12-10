import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/utils/extensions/extensions.dart';


enum ImageSourceOptions{
  camera,gallery
}

class PickImageOptionsBottomSheet {
  static show({required BuildContext context, required Function(ImageSource) imageSource}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return PickImageOptionsBottomSheetContent(imageSource: imageSource,);
          },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))));
  }
}

class PickImageOptionsBottomSheetContent extends StatelessWidget {
 const  PickImageOptionsBottomSheetContent({
     super.key,
    required this.imageSource
   });

 final  Function(ImageSource) imageSource;

  @override
  Widget build(BuildContext context) {
    return
      Container(
        padding: const  EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [


          Container(
            width: 126,
            height: 8,
            margin: const  EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
            color: AppColors.colorF3,
              borderRadius: BorderRadius.circular(24)
          ),),


          optionWidget(context, 'launch_camera'.tr, AppIcons.icCameraFilled, () {
            Navigator.of(context).pop();
            imageSource(ImageSource.camera);
          }),


         const  Divider(
            thickness: 0.5,
            indent: 24,
            endIndent: 24,
            color: AppColors.colorF3,
          ),

          optionWidget(context, 'upload_from_gallery'.tr, AppIcons.icGallery, () {
            Navigator.of(context).pop();
            imageSource(ImageSource.gallery);
          }),



          













        ],
      ),
    );
  }


  Widget optionWidget(
      BuildContext context,
      String title,
      String icon,
      VoidCallback onTap
      ){
    return  GestureDetector(
    onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon,color: Colors.red,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(title,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 16.fontMultiplier,
                  color: AppColors.colorTextPrimary,
                  fontWeight: FontWeight.w600
              ),),
            )
          ],),
      ),


    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:streax/consts/app_images.dart';
import 'package:streax/controller/profile_setup/profile_setup_controller.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/views/bottomsheets/pick_image_options_bottom_sheet.dart';
import 'package:streax/views/pages/profile_setup/components/common_bg_profile_setup.dart';
import 'package:streax/views/widgets/Image_grid_tile.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';
import '../../../config/app_colors.dart';
import '../../../consts/app_icons.dart';


class SetupProfileImagesScreen extends StatelessWidget {
   SetupProfileImagesScreen({super.key});

  final _profileSetupController = Get.find<ProfileSetupController>();

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: CommonBgProfileSetup(
        pageNo: 2,
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
                child: Text(
                  "set_your_profile".tr,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 16.fontMultiplier,
                    color: AppColors.colorTextPrimary,
                    fontWeight: FontWeight.w700

                      ),
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const  Duration(milliseconds: 400),
              child: Stack(
                children: [
                  Center(
                    child: Obx(() => CommonImageWidget(
                        width: 110,
                        height: 110,
                        borderRadius: 100,
                       errorPlaceholder: AppImages.imgUserPlaceHolder,
                        url: Helpers.getCompleteUrl(
                           _profileSetupController.profileImage.value))),
                  ),



                  Positioned.fill(
                    top: 70,
                    left: 70,
                    child: IconButton(
                        onPressed: () {
                          PickImageOptionsBottomSheet.show(
                              context: context,
                              imageSource:(ImageSource source) async{
                                String? pickedImagePath = await _profileSetupController.picImage(source);

                                if(pickedImagePath !=null){
                                  List<String> uploadedFiles = await _profileSetupController.uploadFile(pickedImagePath);
                                  if(uploadedFiles.isNotEmpty){
                                    _profileSetupController.profileImage.value = uploadedFiles.first;
                                  }
                                }
                              });
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.kPrimaryColor),
                          child:
                          SvgPicture.asset(AppIcons.icCameraFilled,colorFilter: const  ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                        )),
                  )
                ],
              ),
            ),



            CommonCardWidget(
              margin: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 24.0),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 250
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("add_more".tr,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.fontMultiplier,
                          color: AppColors.colorTextPrimary
                        )),


                    Text("minimum_2_images_gallery_required".tr,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall?.copyWith(
                            fontSize: 10.fontMultiplier,
                            color: AppColors.colorTextSecondary
                        )),





                    Obx(
                    ()=> GridView.builder(
                      padding: const  EdgeInsets.symmetric(vertical: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            mainAxisExtent: 140
                        ),

                        physics: const  NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context,index){
                        if( index == 0){
                            return GestureDetector(
                              onTap: (){
                                PickImageOptionsBottomSheet.show(
                                    context: context,
                                    imageSource: (ImageSource source) async{
                                      String ? pickedImagePath = await _profileSetupController.picImage(source);

                                      if(pickedImagePath !=null){
                                        List<String> uploadedFiles = await _profileSetupController.uploadFile(pickedImagePath);
                                        if(uploadedFiles.isNotEmpty){
                                          _profileSetupController.additionalImages.addAll(uploadedFiles);
                                          _profileSetupController.additionalImages.refresh();
                                        }
                                      }


                                    });
                              },
                                child: SvgPicture.asset(AppImages.imgAddPhoto2,fit: BoxFit.fill,));
                          }else{
                              var image =  _profileSetupController.additionalImages[index - 1 ];
                              return ImageGridTile(url: image,onRemoveTap: (){
                                _profileSetupController.additionalImages.removeAt(index -1);
                              },);
                                /*Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  CommonImageWidget(url:image,borderRadius: 4,),
                                  GestureDetector(onTap: (){

                                    _profileSetupController.additionalImages.removeAt(index -1);
                                    }, child: const  Icon(Icons.remove_circle,color: Colors.red,))
                                ],
                              );*/
                            }
                          },
                        itemCount:  _profileSetupController.additionalImages.length +1,

                      ),
                    ),

                  ],
                ),
              ),
            ),



            CommonButton(
                text: 'next'.tr,
                margin: const  EdgeInsets.only(left: 16,right: 16,bottom: 24),
                onPressed: (){
              _profileSetupController.validatePicturesForm();
            })

          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/consts/app_images.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/profile/edit_profile_controller.dart';
import 'package:streax/controller/profile/profile_controller.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/custom_painters/custom_shape.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/validations.dart';
import 'package:streax/views/bottomsheets/pick_image_options_bottom_sheet.dart';
import 'package:streax/views/pages/media_preview/media_preview_screen.dart';
import 'package:streax/views/pages/profile/components/intro_video_widget.dart';
import 'package:streax/views/widgets/Image_grid_tile.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';
import 'package:streax/views/widgets/common_input_feilds.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _editProfileController = Get.find<EditProfileController>();

  @override
  void initState() {
    super.initState();
    _editProfileController.isProfileUpdated = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_editProfileController.isProfileUpdated) {
          Get.find<ProfileController>().getUserProfile();
        }

        return Future(() => true);
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: AppColors.kPrimaryColor),
        child: Scaffold(
            body: CustomScrollView(
          slivers: [

            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
                  statusBarColor: AppColors.kPrimaryColor
              ),
              leading: IconButton(onPressed: (){
                Get.back();
              },
                  icon: SvgPicture.asset(AppIcons.icBack)),
              backgroundColor: AppColors.backgroundColor,
              title: Text('edit_profile'.tr),
              expandedHeight: 290,
              centerTitle: true,
              floating: true,
              scrolledUnderElevation: 0,
              shadowColor: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              surfaceTintColor: Colors.transparent,
              titleTextStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 18.fontMultiplier,
                  fontWeight: FontWeight.w700),
              actions: [
                TextButton(
                    onPressed: () {
                      _editProfileController.validateForm(context);
                    },
                    child: Text(
                      'save'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.fontMultiplier,
                          color: Colors.white),
                    ))
              ],


              flexibleSpace: FlexibleSpaceBar(
                background:  Container(
                  decoration: const  BoxDecoration(
                    color: AppColors.backgroundColor,
                  ),
          
                  child:   ClipPath(
                    clipper: CustomShape(),
                    child: Container(
                      color: AppColors.kPrimaryColor,
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 70),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Obx(() => CommonImageWidget(
                                          width: 110,
                                          height: 110,
                                          borderRadius: 100,
                                          url: _editProfileController
                                              .userImageUrl.value)),
                                    ),
                                    Positioned.fill(
                                      top: 70,
                                      left: 70,
                                      child: IconButton(
                                          onPressed: () {
                                            PickImageOptionsBottomSheet.show(
                                                context: context,
                                                imageSource:
                                                    (ImageSource source) async {
                                                  String? imagePath =
                                                  await _editProfileController
                                                      .picImage(source);
                                          
                                                  if (imagePath != null) {
                                                    List<String> uploadedFiles =
                                                    await _editProfileController
                                                        .uploadFile(imagePath);
                                                    if (uploadedFiles.isNotEmpty) {
                                                      _editProfileController
                                                          .userImageUrl
                                                          .value = uploadedFiles.first;
                                                    }
                                                  }
                                                });
                                          },
                                          icon: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.colorF3),
                                            child: SvgPicture.asset(
                                              AppIcons.icCameraFilled,
                                              color: AppColors.colorTextSecondary,
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Gap(16),
                            Obx(
                                  () => Text(
                                  Get.find<ProfileController>().user.value?.fullName ??
                                      '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                    fontSize: 16.fontMultiplier,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                            Obx(
                                  () => Text(
                                  Get.find<ProfileController>().user.value?.userName ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                    fontSize: 12.fontMultiplier,
                                    color: Colors.grey.shade300,
                                    fontWeight: FontWeight.w300,
                                  )),
                            ),
                            Obx(
                                  () => Text(
                                  Get.find<ProfileController>().user.value?.email ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                    fontSize: 12.fontMultiplier,
                                    color: Colors.grey.shade300,
                                    fontWeight: FontWeight.w300,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),


          SliverList.list(children: [
            Obx(
                  () => IntroVideoWidget(
                videoUrl: _editProfileController.introVideoUrl.value,
                thumbnailUrl: _editProfileController.introVideoThumbnail.value,
                onRemoveTap: () {
                  _editProfileController.introVideoUrl.value = null;
                },
                onAddIntroTap: () {
                  Get.toNamed(AppRoutes.routeIntroVideoGuidelineScreen,
                      arguments: {
                        AppConsts.keyRecordVideoFor: RecordVideoFor.editProfile
                      });
                },
                onTap: () {
                  Get.to(() =>MediaPreviewScreen(
                    mediaType: MediaType.video,
                    mediaUrl: _editProfileController.introVideoUrl.value,
                  ));
                },
              ),
            ),
            infoWidget(context),
            galleryWidget(context)
          ])
          ],
        )),
      ),
    );
  }

  Widget infoWidget(BuildContext context) {
    return Form(
      key: _editProfileController.formKey,
      child: CommonCardWidget(
        margin: const  EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonInputField(
              title: "name".tr,
              suffixIcon: const SizedBox.shrink(),
              controller: _editProfileController.nameController,
              hint: "hint_name",
              counterText: true,
              maxLines: 4,
              minLines: 1,
              maxLength: 64,
              validator: Validations.checkEmptyFiledValidations,
            ),
            CommonInputField(
              title: "work".tr,
              suffixIcon: const SizedBox.shrink(),
              controller: _editProfileController.workAtController,
              hint: "hint_work".tr,
              counterText: true,
              maxLength: 84,
              minLines: 1,
              maxLines: 5,
            ),
            CommonInputField(
              title: "education".tr,
              suffixIcon: const SizedBox.shrink(),
              controller: _editProfileController.schoolController,
              hint: "hint_education".tr,
              maxLength: 84,
              minLines: 1,
              counterText: true,
              maxLines: 5,
            ),
            CommonInputField(
              title: "lives_in".tr,
              suffixIcon: const SizedBox.shrink(),
              controller: _editProfileController.livesInController,
              hint: "hint_lives_in".tr,
              maxLength: 72,
              minLines: 1,
              counterText: true,
              maxLines: 5,
            ),
            CommonInputField(
              title: "From".tr,
              suffixIcon: const SizedBox.shrink(),
              controller: _editProfileController.fromController,
              hint: "hint_from_address".tr,
              maxLength: 72,
              minLines: 1,
              counterText: true,
              maxLines: 5,
            ),
            CommonInputField(
              title: "about_me".tr,
              controller: _editProfileController.aboutMeController,
              hint: "hint_about_me".tr,
              maxLines: 5,
              minLines: 5,
              maxLength: 500,
            ),
          ],
        ),
      ),
    );
  }

  Widget galleryWidget(BuildContext context) {
    return CommonCardWidget(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("gallery".tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 20.fontMultiplier, fontWeight: FontWeight.w700)),
          Text("minimum_2_images_gallery_required".tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 10.fontMultiplier, color: AppColors.colorTextSecondary)),
          Obx(
            () => GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  mainAxisExtent: 140
              ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                      onTap: () {
                        PickImageOptionsBottomSheet.show(
                            context: context,
                            imageSource: (ImageSource source) async {
                              String? imagePath =
                                  await _editProfileController.picImage(source);

                              if (imagePath != null) {
                                List<String> uploadedFiles =
                                    await _editProfileController
                                        .uploadFile(imagePath);
                                if (uploadedFiles.isNotEmpty) {
                                  _editProfileController.gallery
                                      .addAll(uploadedFiles);
                                  _editProfileController.gallery.refresh();
                                }
                              }
                            });
                      },
                      child: SvgPicture.asset(
                        AppImages.imgAddPhoto2,
                        fit: BoxFit.fill,


                      ));
                } else {
                  var image = _editProfileController.gallery[index - 1];
                  return ImageGridTile(
                    url: image,
                    onRemoveTap: () {
                      _editProfileController.gallery.removeAt(index - 1);
                    },
                  );
                }
              },
              itemCount: _editProfileController.gallery.length + 1,
            ),
          ),
        ],
      ),
    );
  }
}

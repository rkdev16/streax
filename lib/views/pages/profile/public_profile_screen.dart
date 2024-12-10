import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/consts/app_images.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/profile/public_profile_controller.dart';
import 'package:streax/utils/custom_painters/custom_shape.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/pages/media_preview/media_preview_screen.dart';
import 'package:streax/views/pages/profile/components/info_list_tile.dart';
import 'package:streax/views/pages/profile/components/intro_video_widget.dart';
import 'package:streax/views/widgets/Image_grid_tile.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';

class PublicProfileScreen extends StatelessWidget {
  PublicProfileScreen({super.key});

  final _publicProfileController = Get.find<PublicProfileController>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: AppColors.kPrimaryColor),
      child: Scaffold(
          body: Obx(
        () => _publicProfileController.isLoading.value
            ? const CommonProgressBar()
            : CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  SliverAppBar(
                    systemOverlayStyle: SystemUiOverlayStyle.light
                        .copyWith(statusBarColor: AppColors.kPrimaryColor),
                    floating: true,
                    leading: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: SvgPicture.asset(AppIcons.icBack)),
                    backgroundColor: AppColors.backgroundColor,
                    title: Text('profile'.tr),
                    expandedHeight: 290,
                    centerTitle: true,
                    scrolledUnderElevation: 0,
                    shadowColor: Colors.transparent,
                    clipBehavior: Clip.antiAlias,
                    surfaceTintColor: Colors.transparent,
                    titleTextStyle: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                            color: Colors.white,
                            fontSize: 18.fontMultiplier,
                            fontWeight: FontWeight.w700),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.backgroundColor,
                        ),
                        child: ClipPath(
                          clipper: CustomShape(),
                          child: Container(
                            color: AppColors.kPrimaryColor,
                            child: SafeArea(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 70.0),
                                    child: CommonImageWidget(
                                      url: _publicProfileController
                                              .user.value?.image ??
                                          "",
                                      borderRadius: 100,
                                      padding: const EdgeInsets.all(16),
                                      placeholder: AppImages.imgUserPlaceHolder,
                                      errorPlaceholder:
                                          AppImages.imgUserPlaceHolder,
                                    ),
                                  ),
                                  Text(
                                      _publicProfileController
                                              .user.value?.fullName ??
                                          '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontSize: 16.fontMultiplier,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          )),
                                  Text(
                                      _publicProfileController
                                              .user.value?.userName ??
                                          '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontSize: 12.fontMultiplier,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList.list(children: [
                    if (_publicProfileController.user.value?.introVideo != null)
                      IntroVideoWidget(
                        videoUrl:
                            _publicProfileController.user.value?.introVideo,
                        thumbnailUrl: _publicProfileController
                            .user.value?.introVideoThumbnail,
                        onTap: () {
                          Get.to(() => MediaPreviewScreen(
                                mediaType: MediaType.video,
                                mediaUrl: _publicProfileController
                                    .user.value?.introVideo,
                              ));
                        },
                      ),
                    infoWidget(context),
                    aboutWidget(context),
                    galleryWidget(context)
                  ])
                ],
              ),
      )),
    );
  }

  Widget infoWidget(BuildContext context) {
    var user = _publicProfileController.user.value;
    return CommonCardWidget(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoListTile(
              title: 'work'.tr,
              subtitle: user?.worksAt ?? '',
              icon: AppIcons.icBriefCase),
          InfoListTile(
              title: 'education'.tr,
              subtitle: user?.school ?? '',
              icon: AppIcons.icBook),
          InfoListTile(
              title: 'lives_in'.tr,
              subtitle: user?.livesIn ?? '',
              icon: AppIcons.icMap),
          InfoListTile(
              title: 'from'.tr,
              subtitle: user?.from ?? '',
              icon: AppIcons.icMarkerFilled),
        ],
      ),
    );
  }

  Widget aboutWidget(BuildContext context) {
    var user = _publicProfileController.user.value;
    return CommonCardWidget(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "about_me".tr,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 20.fontMultiplier,
                  fontWeight: FontWeight.w700,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(user?.aboutMe ?? "",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 15.fontMultiplier,
                    color: AppColors.colorTextSecondary)),
          ),
        ],
      ),
    );
  }

  Widget galleryWidget(BuildContext context) {
    List<String> gallery = _publicProfileController.user.value?.gallery ?? [];
    return CommonCardWidget(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("gallery".tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 20.fontMultiplier, fontWeight: FontWeight.w700)),
          GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 140),
              padding: const EdgeInsets.symmetric(vertical: 8),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: gallery.length,
              itemBuilder: (BuildContext context, int index) {
                return ImageGridTile(
                  url: gallery[index],
                  index: index,
                  imagesList: gallery,
                  isGallery: true,
                );
              })
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/consts/app_images.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/profile/profile_controller.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/pages/media_preview/media_preview_screen.dart';
import 'package:streax/views/pages/profile/components/browse_store_widget.dart';
import 'package:streax/views/pages/profile/components/info_list_tile.dart';
import 'package:streax/views/pages/profile/components/intro_video_widget.dart';
import 'package:streax/views/widgets/Image_grid_tile.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';

import '../../../config/app_colors.dart';
import '../../../utils/custom_painters/custom_shape.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final _profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: AppColors.kPrimaryColor),
      child: Scaffold(
          body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light
                .copyWith(statusBarColor: AppColors.kPrimaryColor),
            backgroundColor: AppColors.backgroundColor,
            title: Text('my_profile'.tr),
            expandedHeight: 290,
            centerTitle: true,
            scrolledUnderElevation: 0,
            shadowColor: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            surfaceTintColor: Colors.transparent,
            titleTextStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontSize: 18.fontMultiplier,
                fontWeight: FontWeight.w700),
            actions: [
              IconButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.routeEditProfileScreen);
                  },
                  padding: const EdgeInsets.only(right: 16),
                  icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: SvgPicture.asset(AppIcons.icEdit))),
            ],
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
                          Container(
                            margin: const EdgeInsets.only(top: 70),
                            child: Obx(
                              () => CommonImageWidget(
                                url: _profileController.user.value?.image ?? "",
                                borderRadius: 100,
                                padding: const EdgeInsets.all(16),
                                placeholder: AppImages.imgUserPlaceHolder,
                                errorPlaceholder: AppImages.imgUserPlaceHolder,
                              ),
                            ),
                          ),
                          Obx(
                            () => Text(
                                _profileController.user.value?.fullName ?? '',
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
                                _profileController.user.value?.userName ?? '',
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
                                _profileController.user.value?.email ?? '',
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
            const BrowseStoreWidget(),
            Obx(
              () => IntroVideoWidget(
                videoUrl: _profileController.user.value?.introVideo,
                thumbnailUrl:
                    _profileController.user.value?.introVideoThumbnail,
                onTap: () {
                  Get.to(() => MediaPreviewScreen(
                        mediaType: MediaType.video,
                        mediaUrl: _profileController.user.value?.introVideo,
                      ));
                },
                onAddIntroTap: () {
                  Get.toNamed(AppRoutes.routeEditProfileScreen);
                },
              ),
            ),
            Obx(() => infoWidget(context)),
            aboutWidget(context),
            Obx(() => galleryWidget(context))
          ])
        ],
      )),
    );
  }

  Widget infoWidget(BuildContext context) {
    var user = _profileController.user.value;
    return CommonCardWidget(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
    var user = _profileController.user.value;
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
    List<String> gallery = _profileController.user.value?.gallery ?? [];
    return CommonCardWidget(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
                return ImageGridTile(url: gallery[index],
                  imagesList: gallery,
                  index: index,
                  isGallery: true,);
              }),
        ],
      ),
    );
  }
}

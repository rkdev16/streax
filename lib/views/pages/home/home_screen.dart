import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/controller/home/home_controller.dart';
import 'package:streax/controller/location/location_controller.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/pages/home/components/home_app_bar.dart';
import 'package:streax/views/pages/home/components/profile_loading_widget.dart';
import 'package:streax/views/widgets/common_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeController = Get.find<HomeController>();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HomeAppBar(),
      body: Obx(
        () => _homeController.isLoading.value
            ? const ProfileLoadingWidget()
            : _homeController.isHavingPermission.value ? Swiper(
                controller: SwiperController(),
                itemCount: _homeController.profileSuggestions.length,
                physics: _homeController.isLoadingLike.value? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                indicatorLayout: PageIndicatorLayout.COLOR,
                index: _homeController.focusedIndex,
                loop: false,
                onIndexChanged: _homeController.onPageChanged,
                itemBuilder: (BuildContext context, int index) {
                  // debugPrint("ControllerData => index=$index = Controller =  ${_homeController.videoControllers[index]}");

                  // return ProfileWidget(
                  //   user: _homeController.profileSuggestions[index],
                  //   videoPlayerController: _homeController.videoControllers[index],);

                  return _homeController.profileSuggestions[index];
                },
              ) : Container(
          height: Get.height,
          width: Get.width,
          alignment: Alignment.center,
          child: Column(
mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Unable to connect',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "To use Streax, you need to enable your location sharing so we can show you who's around",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge
              ).paddingOnly(top: 10, bottom: 30),
              Text(
                'Go to Settings > Streax > Location > Enable Location while using the App',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge
              ),

              CommonButton(text: 'Open Settings', onPressed: () {
                Get.find<LocationController>().getCurrentLocation().then((value) async {
                  if(value){
                    Get.back();
                    _homeController.isHavingPermission.value =  await Get.find<LocationController>().getCurrentLocation();
                  }
                });

              }).paddingOnly(top: 50),
              InkWell(
                onTap: () async {
                  var status = await Permission.location.status;

                  if (status.isGranted) {
                    _homeController.isHavingPermission.value = true;
                    Get.find<LocationController>().getCurrentLocation();
                  }
                },
                child: Text(
                    'Refresh',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.kPrimaryColor
                    )
                ),
              ).paddingOnly(top: 30),
            ],
          ),
        ),
      ),
    );
  }
}

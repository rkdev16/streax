import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/controller/location/location_controller.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/pages/location/components/search_address_cell.dart';
import 'package:streax/views/widgets/common_search_app_bar.dart';

class SearchLocationScreen extends StatelessWidget {
  final _locationController = Get.find<LocationController>();

  SearchLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
        .copyWith(statusBarColor: AppColors.kPrimaryColor));
    return Scaffold(
        appBar: CommonSearchAppBar(
          hint:'search_location'.tr,
          onBackTap: (){
            Get.back();
          },
          searchInputController: _locationController.searchTextController,
          onSearchKeywordChange: (String value){
            _locationController.searchKeyword.value =value;
          },
         ),


        body: Column(children: [
          Obx(
            () => _locationController.isEmptyList.value
                ? ListView.builder(
                    itemCount: 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          _locationController.pickAddress(index);
                        },
                        leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(AppIcons.icMarkerFilled,height: 24,),
                        ),
                        title: Text(
                          'Your Current Location',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontSize:15.fontMultiplier,
                                  color: Colors.black.withOpacity(0.3)),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Obx(
                            () => Text(
                              _locationController.currentCity.value??'',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      fontSize:
                                          15.fontMultiplier,
                                      color: Colors.black.withOpacity(0.3)),
                            ),
                          ),
                        ),
                      );
                    })
                : const SizedBox(),
          ),
          Obx(
            () => Expanded(
              child: _locationController.isEmptyList.value ||
                      _locationController.isLoadingPlaces.value
                  ? Center(
                      child: Text(
                      _locationController.isLoadingPlaces.value
                          ? 'message_loading_places'.tr
                          : _locationController.isEmptyList.value
                              ? 'message_no_location_try_searching'.tr
                              : '',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.colorTextSecondary,
                          fontSize: 15.fontMultiplier),
                    ))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return SearchAddressCell(
                          place: _locationController.places[index],
                          onClick: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _locationController.pickAddress(index);
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const  Divider();
                      },
                      itemCount: _locationController.places.length),
            ),
          )
        ]));
  }
}

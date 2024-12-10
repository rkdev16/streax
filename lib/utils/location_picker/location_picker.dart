import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/model/place_detail_res_model.dart';
import 'package:streax/model/place_predictions_res_model.dart';
import 'package:streax/utils/location_picker/location_picker_controller.dart';
import 'package:streax/utils/location_picker/search_address_cell.dart';
import 'package:streax/utils/location_picker/search_input_field.dart';
import 'package:streax/views/widgets/common_app_bar.dart';

class LocationPicker {
  static show({required Function(PlaceDetail placeDetail) onPlaceSelect}) {
    Get.to(() => _LocationPickerContent(onPlaceSelect: onPlaceSelect),
        transition: Transition.downToUp,
        curve: Curves.ease,
        duration: const Duration(milliseconds: 400),
        binding: BindingsBuilder(() {
      Get.lazyPut(() => LocationPickerController());
    }));
  }
}

class _LocationPickerContent extends StatelessWidget {
   _LocationPickerContent({
    super.key,
    required this.onPlaceSelect
  });

  final _locationPickerController = Get.put(LocationPickerController());

  final Function(PlaceDetail placeDetail) onPlaceSelect;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white
      ),
      child: Scaffold(
        appBar: CommonAppBar(
          onBackTap: () {
            Navigator.of(context).pop();
          },
          title:'search'.tr
        ),

        //


        body:  Column(children: [

          SearchInputField(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              controller: _locationPickerController.searchTextController,
              onClearFiled: (){
                _locationPickerController.clearSearchField();
              },
              onChanged: (String value) {
                _locationPickerController.searchKeyword.value = value;
              },
              hint: 'search'.tr),


          Expanded(
            child: Obx(
                  () => _locationPickerController.isEmptyList.value ||
                  _locationPickerController.isLoadingPlaces.value
                  ? Center(
                  child: Text(
                    _locationPickerController.isLoadingPlaces.value
                        ? 'message_loading_places'.tr
                        : _locationPickerController.isEmptyList.value
                        ? _locationPickerController.isFirstTime.value
                        ? 'message_search_location'.tr
                        : 'message_no_location_found_try_searching'.tr
                        : '',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.colorTextSecondary,
                        fontSize: AppConsts.commonFontSizeFactor * 15),
                  ))
                  : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Prediction prediction = _locationPickerController.predictions[index];
                    return SearchAddressCell(
                      prediction: prediction,
                      onClick: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                       PlaceDetail? placeDetail =  await _locationPickerController.getPlaceDetailsFromPlaceId(prediction);
                       if(placeDetail !=null){
                         Navigator.of(context).pop();
                         _locationPickerController.clearSearchField();

                         onPlaceSelect(placeDetail);

                       }


                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: _locationPickerController.predictions.length),
            ),
          ),






        ],),






      ),
    );
  }
}

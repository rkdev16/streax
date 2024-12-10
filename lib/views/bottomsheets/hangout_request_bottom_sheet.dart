import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/controller/chat/chat_controller.dart';
import 'package:streax/controller/hangout/hangout_controller.dart';
import 'package:streax/model/place_detail_res_model.dart';
import 'package:streax/model/user.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/utils/location_picker/location_picker.dart';
import 'package:streax/utils/validations.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';
import 'package:streax/views/widgets/common_input_feilds.dart';

class HangoutRequestBottomSheet {
  static show({required User user}) {
    Get.bottomSheet(
      _HangoutRequestSheetContent(
        user: user,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0))),
    );
  }
}

class _HangoutRequestSheetContent extends StatelessWidget {
  _HangoutRequestSheetContent({required this.user});

  final User? user;

  final _hangoutController = Get.put<HangoutController>(HangoutController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) {
        _hangoutController.clearData();
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Form(
            key: _hangoutController.formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 126,
                      height: 6,
                      decoration: BoxDecoration(
                          color: AppColors.colorEF,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppIcons.icGlassSvg),
                        const Gap(8),
                        Text(
                          'hang_out'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontSize: 20.fontMultiplier,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.colorTextPrimary),
                        ),
                      ],
                    ),
                  ),
                  CommonImageWidget(
                    url: user?.image ?? '',
                    height: 100,
                    width: 100,
                    borderRadius: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16, top: 8, bottom: 24),
                    child: Text(
                      '${user?.fullName ?? ''},${Helpers.calculateAge(user?.dob)}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.colorTextPrimary,
                              fontSize: 16.fontMultiplier),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'place'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              fontSize: 14.fontMultiplier,
                              color: AppColors.colorTextPrimary,
                              fontWeight: FontWeight.w600),
                    ),
                  ),
                  CommonInputField(
                      controller: _hangoutController.placeController,
                      validator: Validations.checkEmptyFiledValidations,
                      maxLines: 5,
                      hint: 'hint_place'),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'address'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              fontSize: 14.fontMultiplier,
                              color: AppColors.colorTextPrimary,
                              fontWeight: FontWeight.w600),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      LocationPicker.show(
                          onPlaceSelect: (PlaceDetail placeDetail) {
                        _hangoutController.selectPlace(placeDetail);
                      });
                    },
                    child: CommonInputField(
                        controller: _hangoutController.locationController,
                        readOnly: true,
                        enabled: false,
                        maxLines: 5,
                        suffixIcon: const Icon(Icons.search_rounded,
                            color: AppColors.colorF4),
                        hint: 'hint_address'),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'date'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              fontSize: 14.fontMultiplier,
                              color: AppColors.colorTextPrimary,
                              fontWeight: FontWeight.w600),
                    ),
                  ),
                  CommonInputField(
                    controller: _hangoutController.dateController,
                    readOnly: true,
                    hint: 'hint_date'.tr,
                    validator: Validations.checkEmptyFiledValidations,
                    suffixIcon: IconButton(
                        onPressed: () {
                          _hangoutController.pickDate(context);
                        },
                        icon: SvgPicture.asset(AppIcons.icCalender)),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'time'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              fontSize: 14.fontMultiplier,
                              color: AppColors.colorTextPrimary,
                              fontWeight: FontWeight.w600),
                    ),
                  ),
                  CommonInputField(
                    controller: _hangoutController.timeController,
                    readOnly: true,
                    hint: 'select'.tr,
                    validator: Validations.checkEmptyFiledValidations,
                    suffixIcon: IconButton(
                        onPressed: () {
                          _hangoutController.pickTime(context);
                        },
                        icon: SvgPicture.asset(AppIcons.icClock)),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'add_a_message'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              fontSize: 14.fontMultiplier,
                              color: AppColors.colorTextPrimary,
                              fontWeight: FontWeight.w600),
                    ),
                  ),
                  CommonInputField(
                    controller: _hangoutController.commentController,
                    hint: 'add_a_message'.tr,
                    maxLines: 4,
                    minLines: 4,
                    inputType: TextInputType.multiline,
                  ),
                  CommonButton(
                      text: 'send'.tr,
                      isLoading: _hangoutController.isLoading,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 24),
                      onPressed: () async {
                        String? hangoutRequestId =
                            await _hangoutController.sendHangoutRequest(user);
                        debugPrint("hangoutRequestId = $hangoutRequestId");
                        if (hangoutRequestId != null && context.mounted) {
                          Get.find<ChatController>()
                              .sendHangoutRequest(hangoutRequestId);
                          Navigator.of(context).pop();
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

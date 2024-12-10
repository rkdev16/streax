import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/controller/profile_setup/profile_setup_controller.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/validations.dart';
import 'package:streax/views/pages/profile_setup/components/common_bg_profile_setup.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import 'package:streax/views/widgets/common_input_feilds.dart';
import 'package:streax/views/widgets/common_range_slider.dart';
import 'package:streax/views/widgets/common_slider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SetupBasicInfoScreen extends StatefulWidget {
  const SetupBasicInfoScreen({super.key});

  @override
  State<SetupBasicInfoScreen> createState() => _SetupBasicInfoScreenState();
}
class _SetupBasicInfoScreenState extends State<SetupBasicInfoScreen> {
  final _profileSetupController = Get.find<ProfileSetupController>();
  @override
  Widget build(BuildContext context) {
    return CommonBgProfileSetup(
      pageNo: 1,
      child: ListView(
        shrinkWrap: true,
        children: [
          Form(
            key: _profileSetupController.basicInfoFormKey,
            child: CommonCardWidget(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonInputField(
                    title: "name".tr,
                    suffixIcon: const SizedBox.shrink(),
                    controller: _profileSetupController.nameController,
                    hint: "hint_name",
                    maxLines: 4,
                    counterText: true,
                    minLines: 1,
                    maxLength: 64,
                    validator: Validations.checkNameValidations,
                  ),
                  CommonInputField(
                    title: "username".tr,
                    suffixIcon: const SizedBox.shrink(),
                    textCapitalization: TextCapitalization.none,
                    controller: _profileSetupController.userNameController,
                    hint: "hint_username",
                    counterText: true,
                    maxLines: 4,
                    minLines: 1,
                    maxLength: 30,
                    validator: Validations.checkUsernameValidations,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Obx(
                      () => Visibility(
                          visible: _profileSetupController.isUserExists.value,
                          child: Text(
                            'username_not_available'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    fontSize: 12.fontMultiplier,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.redAccent),
                          )),
                    ),
                  ),
                  CommonInputField(
                    title: "birthday".tr,
                    readOnly: true,
                    suffixIcon: IconButton(
                        onPressed: () {
                          _profileSetupController.selectDob(context);
                        },
                        icon:
                            SvgPicture.asset(AppIcons.icCalender, height: 25)),
                    controller: _profileSetupController.dobController,
                    hint: 'hint_dob'.tr,
                    validator: Validations.checkDOBValidations,
                  ),

                  GestureDetector(
                    onTap: () {
                      _profileSetupController.showGenderOptions((gender) {
                        _profileSetupController.selectedGender = gender;
                        _profileSetupController.genderController.text =
                            gender.tr;
                      });
                    },
                    child: CommonInputField(
                      title: "gender".tr,
                      enabled: false,
                      controller: _profileSetupController.genderController,
                      hint: 'select'.tr,
                      validator: Validations.checkEmptyFiledValidations,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      _profileSetupController
                          .showInterestedInOptions((interestedIn) {
                        _profileSetupController.selectedInterestedIn =
                            interestedIn;
                        _profileSetupController.interestedInController.text =
                            interestedIn.tr;
                      });
                    },
                    child: CommonInputField(
                      title: "interested_in".tr,
                      enabled: false,
                      controller:
                          _profileSetupController.interestedInController,
                      hint: 'select'.tr,
                      validator: Validations.checkEmptyFiledValidations,
                    ),
                  ),
                  // GenderSelectionWidget(
                  //     title: 'gender'.tr,
                  //     items: _profileSetupController.genders,
                  //     selectedItem: _profileSetupController.selectedGender,
                  //     margin: const EdgeInsets.only(top: 8),
                  //     onChange: (String? value) {
                  //       debugPrint("Gender = $value");
                  //       _profileSetupController.selectedGender = value;
                  //     }),
                  // GenderSelectionWidget(
                  //     title: 'interested_in'.tr,
                  //     items: _profileSetupController.genders,
                  //     selectedItem: _profileSetupController.selectedGender,
                  //     margin: const EdgeInsets.only(top: 8),
                  //     onChange: (String? value) {
                  //       _profileSetupController.selectedInterestedIn = value;
                  //     })
                ],
              ),
            ),
          ),
          CommonRangeSlider(
            title: 'age_preference'.tr,
            values: _profileSetupController.ageRangeValues.value,
            min: 18.0,
            max: 80.0,
            margin: const EdgeInsets.all(16),
            onChange: (SfRangeValues values) {
              _profileSetupController.ageRangeValues.value = values;
            },
          ),
          CommonSlider(
            title: 'distance_preference'.tr,
            value: _profileSetupController.distancePreferenceValue.value,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            min: 0.0,
            max: 100.0,
            valuesUnit: 'miles'.tr,
            onChange: (num value) {
              _profileSetupController.distancePreferenceValue.value = value;
            },
          ),
          CommonButton(
              text: 'next'.tr,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              onPressed: () {
                _profileSetupController.validateBasicInfoForm();
              })
        ],
      ),
    );
  }
}

class GenderSelectionWidget extends StatefulWidget {
  const GenderSelectionWidget(
      {super.key,
      required this.title,
      this.hint,
      this.margin,
      required this.items,
      required this.selectedItem,
      required this.onChange});

  final String title;
  final String? hint;
  final List<String> items;
  final String? selectedItem;
  final EdgeInsets? margin;
  final Function(String? value) onChange;

  @override
  State<GenderSelectionWidget> createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  String? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title.tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 14,
                  color: AppColors.colorTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            height: 45,
            decoration: BoxDecoration(
                color: AppColors.colorF3,
                borderRadius: BorderRadius.circular(8.0)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                hint: Text(
                  widget.hint ?? "select".tr,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.colorC2,
                        fontSize: 14.fontMultiplier,
                      ),
                ),
                isExpanded: true,
                items: widget.items
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item.tr,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    fontSize: 14.fontMultiplier,
                                    color: AppColors.colorTextPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedItem,
                onChanged: (String? value) {
                  setState(() {
                    selectedItem = value;
                  });
                  widget.onChange(value);
                },
                iconStyleData: IconStyleData(
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.keyboard_arrow_down_outlined,
                    ),
                  ),
                  iconSize: 20,
                  iconEnabledColor: AppColors.colorTextPrimary.withOpacity(0.3),
                  iconDisabledColor: Colors.grey,
                ),
                dropdownStyleData: const DropdownStyleData(
                  maxHeight: 200,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

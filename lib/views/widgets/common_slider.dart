import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class CommonSlider extends StatefulWidget {
  const CommonSlider({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChange,
    this.margin,
    this.valuesUnit,
  });

  final double min;
  final double max;
  final String title;
  final num value;
  final String? valuesUnit;
  final EdgeInsets? margin;
  final Function(num value) onChange;

  @override
  State<CommonSlider> createState() => _CommonSliderState();
}

class _CommonSliderState extends State<CommonSlider> {

  late  num value;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    value = widget.value;
  }



  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
        margin:  widget.margin ?? const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title.tr,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 16.fontMultiplier,
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorTextPrimary),
                ),
                Text(
                  "${value.toInt()} ${widget.valuesUnit ?? ''}",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.fontMultiplier,
                      color: AppColors.kPrimaryColor),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            SfSliderTheme(
              data: SfSliderThemeData(
                  thumbStrokeColor: Colors.white,
                  thumbRadius: 10,
                  thumbStrokeWidth: 1.0,
                  thumbColor: AppColors.kPrimaryColor,
                  activeTrackColor: AppColors.kPrimaryColor,
                  inactiveTrackColor: AppColors.colorEA,
                  trackCornerRadius: 4,
                  activeTrackHeight: 6,
                  tooltipBackgroundColor: Colors.transparent,
                  overlayRadius: 12,
                  tooltipTextStyle: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                      fontSize: 15.fontMultiplier,
                      color: AppColors.colorTextPrimary),
                  inactiveTrackHeight: 6),
              child: SfSlider(
                stepSize: 1,
                interval: 1,
                min: widget.min,
                max: widget.max,


                value: value,
                onChanged: (dynamic value) {
                  this.value = value;
                  widget.onChange(value);
                  setState(() {});
                },
              ),
            ),
          ],
        ));
  }
}
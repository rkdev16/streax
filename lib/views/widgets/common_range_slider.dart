import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class CommonRangeSlider extends StatefulWidget {
  const CommonRangeSlider({
    super.key,
    required this.title,
    required this.values,
    required this.onChange,
    this.min,
    this.max,
    this.margin,
    this.valuesUnit,
  });

  final String title;
  final SfRangeValues values;
  final double? min;
  final double? max;
  final String? valuesUnit;
  final EdgeInsets? margin;
  final Function(SfRangeValues values) onChange;

  @override
  State<CommonRangeSlider> createState() => _CommonRangeSliderState();
}

class _CommonRangeSliderState extends State<CommonRangeSlider> {

  late  SfRangeValues values;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    values = widget.values;
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
                  "${((values.start as double).toInt())}-${(values.end as double).toInt()} ${widget.valuesUnit ?? ''}",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.fontMultiplier,
                      color: AppColors.kPrimaryColor),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            SfRangeSliderTheme(
              data: SfRangeSliderThemeData(
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
                  overlappingTooltipStrokeColor: Colors.transparent,
                  tooltipTextStyle: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                      fontSize: 15.fontMultiplier,
                      color: AppColors.colorTextPrimary),
                  inactiveTrackHeight: 6),
              child: SfRangeSlider(
                stepSize: 1,
                interval: 1,

                min: widget.min ?? 0,
                max: widget.max ?? 100,
                values: values,
                onChanged: (SfRangeValues values) {
                  this.values = values;
                  widget.onChange(values);
                  setState(() {});
                },
              ),
            ),
          ],
        ));
  }
}
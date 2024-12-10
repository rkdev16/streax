import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/utils/extensions/extensions.dart';

class ChatTimeListTile extends StatelessWidget {
  const ChatTimeListTile({
    super.key,
    required this.dateTime
  });


  final DateTime? dateTime;

  String getDateTitle(DateTime? dateTime) {
    if (dateTime == null) return "NA";
    var today = DateTime.now();
    var currentDay = today.day;
    var currentMonth = today.month;
    var currentYear = today.year;

    if (dateTime.day == currentDay
        && dateTime.month == currentMonth
        && dateTime.year == currentYear) {
      return "today".tr;
    } else if (dateTime.day == currentDay
        && dateTime.month == currentMonth
        && dateTime.year == currentYear){
      return 'yesterday'.tr;
    }else{
      return DateFormat("MMM,dd,yyyy").format(dateTime);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: Text(getDateTitle(dateTime),style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontSize: 12.fontMultiplier,
        color: AppColors.colorTextPrimary
      ),),);
  }
}

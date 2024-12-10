import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/controller/report/report_controller.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_input_feilds.dart';

class ReportScreen extends StatelessWidget {
   ReportScreen({super.key});

  final _reportController = Get.find<ReportController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'report'.tr,
        onBackTap: () {
        Get.back();
      },),

      body:  ListView(
        shrinkWrap: true,
        children: [
        Obx(
          ()=> ListView.separated(
            shrinkWrap: true,
              physics: const  NeverScrollableScrollPhysics(),
              itemBuilder: (context,index){
            var option= _reportController.reportOptions[index];
            return Row(children: [
              IconButton(onPressed: (){
                _reportController.selectOption(index);
              },
                  icon: Icon(option.isSelected?Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,color: option.isSelected ? AppColors.kPrimaryColor: Colors.grey)),
              Text(option.title,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 16.fontMultiplier,
                color: AppColors.colorTextPrimary
              ),)
            ],);

          },
              separatorBuilder: (context,index){
            return const  Divider(indent: 16,endIndent: 16,);
              },
              itemCount: _reportController.reportOptions.length),
        ),



        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
          child: Text('add_comment'.tr,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontSize: 14.fontMultiplier,
            fontWeight: FontWeight.w600,
            color: AppColors.colorTextPrimary
          ),),
        ),
        CommonInputField(
            controller: _reportController.commentTextController,
            maxLines: 5,
            hint: 'comments'.tr,
          margin: const  EdgeInsets.symmetric(horizontal: 16),
        ),



        CommonButton(text: 'report'.tr,
            isLoading: _reportController.isLoading,
            margin: const   EdgeInsets.symmetric(horizontal: 16,vertical: 24),
            onPressed: (){
          _reportController.validateData();

        })

      ],),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/views/widgets/common_button.dart';
import '../../config/app_colors.dart';
import '../../model/common_options_model.dart';

class DeleteAccountBottomSheet{
  static show({required List<CommonDeleteModel> options,}){
    Get.bottomSheet(DeleteAccountScreen(options: options,),


      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0))),
    );
  }
}
class DeleteAccountScreen extends StatelessWidget {
   const DeleteAccountScreen({super.key,required this.options});
  final List<CommonDeleteModel> options;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
          itemBuilder: (context, index) {
            return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25.0),
                    Text(options[index].title.tr, textAlign:TextAlign.center,style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize:20,color: AppColors.colorTextPrimary
                    ),),
                    const SizedBox(height: 20.0),
                    Row(children: [
                      Expanded(child: CommonButton(
                          text:options[index].delete.tr,
                          onPressed: options[index].action

                      )),
                      Expanded(child: CommonButton(
                          backgroundColor:AppColors.colorC2,

                          text: "cancel", onPressed: (){
                        Get.back();
                      }))
                    ],)

                  ],
                );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 20.0,
            );
          },
          itemCount: options.length),

    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import '../../model/common_options_model.dart';

class CommonOptionsBottomSheet {
  static show({required List<OptionModel> options, height,Function(bool)? onPopInvoked}) {
    Get.bottomSheet(
      _OptionsBottomSheetContent(
        options: options,
        onPopInvoked: onPopInvoked,

      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0))),
    );
  }
}

class _OptionsBottomSheetContent extends StatelessWidget {
 const  _OptionsBottomSheetContent({required this.options,
   required this.onPopInvoked
  });

  final List<OptionModel> options;
  final Function(bool)? onPopInvoked;


  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: onPopInvoked,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 126,
              height: 6,
              decoration: BoxDecoration(
              color: AppColors.colorEF,
                borderRadius: BorderRadius.circular(8)
            ),),
            ListView.separated(
              shrinkWrap: true,
                itemBuilder: (context, index) {

                return TextButton(onPressed: (){
                  Get.back();
                  options[index].action();
                }, child: Text(
                    options[index].title.tr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                    ),
                  ));





                },
                separatorBuilder: (context, index) {
                  return const  Divider(
                    indent: 24,
                    endIndent: 24,
                    color: AppColors.colorF6,
                  );
                },
                itemCount: options.length),
          ],
        ),
      ),
    );
  }
}



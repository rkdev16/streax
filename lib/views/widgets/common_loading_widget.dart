import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/utils/extensions/extensions.dart';

class CommonLoadingWidget extends StatelessWidget {
  const CommonLoadingWidget({
    super.key,
    this.message,
    this.child,
    this.loading
  });

 final String? message;
 final Widget? child;
 final RxBool? loading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child?? const SizedBox.shrink(),
        Obx(
        ()=> Visibility(
          visible: (loading??RxBool(false)).value,
          child: Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,

                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 8,
                    blurRadius: 8
                  )
                ]


              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                 const  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      color: AppColors.kPrimaryColor,
                      strokeWidth: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                     message?? 'loading_please_wait'.tr,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontSize: 12.fontMultiplier,
                            color: AppColors.colorTextPrimary,
                          ),
                    ),
                  )
                ],
              ),
            ),
        ),
        ),
      ],
    );
  }
}

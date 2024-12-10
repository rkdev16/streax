import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_button.dart';

class CommonAlertDialog {
  CommonAlertDialog._();

  static showDialog({
    String? title,
    required String message,
    String? negativeText,
    required String positiveText,
    bool? isShowNegButton,
    VoidCallback? negativeBtCallback,
    bool? barrierDismissible,
    BuildContext? builder,
    required VoidCallback positiveBtCallback,
     VoidCallback? onPop,
  }) {
    Get.dialog(
        Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: CommonDialogContent(
            title: title,
            message: message,
            negativeText: negativeText,
            positiveText: positiveText,
            isShowNegButton: isShowNegButton,
            positiveBtCallback: positiveBtCallback,
            negativeBtCallback: negativeBtCallback,
            onPop: onPop,
          ),
        ),
        barrierDismissible: barrierDismissible ?? true);
  }
}

class CommonDialogContent extends StatelessWidget {
 const  CommonDialogContent({
    super.key,
    this.title,
    required this.message,
    this.negativeText,
    required this.positiveText,
    this.isShowNegButton,
    required this.positiveBtCallback,
    this.negativeBtCallback,
    this.positiveTextColor,
    this.negativeTextColor,
    this.onPop
  });

  final String? title;
  final String message;
  final String? negativeText;
  final String positiveText;
  final Color? positiveTextColor;
  final Color? negativeTextColor;
  final bool? isShowNegButton;
  final VoidCallback positiveBtCallback;
  final VoidCallback? negativeBtCallback;
  final VoidCallback? onPop;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if(onPop !=null){
           onPop!();
        }

        return Future(() => true);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.minPositive,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
                child: Text(
                  (title ?? "alert").tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 16.fontMultiplier,
                      fontWeight: FontWeight.w700,
                      color: AppColors.colorTextPrimary),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 24),
                child: Text(
                  message.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 12.fontMultiplier,
                      color: AppColors.colorTextPrimary.withOpacity(0.5)),
                ),
              ),
            if(negativeBtCallback!=null)  Divider(
                color: Colors.grey.withOpacity(0.5),
                height: 0,
              ),
          if(negativeBtCallback !=null)     CommonButton(text: negativeText??''.tr, onPressed: negativeBtCallback!,margin: EdgeInsets.zero,borderRadius: 0,backgroundColor: Colors.transparent,elevation: 0,
              textColor: AppColors.colorTextPrimary,
              textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 14.fontMultiplier,
                  fontWeight: FontWeight.w600,
                  color: negativeTextColor?? AppColors.kPrimaryColor
              )),
              Divider(
                color: Colors.grey.withOpacity(0.5),
                height: 0,
              ),

              CommonButton(text: positiveText.tr, onPressed: positiveBtCallback,margin: EdgeInsets.zero,borderRadius: 0,backgroundColor: Colors.transparent,elevation: 0,
              textColor: AppColors.colorTextPrimary,
              textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 14.fontMultiplier,
                color: positiveTextColor?? AppColors.colorTextPrimary
              ))





            ],
          ),
        ),
      ),
    );
  }
}

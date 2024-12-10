import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/controller/chat/chat_controller.dart';
import 'package:streax/controller/new_match/new_match_controller.dart';
import 'package:streax/model/chat_dialogs_res_model.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_button_outline.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';

class NewMatchScreen extends StatefulWidget {
   NewMatchScreen({super.key});

  @override
  State<NewMatchScreen> createState() => _NewMatchScreenState();
}

class _NewMatchScreenState extends State<NewMatchScreen> {
  final _newMatchController = Get.find<NewMatchController>();
  RxBool loading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: CommonAppBar(
        systemUiOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: AppColors.kPrimaryColor
        ),
          backgroundColor: AppColors.kPrimaryColor,
          title: '',
        leadingIconColor: Colors.white,
        onBackTap: (){
          Get.back();
        },
      ),

      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 24),
          child: Text('you_have_a_new_match'.tr,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontSize: 36.fontMultiplier,
            color: Colors.white,
            fontWeight: FontWeight.w700
          ),),
        ),


          Container(
            decoration: const  BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(BorderSide(color: Colors.white,width: 4),)
            ),
              child: Obx(()=> CommonImageWidget(url: _newMatchController.user.value?.image,width:200,height: 200,borderRadius: 100))),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 24),
            child: Obx(
    ()=> Text('${_newMatchController.user.value?.fullName} ${_newMatchController.user.value?.dob != null ? ',${Helpers.calculateAge(_newMatchController.user.value?.dob)}' : ''}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 20.fontMultiplier,
                    color: Colors.white,
                    fontWeight: FontWeight.w700
                ),),
            ),
          ),


          CommonButton(text: 'say_hi'.tr, onPressed: () async {
            try {
              setState(() {
                loading.value = true;
              });;
              ChatController controller = Get.find<ChatController>();
              String? roomId = await controller.createRoom(_newMatchController.user.value?.id ?? "");
              ChatDialog? roomDetail = await controller.getRoomDetail(roomId ?? "");
              if (roomDetail != null) {
                // ChatDialog dialog = ChatDialog(
                //     id: roomDetail.id,
                //     userName: roomDetail.userName,
                //     fullName: roomDetail.fullName,
                //     image: roomDetail.image,
                //     chatMessage: Message(room: roomId)
                // );
                controller.selectedChatDialog = roomDetail;
                Get.toNamed(AppRoutes.routeChatScreen, arguments: {
                  'isOnline': controller
                      .selectedChatDialog
                      ?.isOnline ??
                      false
                });

                //
              }
            } finally {
              setState(() {
                loading.value = false;
              });
            }
          },
            backgroundColor: Colors.white,
            textColor: AppColors.kPrimaryColor,
            borderRadius: 30,
            isLoading: loading,
            margin: const  EdgeInsets.all(16),
          ),
          CommonButtonOutline(text: 'maybe_later'.tr, onPressed: (){
            Navigator.of(context).pop();
          },
            borderRadius: 30,
            backgroundColor: AppColors.kPrimaryColor,
            textColor: Colors.white,
            borderColor: Colors.white,
          ),

      ],),



    );
  }
}

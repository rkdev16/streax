
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/app_raw_res.dart';

import '../../model/user.dart';

class NewMatchController extends GetxController{

  Rx<User?> user = Rx<User?>(null);


  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getArguments();
      playSound();
    });
  }


  getArguments(){
    Map<String,dynamic>? data = Get.arguments;
    if(data !=null){
      user.value = data[AppConsts.keyUser];
    }
  }

  playSound()async{

    await  Future.delayed(const Duration(milliseconds: 400));
    try{
      var audioPlayer = AudioPlayer();
      audioPlayer.setAsset(AppRawRes.audioOrder);
      audioPlayer.play();
    } on Exception catch(e){
      debugPrint(e.toString());
    }


  }
}
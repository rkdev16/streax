import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:streax/model/user.dart';
import 'package:streax/network/get_requests.dart';
import 'package:streax/utils/app_alerts.dart';

class SearchConnectionsController extends GetxController{

  late TextEditingController searchTextController = TextEditingController();

  final RxString searchKeyword = ''.obs;
  final RxBool isLoading =  false.obs;

  Worker? searchWorker;
  
  final  users = <User>[].obs;



  @override
  void onInit() {
    super.onInit();
    initWorkers();

  }

  @override
  void dispose() {
    searchWorker?.dispose();
    super.dispose();
  }

  initWorkers(){
    searchWorker = debounce(searchKeyword, (callback) => searchConnections());
  }



  searchConnections() async{
    
    var keyword = searchKeyword.value;
    if(keyword.isEmpty){
      users.clear();
      return;
    }
    try{

      isLoading.value = true;
      var result = await GetRequests.searchConnections(searchKeyword.value);
      if(result !=null){
        if(result.success){

          users.assignAll(result.users??[]);
        }else{
          AppAlerts.error(message: result.message);
        }
      }
      else{
        AppAlerts.error(message: 'message_server_error'.tr);
      }

    }finally{
      isLoading.value = false;
    }
  }
}
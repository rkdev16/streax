import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:http/http.dart' as http;
import 'package:streax/model/place_detail_res_model.dart';
import 'package:streax/model/place_predictions_res_model.dart';
import 'package:streax/utils/helpers.dart';

class LocationPickerController extends GetxController{

  late final  TextEditingController searchTextController;


  RxString searchKeyword =''.obs;
  Worker? searchWorker;


  var predictions = <Prediction>[].obs;

  RxBool isShowTrailing = false.obs;
  RxBool isLoadingPlaces = false.obs;
  RxBool isEmptyList = true.obs;
  RxBool isFirstTime = true.obs;











  @override
  void onInit() {
    super.onInit();
    initTextEditingControllers();
    initWorkers();

  }


  @override
  void onClose() {
    disposeTextEditingControllers();
    disposeWorkers();

    super.onClose();
  }

  initTextEditingControllers(){
    searchTextController = TextEditingController();
    searchTextController.addListener(() {

      searchKeyword.value = searchTextController.text.toString().trim();
      isShowTrailing.value = searchKeyword.value.isNotEmpty;
      isEmptyList.value = predictions.isEmpty;

    });
  }

  disposeTextEditingControllers(){
    searchTextController.dispose();
  }


  initWorkers(){
    searchWorker = debounce(searchKeyword, (callback) => getPlacePredictions());
  }

  disposeWorkers(){
    searchWorker?.dispose();
  }


  void clearSearchField() {
    predictions.clear();
    searchTextController.clear();
    isEmptyList.value = predictions.isEmpty;
    isLoadingPlaces.value = false;
  }


  getPlacePredictions() async{

    if(searchKeyword.isEmpty){
      predictions.clear();
      isEmptyList.value = true;
      return;
    }

    try{

      isLoadingPlaces.value = true;
      String url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchKeyword&key=${AppConsts.googleApiKey}";
      var response  = await  http.get(Uri.parse(url));
      debugPrint('request_url = $url');
      Helpers.printLog(
          screenName: 'Remote_Service_simple_get',
          message: "response = ${response.body}");

      if(response.statusCode == 200){
        PlacePredictionsResModel resModel = placePredictionsResModelFromJson(response.body);
        predictions.assignAll(resModel.predictions??[]);
      }else{
        predictions.assignAll([]);
      }


    }on Exception catch(e){
      debugPrint('Error $e');
      predictions.assignAll([]);
    }
    finally{
      isLoadingPlaces.value = false;
      isEmptyList.value = predictions.isEmpty;
    }

  }










  Future<PlaceDetail?> getPlaceDetailsFromPlaceId(Prediction prediction) async {
    var url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=${prediction.placeId}&key=${AppConsts.googleApiKey}";

    try{
      var response = await http.get(Uri.parse(url));
      debugPrint('request_url = $url');
      Helpers.printLog(
          screenName: 'Remote_Service_simple_get',
          message: "response = ${response.body}");
      if(response.statusCode ==200){
        return placeDetailFromJson(response.body);
      }else{
        return null;
      }
    }on Exception catch(e){
      debugPrint('Error $e');
      return null;
    }



  }



}
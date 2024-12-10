
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/controller/home/home_controller.dart';
import 'package:streax/model/geo_data.dart';
import 'package:streax/network/put_requests.dart';
import 'package:streax/utils/geocoder.dart';
import 'package:streax/utils/permission_handler.dart';
import 'package:streax/utils/preference_manager.dart';

class LocationController extends GetxController{

  var currentLocation = const LatLng(0, 0).obs;
  Rx<String?> currentCity = Rx<String?>(null);

  late TextEditingController searchTextController;
  final homeController = Get.find<HomeController>();

  var currentPosition = const LatLng(30.704649, 76.717873).obs;
  var places = <AutocompletePrediction>[].obs;

  RxString searchKeyword = ''.obs;
  RxBool isShowTrailing = false.obs;
  RxBool isLoadingPlaces = false.obs;
  RxBool isEmptyList = true.obs;

  Worker? searchPlacesWorker;

  late GooglePlace googlePlace;


  @override
  void onInit() {
    super.onInit();
    searchTextController = TextEditingController();
    searchTextController.addListener(() {
      isShowTrailing.value =
          searchTextController.text.toString().trim().isNotEmpty;
    });
    googlePlace = GooglePlace(AppConsts.googleApiKey);
    initSearchPlacesWorker();


  }

  @override
  void onClose() {
    searchTextController.dispose();
    searchPlacesWorker?.dispose();
    super.onClose();
  }


 Future<bool> isHavingLocationPermission() async{
    PermissionStatus status = await Permission.location.status;
    return status == PermissionStatus.granted;
  }



  Future<bool> getCurrentLocation() async {
    bool isHavingLocationPermission = false;

      isHavingLocationPermission =
      await PermissionHandler.requestLocationPermission();
      if (isHavingLocationPermission) {
      bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (isServiceEnabled) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        currentLocation.value = LatLng(position.latitude, position.longitude);
        debugPrint('CURRENT_LOCATION = ${currentLocation.value.toString()}');
        saveCurrentLocationToPref();
        getAddress();


      }
    } else {
        return false;
     // Get.find<HomeController>().getProfileSuggestions();
    }

      return isHavingLocationPermission;
  }

  void saveCurrentLocationToPref() {
    PreferenceManager.currentLocation = currentLocation.value;
  }


  Future<void> getAddress() async {
    GeoData data = await Geocoder.getDataFromCoordinates(
        latitude: currentLocation.value.latitude,
        longitude: currentLocation.value.longitude,
        googleMapApiKey: AppConsts.googleApiKey);

    debugPrint("Address Data = $data");

    updateUserLocation();
    currentCity.value = data.city;
  }


  void initSearchPlacesWorker() {
    searchPlacesWorker = debounce(searchKeyword, (callback) => searchPlaces());
  }


  void searchPlaces() async {
    debugPrint('Loading');
    isLoadingPlaces.value = true;
    if (searchKeyword.value.isNotEmpty) {
      var result = await googlePlace.autocomplete.get(searchKeyword.value);
      places.assignAll(result?.predictions ?? []);
      // for (var place in places) {
      //   print('place = ${place.description}');
      // }
    } else {
      places.clear();
    }

    isLoadingPlaces.value = false;
    isEmptyList.value = places.isEmpty;
  }


  void clearSearchField() {
    searchTextController.clear();
    places.clear();
    isEmptyList.value = places.isEmpty;
    isLoadingPlaces.value = false;
  }

  void pickAddress(int index) async {

    // try{
    // debugPrint("Place= = ${places[index].}");
    var placeId = places[index].placeId ?? "";
    var address = places[index].description ?? "";
    debugPrint('Address  =$address');
    if (address.isNotEmpty) {
      var result = await Geocoder.getDataFromPlaceId(
          placeId: placeId, googleMapApiKey: AppConsts.googleApiKey);

      currentLocation.value = LatLng(result.latitude, result.longitude);
      saveCurrentLocationToPref();
      getAddress();
      searchTextController.clear();
      searchKeyword.value ="";
      Get.back();

    }
    //  } on PlatformException catch(e){

    //    debugPrint("Exception = $e");
    //  }


  }


  updateUserLocation() async{
    try{
      Map<String,dynamic> requestBody = {
        'latitude':  currentLocation.value.latitude,
        'longitude':  currentLocation.value.longitude,
      };
      PutRequests.updateProfile(requestBody);
    }on Exception catch(e){
      debugPrint("Exception while updating user location on server = $e");
    }
  }



}
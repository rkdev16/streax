import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/model/user.dart';

class StoryViewsController extends GetxController {
  late TextEditingController searchTextController;

  var all = <User>[];
  var mutual = <User>[];
  var iLiked = <User>[];
  var likedMe = <User>[];

  var filteredUsers = <User>[].obs;

  final selectedFilterType = Rx<FilterType>(FilterType.all);

  @override
  void onInit() {
    super.onInit();
    getArguments();
    searchTextController = TextEditingController();
    searchTextController.addListener(() {
      var keyword = searchTextController.text.toString().trim();
      if (keyword.isEmpty) {
        filteredUsers.assignAll(getSelectedUserList());
      } else {
        filteredUsers.assignAll(getSelectedUserList().where((element) => element.userName!.toLowerCase().contains(keyword.toLowerCase())));
      }
    });
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  getArguments() {
    Map<String, dynamic>? data = Get.arguments;
    if (data != null) {
      all = data[AppConsts.keyListData];
      filteredUsers.assignAll(all);
      selectedFilterType.value = FilterType.all;
      separateUsers();
    }
  }

  filterUsers(FilterType filterType) {
    selectedFilterType.value = filterType;

    final keyword = searchTextController.text.toString().trim();

    switch (filterType) {
      case FilterType.mutual:
        if (keyword.isNotEmpty) {
          filteredUsers.assignAll(mutual.where((element) => element.userName!
              .toLowerCase()
              .contains(keyword.toLowerCase())));
        } else {
          filteredUsers.assignAll(mutual);
        }

        break;

      case FilterType.iLiked:
        if (keyword.isNotEmpty) {
          filteredUsers.assignAll(iLiked.where((element) => element.userName!
              .toLowerCase()
              .contains(keyword.toLowerCase())));
        } else {
          filteredUsers.assignAll(iLiked);
        }

        break;

      case FilterType.likedMe:
        if (keyword.isNotEmpty) {
          filteredUsers.assignAll(likedMe.where((element) => element.userName!
              .toLowerCase()
              .contains(keyword.toLowerCase())));
        } else {
          filteredUsers.assignAll(likedMe);
        }

        break;

      default:
        if (keyword.isNotEmpty) {
          filteredUsers.assignAll(all.where((element) => element.userName!
              .toLowerCase()
              .contains(keyword.toLowerCase())));
        } else {
          filteredUsers.assignAll(all);
        }
    }
  }

  separateUsers() {
    mutual.clear();
    likedMe.clear();
    iLiked.clear();
    for (final element in all) {
      if (element.iLiked == 1 && element.likedMe == 1) {
        mutual.add(element);
        continue;
      }
      if (element.iLiked == 0 && element.likedMe == 1) {
        likedMe.add(element);
        continue;
      }
      if (element.iLiked == 1 && element.likedMe == 0) {
        iLiked.add(element);
        continue;
      }
    }
  }

  List<User> getSelectedUserList(){
    switch (selectedFilterType.value) {
      case FilterType.mutual:
        return mutual;
      case FilterType.iLiked:
        return iLiked;
      case FilterType.likedMe:
        return likedMe;
        default:
        return all;
    }
  }
}

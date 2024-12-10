import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/views/pages/media_preview/media_preview_screen.dart';
import 'package:streax/views/widgets/common_app_bar.dart';

class GallerySwiper extends StatefulWidget {
  const GallerySwiper({
    super.key,
    required this.imagesList,
    required this.index,
  });

  final List<String> imagesList;
  final int  index;

  @override
  State<GallerySwiper> createState() => _GallerySwiperState();
}

class _GallerySwiperState extends State<GallerySwiper> {

  int get index => widget.index;

  late PageController _pageController;
  var _currentPage = 0;


  @override
  void initState() {
    _pageController = PageController(initialPage: index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      appBar: CommonAppBar(
        systemUiOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: AppColors.kPrimaryColor),
        backgroundColor: AppColors.kPrimaryColor,
        leadingIconColor: Colors.white,
        onBackTap: () {
          Get.back();
        },
        title: '',
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          _currentPage = index;
          setState(() {});
        },
        children: List.generate(
            widget.imagesList.length,
            (index) => MediaPreviewScreen(
                  mediaType: MediaType.image,
                  isAppBarVisible: false,
                  mediaUrl: widget.imagesList[index],
                )),
      ),
    );
  }
}

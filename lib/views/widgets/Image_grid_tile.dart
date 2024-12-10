import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/views/pages/media_preview/media_preview_screen.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';
import 'package:streax/views/widgets/gallery_swipper.dart';

class ImageGridTile extends StatelessWidget {
  const ImageGridTile(
      {super.key,
      required this.url,
      this.onRemoveTap,
      this.index,
      this.isGallery,
      this.imagesList});

  final String? url;
  final VoidCallback? onRemoveTap;
  final isGallery;
  final index;
  final imagesList;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isGallery == true
          ? () {
              Get.to(() => GallerySwiper(
                  index: index,
                  imagesList: imagesList));
            }
          : () {
              Get.to(() => MediaPreviewScreen(
                    mediaType: MediaType.image,
                    mediaUrl: url,
                  ));
            },
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.topRight,
        children: [
          CommonImageWidget(
            url: Helpers.getImgUrl(url),
            borderRadius: 8,
          ),
          if (onRemoveTap != null)
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                  onTap: onRemoveTap,
                  child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ))),
            )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_images.dart';
import 'package:streax/utils/extensions/extensions.dart';

class EmptyScreenWidget extends StatelessWidget {
  const EmptyScreenWidget({super.key, this.height, this.title, this.image});

  final double? height;
  final String? title;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(image ?? AppImages.imgNoData),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title ?? 'nothing_to_show_here'.tr,
              textAlign: TextAlign.center,
              softWrap: true,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 18.fontMultiplier,
                  color: AppColors.colorTextPrimary),
            ),
          )
        ],
      ),
    );
  }
}

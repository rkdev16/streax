import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/views/widgets/common_search_text_field.dart';
import '../../config/app_colors.dart';

class CommonSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonSearchAppBar(
      {super.key,

        this.hint,
        this.onBackTap,
        this.systemUiOverlayStyle,
        this.backgroundColor,
        this.leading,
        this.actions,
        this.leadingIconColor,
        required this.searchInputController,
         this.onSearchKeywordChange

      });


  final SystemUiOverlayStyle? systemUiOverlayStyle;
  final String? hint;
  final Color? backgroundColor;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onBackTap;
  final Color? leadingIconColor;
  final TextEditingController searchInputController;
  final Function(String value)? onSearchKeywordChange;


  @override
  Size get preferredSize =>const   Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle?? SystemUiOverlayStyle.light.copyWith(
        statusBarColor: backgroundColor??AppColors.kPrimaryColor
      ),
      child: Container(
        color: backgroundColor??AppColors.kPrimaryColor,
        padding: const EdgeInsets.only(top: 20.0,bottom: 16),
        child: SafeArea(
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            leading==null && onBackTap ==null? const  SizedBox.shrink() :  IconButton(
                icon: SvgPicture.asset(
                  AppIcons.icBack,
                  colorFilter: ColorFilter.mode(
                      leadingIconColor ?? Colors.white, BlendMode.srcIn),
                ),
                onPressed: onBackTap),

            Expanded(
              child: CommonSearchTextFiled(
                height: 45,
                margin: const  EdgeInsets.only(left:8,right: 30),

                onChanged: onSearchKeywordChange,
                controller: searchInputController,
                hintText: (hint??'search_near_by_shops').tr,
                backgroundColor: Colors.white,
                suffixIcon:  Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(AppIcons.icSearch,colorFilter: const  ColorFilter.mode(AppColors.colorTextSecondary,
                      BlendMode.srcIn),),
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

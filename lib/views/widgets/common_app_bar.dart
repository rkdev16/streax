import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/utils/extensions/extensions.dart';
import '../../config/app_colors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar(
      {super.key,
      this.title,
      this.onBackTap,
      this.centerTitle,
      this.systemUiOverlayStyle,
      this.backgroundColor,
      this.titleTextStyle,
      this.leading,
      this.toolBarHeight,
      this.actions,
      this.leadingIconColor,
      this.titleWidget,
        this.titleColor,
        this.leadingWidth
      });

  final String? title;
  final bool? centerTitle;
  final Function()? onBackTap;
  final SystemUiOverlayStyle? systemUiOverlayStyle;
  final Color? backgroundColor;
  final TextStyle? titleTextStyle;
  final Widget? leading;
  final List<Widget>? actions;
  final double? toolBarHeight;
  final Color? leadingIconColor;
  final Widget? titleWidget;
  final Color? titleColor;
  final double? leadingWidth;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      systemOverlayStyle: systemUiOverlayStyle ??
          Theme.of(context).appBarTheme.systemOverlayStyle,
      leadingWidth: leadingWidth,
      leading: leading?? IconButton(
        onPressed: onBackTap,
        icon: SvgPicture.asset(
              AppIcons.icBack,
              colorFilter: ColorFilter.mode(leadingIconColor ?? AppColors.colorTextPrimary, BlendMode.srcIn),
            ),
      ),
      title: titleWidget ??
          Text(title ?? ''.tr,
              style: titleTextStyle ??
                  Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: titleColor?? AppColors.colorTextPrimary,
                      fontSize: 18.fontMultiplier,
                      fontWeight: FontWeight.w700)),
      backgroundColor:
          backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
      centerTitle: centerTitle ?? true,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      actions: actions,
    );
  }
}

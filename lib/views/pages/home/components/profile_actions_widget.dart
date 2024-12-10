import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/model/user.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';






class ProfileActionsWidget extends StatelessWidget {
  const ProfileActionsWidget({
    super.key,
    required this.user,
    required this.onLikeTap,
    required this.onInstantChatTap,
    required this.onHangoutTap,
    required this.onCenterStageTap,
    required this.onSuperLikeTap,
    required this.isLoadingHangout


  });

  final User user;
  final VoidCallback onLikeTap;
  final VoidCallback onInstantChatTap;
  final VoidCallback onHangoutTap;
  final VoidCallback onCenterStageTap;
  final VoidCallback onSuperLikeTap;
  final bool isLoadingHangout;



  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      right: 16,
      child: Column(
        children: [
          IconButton(
              onPressed: onLikeTap,
              icon: SvgPicture.asset(
                  user.iLiked ==1
                      ? AppIcons.icHeartFilled
                      : AppIcons.icHeartOutline,
                  height: 30,
                  colorFilter:  ColorFilter.mode(user.iLiked == 1
                      ? AppColors.kPrimaryColor
                      :Colors.white, BlendMode.srcIn))),
          IconButton(
              padding: const  EdgeInsets.symmetric(vertical: 16),
              onPressed: onInstantChatTap,
              icon: SvgPicture.asset(AppIcons.icChatOutline,
                  height: 30, colorFilter: const  ColorFilter.mode(Colors.white, BlendMode.srcIn))),
          IconButton(
              padding: const  EdgeInsets.symmetric(vertical: 16),
              onPressed: onHangoutTap,
              icon: isLoadingHangout? const  CommonProgressBar(size: 30,strokeWidth: 3,): SvgPicture.asset(AppIcons.icGlassSvg,
                  height: 30, colorFilter: const  ColorFilter.mode(Colors.white, BlendMode.srcIn))),
          IconButton(
            // padding: const  EdgeInsets.symmetric(vertical: 8),
              onPressed: onSuperLikeTap,
              icon: SvgPicture.asset(AppIcons.icSmile,
                  height: 30,
                  colorFilter: ColorFilter.mode(user.superLike ==1 ? Colors.red : Colors.white, BlendMode.srcIn))),
          IconButton(
            padding: const  EdgeInsets.only(top: 16),
              onPressed: onCenterStageTap,
              icon: SvgPicture.asset(
                AppIcons.icStar,
                height: 30,
                colorFilter:  ColorFilter.mode(
                    user.isCenterStage == 1 ? AppColors.kPrimaryColor :
                    Colors.white, BlendMode.srcIn),
              )),



        ],
      ),
    );
  }
}

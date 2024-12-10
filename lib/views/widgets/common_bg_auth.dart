// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../config/app_colors.dart';
// import '../../config/size_config.dart';
// import '../../consts/app_consts.dart';
// import '../../consts/app_images.dart';
//
// class CommonBgAuth extends StatelessWidget {
//   const CommonBgAuth({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return    Container(
//       padding: const EdgeInsets.only(top: 40),
//       decoration:  const BoxDecoration(
//         color: AppColors.kPrimaryColor,
//           // image: DecorationImage(
//           //     image: AssetImage(AppImages.imgBg4),
//           //     fit: BoxFit.fitHeight)
//       ),
//       width: SizeConfig.widthMultiplier*100,
//       height: SizeConfig.heightMultiplier *25,
//
//       child: Align(
//         alignment: Alignment.center,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//
//             //Image.asset(AppImages.imgAppLogoWhite,scale: 4.5),
//             const SizedBox(width: 8.0),
//             Text(
//               'streax'.tr,
//               style:
//               Theme.of(context).textTheme.displayMedium?.copyWith(
//                 fontWeight: FontWeight.w600,fontFamily: 'Intern',
//                 color: Colors.white,
//                 fontSize: AppConsts.commonFontSizeFactor * 29,
//               ),
//             ),
//             //   SvgPicture.asset(AppIcons.icAppLogoWhite),
//
//
//
//           ],
//         ),
//       ),
//     );
//   }
// }

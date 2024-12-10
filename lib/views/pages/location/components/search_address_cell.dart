import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_place/google_place.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/utils/extensions/extensions.dart';

class SearchAddressCell extends StatelessWidget {
  const SearchAddressCell({super.key, required this.place, this.onClick});

  final AutocompletePrediction place;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.icMarkerFilled,
              width: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  place.description ?? "",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 15.fontMultiplier,
                      color: AppColors.colorTextPrimary),
                ),
              ),
            ),
            SvgPicture.asset(
              AppIcons.icNext,
              width: 18,
            ),
          ],
        ),
      ),
    );
  }
}

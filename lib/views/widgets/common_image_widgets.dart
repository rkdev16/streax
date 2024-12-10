import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:streax/consts/app_images.dart';
import 'package:streax/utils/helpers.dart';

class CommonImageWidget extends StatelessWidget {
  const CommonImageWidget(
      {super.key,
      required this.url,
      this.placeholder,
      this.errorPlaceholder,
      this.width,
      this.height,
      this.borderRadius,
      this.padding,
        this.fit
      });

  final String? url;
  final String? placeholder;
  final String? errorPlaceholder;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? borderRadius;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: url == null
            ? Image.asset(
                width: width ?? 100,
                height: height ?? 100,
                fit: BoxFit.cover,
                placeholder ?? AppImages.imgPlaceholder)
            : CachedNetworkImage(
                width: width ?? 100,
                height: height ?? 100,
                fit: fit?? BoxFit.cover,
                placeholderFadeInDuration: const Duration(milliseconds: 500),
                imageUrl: Helpers.getCompleteUrl(url),
                placeholder: (context, url) => placeholder == null
                    ? const CupertinoActivityIndicator()
                    : Image.asset(
                        placeholder ?? AppImages.imgPlaceholder,
                        fit: BoxFit.cover,
                      ),
                errorWidget: (context, url, error) => Image.asset(
                    errorPlaceholder ?? placeholder ?? AppImages.imgErrorPlaceholder,
                    fit: BoxFit.cover),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/utils/extensions/extensions.dart';

class SearchInputField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hint;
  Widget? leading;
  Widget? trailing;
  RxBool? isShowTrailing;
  double? height;
  EdgeInsets? margin;
  VoidCallback? onClearFiled;

  SearchInputField(
      {super.key,
      required this.controller,
      required this.onChanged,
      required this.hint,
      this.leading,
      this.trailing,
      this.isShowTrailing,
      this.height,
      this.margin,
      this.onClearFiled});

  OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.colorTextSecondary));

  bool showClearIcon = false;

  @override
  State<SearchInputField> createState() => _SearchInputFieldState();
}

class _SearchInputFieldState extends State<SearchInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            floatingLabelAlignment: FloatingLabelAlignment.center,
            alignLabelWithHint: true,
            hintText: widget.hint,
            hintStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.colorTextSecondary.withOpacity(0.7),
                fontSize: 12.fontMultiplier),
            prefixIcon: widget.leading ?? Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: SvgPicture.asset(
                    AppIcons.icSearch,
                    height: 24,
                    width: 24,
                    colorFilter: const ColorFilter.mode(
                        AppColors.kPrimaryColor, BlendMode.srcIn),
                  ),
                ),
            suffixIcon: widget.showClearIcon
                ? IconButton(
                    onPressed: () {
                      widget.onClearFiled??();
                      setState(() {
                        widget.controller.clear();
                        widget.showClearIcon = false;
                      });
                    },
                    icon: const Icon(
                      Icons.cancel,
                      size: 24,
                      color: AppColors.kPrimaryColor,
                    ))
                : const SizedBox(),
            border: widget.border,
            focusedBorder: widget.border,
            enabledBorder: widget.border,
            focusedErrorBorder: widget.border,
            errorBorder: widget.border,
            disabledBorder: widget.border),
        cursorColor: AppColors.kPrimaryColor,
        keyboardType: TextInputType.text,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.colorTextPrimary,
              fontSize: 14.fontMultiplier,
            ),
        onChanged: (text) {
          setState(() {
            widget.showClearIcon = text.isNotEmpty;
          });
          widget.onChanged(text);
        },
      ),
    );
  }
}

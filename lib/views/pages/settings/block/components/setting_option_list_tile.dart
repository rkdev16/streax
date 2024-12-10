import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/model/common_options_model.dart';
import 'package:streax/views/widgets/common_card_widget.dart';

class SettingsOptionListTile extends StatelessWidget {
  const SettingsOptionListTile({super.key, required this.option});

  final OptionModel option;

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      onTap: option.action,
      margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(option.title.tr,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          Icon(
            Icons.navigate_next_rounded,
            color: Colors.black.withOpacity(0.9),
          ),
        ],
      ),
    );
  }
}

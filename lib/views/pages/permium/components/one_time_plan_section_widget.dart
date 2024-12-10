

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:streax/model/one_time_purchases_res_model.dart';
import 'package:streax/views/pages/permium/components/one_time_plan_widget.dart';

class OneTimePlanSectionWidget extends StatelessWidget {
  const OneTimePlanSectionWidget({
    super.key,
    required this.plansData
  });

 final  OneTimePlansData plansData;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(items: plansData.records?.map((plan) => OneTimePlanWidget(plan: plan)).toList(growable: false),
        options: CarouselOptions(
          aspectRatio: 16/6.95,
          // height: 180,
          viewportFraction: 0.9,
          enableInfiniteScroll: false

        ));
  }
}

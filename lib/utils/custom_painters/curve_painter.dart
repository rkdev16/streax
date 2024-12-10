
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/app_colors.dart';

class CurvePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {


    var paint = Paint();
    paint.color = AppColors.kPrimaryColor;
    paint.style = PaintingStyle.fill;
    //todo Draw your path
    var path = Path();
    path.moveTo(0,
        size.height * 0.15);
    path.quadraticBezierTo(
        size.width/2, size.height * 0.20,
        size.width,
        size.height * 0.15);
    path.lineTo(size.width, 0);

    path.lineTo(0, 0);

    canvas.drawPath(path, paint);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

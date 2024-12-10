import 'package:flutter/material.dart';
import 'package:streax/config/app_colors.dart';


class CurvePainter2 extends CustomPainter {

  //CurvePainter2({required this.curveHeight});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = AppColors.kPrimaryColor;
    paint.style = PaintingStyle.fill;




    var path = Path();

    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(
        size.width /2.5,
        size.height / 2.5, size.width, size.height * 0.28);
    path.lineTo(size.width,0 );
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

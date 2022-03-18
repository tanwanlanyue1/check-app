import 'package:flutter/material.dart';
import 'package:scet_check/utils/screen/screen.dart';
///登录背景半圆
class MyPainter extends CustomPainter {
  Rect rect2 = Rect.fromCircle(center: Offset(200.0, Adapt.screenH()+px(50)), radius: px(600));

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..shader = LinearGradient(colors: const [Color(0xff80A2FF), Color(0xff4D7DFF)]).createShader(rect2);
    const pI = 3.1415;

    canvas.drawArc(rect2, 0.0, -pI, true, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
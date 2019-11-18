import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CirclePainter extends CustomPainter {

  final Color color;
  final bool isAntialias;
  final double strokeWidth;
  final PaintingStyle paintingStyle;

  CirclePainter({this.color = Colors.white, this.strokeWidth = 10, this.isAntialias = true, this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = new Paint();
    paint.color = this.color;
    paint.isAntiAlias = this.isAntialias;
    paint.strokeWidth = this.strokeWidth;
    paint.style = this.paintingStyle;

    //TODO: Change offset and size accordingly
    canvas.drawCircle(new Offset(0, 0), 35, paint);

  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate.strokeWidth != this.strokeWidth ||
        oldDelegate.isAntialias != this.isAntialias ||
        oldDelegate.color != this.color;
  }

}
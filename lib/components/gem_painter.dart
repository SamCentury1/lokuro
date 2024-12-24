import 'dart:math';

import 'package:flutter/material.dart';

class GemPainter1  extends CustomPainter {
  final Color color;

  const GemPainter1({
    required this.color
  });

  @override
  void paint(Canvas canvas, Size size) {



    final double incremenet = size.width/10;
    final double xOrigin = size.width/2;
    final double yOrigin = size.height/2;
    final double starXOrigin = (size.width/2);
    final double starYOrigin = (size.height/2) - (2 * incremenet);

    Paint paint1 = Paint();
    paint1.color = Color.lerp(color, Colors.black, 0.5) ?? color;
    Paint paint2 = Paint();
    paint2.color = Color.lerp(color, Colors.black, 0.3) ?? color;
    Paint paint3 = Paint();
    paint3.color = Color.lerp(color, Colors.white, 0.8) ?? color;
    Paint paint4 = Paint();
    paint4.color = Color.lerp(color, Colors.white, 0.3) ?? color;
    Paint paint5 = Paint();
    paint5.color = Color.lerp(color, Colors.white, 0.0) ?? color;

    List<Paint> paints = [paint1, paint2, paint3, paint4, paint5];

    Paint whitePaint = Paint();
    whitePaint.color = Colors.white;    

    Path mainSquare = Path();
    mainSquare.moveTo(xOrigin + (0.0 * incremenet) , yOrigin - (2.0 * incremenet));
    mainSquare.lineTo(xOrigin + (2.0 * incremenet) , yOrigin + (0.0 * incremenet));
    mainSquare.lineTo(xOrigin + (0.0 * incremenet) , yOrigin + (2.0 * incremenet));
    mainSquare.lineTo(xOrigin - (2.0 * incremenet) , yOrigin + (0.0 * incremenet));

    Path topRightRect = Path();
    topRightRect.moveTo(xOrigin + (0.0 * incremenet) , yOrigin - (2.0 * incremenet));
    topRightRect.lineTo(xOrigin + (0.0 * incremenet) , yOrigin - (4.0 * incremenet));
    topRightRect.lineTo(xOrigin + (4.0 * incremenet) , yOrigin - (0.0 * incremenet));
    topRightRect.lineTo(xOrigin + (2.0 * incremenet) , yOrigin - (0.0 * incremenet));

    Path bottomRightRect = Path();
    bottomRightRect.moveTo(xOrigin + (2.0 * incremenet) , yOrigin - (0.0 * incremenet));    
    bottomRightRect.lineTo(xOrigin + (4.0 * incremenet) , yOrigin - (0.0 * incremenet));
    bottomRightRect.lineTo(xOrigin + (0.0 * incremenet) , yOrigin + (4.0 * incremenet));
    bottomRightRect.lineTo(xOrigin + (0.0 * incremenet) , yOrigin + (2.0 * incremenet));

    Path bottomLeftRect = Path();
    bottomLeftRect.moveTo(xOrigin + (0.0 * incremenet) , yOrigin + (2.0 * incremenet));
    bottomLeftRect.lineTo(xOrigin + (0.0 * incremenet) , yOrigin + (4.0 * incremenet));
    bottomLeftRect.lineTo(xOrigin - (4.0 * incremenet) , yOrigin - (0.0 * incremenet));
    bottomLeftRect.lineTo(xOrigin - (2.0 * incremenet) , yOrigin - (0.0 * incremenet));

    Path topLeftRect = Path();
    topLeftRect.moveTo(xOrigin - (2.0 * incremenet) , yOrigin - (0.0 * incremenet));
    topLeftRect.lineTo(xOrigin - (4.0 * incremenet) , yOrigin - (0.0 * incremenet));
    topLeftRect.lineTo(xOrigin - (0.0 * incremenet) , yOrigin - (4.0 * incremenet));
    topLeftRect.lineTo(xOrigin - (0.0 * incremenet) , yOrigin - (2.0 * incremenet));

    Path starPath = getStarPath(starXOrigin,starYOrigin,(incremenet*2));

    // paints.shuffle();

    canvas.drawPath(mainSquare,paints[0]);
    canvas.drawPath(topRightRect,paints[1]);
    canvas.drawPath(bottomRightRect,paints[2]);
    canvas.drawPath(bottomLeftRect,paints[3]);
    canvas.drawPath(topLeftRect,paints[4]);
    canvas.drawPath(starPath,whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

Path getStarPath(double x, double y, double inc) {
  Path starPath = Path();
  starPath.moveTo(x + (0.0 * inc) , y - (1.0 * inc));
  starPath.lineTo(x - (0.1 * inc) , y - (0.1 * inc));
  starPath.lineTo(x - (1.0 * inc) , y + (0.0 * inc));
  starPath.lineTo(x - (0.1 * inc) , y + (0.1 * inc));
  starPath.lineTo(x + (0.0 * inc) , y + (1.0 * inc));
  starPath.lineTo(x + (0.1 * inc) , y + (0.1 * inc));
  starPath.lineTo(x + (1.0 * inc) , y + (0.0 * inc));
  starPath.lineTo(x + (0.1 * inc) , y - (0.1 * inc));
  starPath.close();
  return starPath;
}
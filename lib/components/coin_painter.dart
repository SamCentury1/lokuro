import 'package:flutter/material.dart';

class CoinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define colors
    final coinColor = const Color.fromARGB(255, 187, 119, 3);
    final shadowColor = Colors.amber.shade900;
    final highlightColor = Colors.amber.shade300;
    final dollarSignColor = const Color.fromARGB(255, 167, 99, 10);

    // Coin base circle
    final basePaint = Paint()..color = coinColor;
    final baseShadowPaint = Paint()..color = shadowColor.withOpacity(0.6);
    final highlightPaint = Paint()..color = highlightColor.withOpacity(0.5);
    final outlinePaint = Paint()..color = Colors.black.withOpacity(1.0);

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.50,
      outlinePaint,
    );    

    // Draw the shadow for the coin    
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.49,
      baseShadowPaint,
    );

    // Draw the base coin circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.48,
      basePaint,
    );

    // Draw a lighter highlight circle for 3D effect
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.40,
      highlightPaint,
    );

    // Dollar sign in the middle
    final textStyle = TextStyle(
      color: dollarSignColor,
      fontSize: size.width * 0.66,
      fontWeight: FontWeight.bold,
    );
    final textSpan = TextSpan(
      text: '\$',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CoinPainter oldDelegate) {
    return false;
  }
}

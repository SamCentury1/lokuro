import 'package:flutter/material.dart';
import 'package:lokuro/functions/general.dart';
import 'package:lokuro/functions/helpers.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'dart:ui' as ui;

class WindupPainter extends CustomPainter {
  final GamePlayState gamePlayState;
  WindupPainter({
    required this.gamePlayState,
  });

  @override
  void paint(Canvas canvas, Size size) {

    Paint linePaint = Paint();
    linePaint.color = const Color.fromARGB(255, 70, 70, 70);
    linePaint.strokeWidth = 2.0;
    linePaint.style = PaintingStyle.stroke;   

    Paint targetPaint = Paint();
    targetPaint.color = const Color.fromARGB(255, 43, 43, 43);

    
    

    // Drawing the obstacles
    for (Map<String, dynamic> obstacleObject in gamePlayState.obstacleData) {
      if (obstacleObject["active"] && obstacleObject["key"] != 0) {
        // Paint obstaclePaint = Paint();
        // obstaclePaint.color = gamePlayState.colors[obstacleObject["colorKey"]];
        // obstaclePaint.style = PaintingStyle.fill;

        // Map<String, dynamic> areaData = Helpers().getObstacleAreaData(obstacleObject);
        // double minX = areaData["x"][0];
        // double minY = areaData["y"][0];
        // double maxX = areaData["x"][areaData["x"].length-1];
        // double maxY = areaData["y"][areaData["y"].length-1];

        // Color color = gamePlayState.colors[obstacleObject["colorKey"]];

        // Paint obstaclePaint = Paint();
        // obstaclePaint.shader = ui.Gradient.linear(
        //   Offset((minX + maxX) / 2, minY), // Top-center of the shape
        //   Offset((minX + maxX) / 2, maxY), // Bottom-center of the shape
        //   [
        //     color,
        //     Color.lerp(color, Colors.white, 0.5) ?? color,
        //   ],
        // );
        // obstaclePaint.style = PaintingStyle.fill; 
        //
        // Paint obstaclePaint = General().getObstaclePaint(obstacleObject, gamePlayState, 1.0);       
        Path obstaclePath = obstacleObject["path"];
        // Path obstaclePath = Path();
        // obstaclePath.moveTo(obstacleObject["points"][0].dx, obstacleObject["points"][0].dy);
        // for (int i = 1; i < obstacleObject["points"].length; i++) {
        //   obstaclePath.lineTo(obstacleObject["points"][i].dx, obstacleObject["points"][i].dy);
        // }

        // Close the path to properly render the shadow
        obstaclePath.close();

        // Draw shadow first
        canvas.drawShadow(obstaclePath, Colors.black, 5.0, false);

        Offset origin = General().getOrigin(obstacleObject, size);
        // List<Map<String,dynamic>> jewelData = General().getJewelShapeData(origin, obstacleObject, size, gamePlayState,1.0, 0.5);
        Paint obstaclePaint = General().getObstaclePaint(origin, obstacleObject, gamePlayState, 1.0,0);
        canvas.drawPath(obstaclePath,obstaclePaint);        
        List<Map<String,dynamic>> jewelData = General().getJewelShapeData2(origin, obstacleObject, size, gamePlayState, 1.0, 0.5);
        
        // if (obstacleObject["isCircle"]) {
        //   Paint obstaclePaint = General().getObstaclePaint(obstacleObject, gamePlayState, 1.0);
        //   obstaclePath.close();
        //   canvas.drawPath(obstaclePath, obstaclePaint);
        
        // }        
        for (int i=0; i<jewelData.length; i++) {
          Map<String,dynamic> jewelPiece = jewelData[i];
          Path jewelPiecePath = jewelPiece["path"];
          jewelPiecePath.close();
          Paint jewelPiecePaint = jewelPiece["paint"];
          canvas.drawPath(jewelPiecePath,jewelPiecePaint);    
        }
                
        // Draw the obstacle on top of the shadow
        // canvas.drawPath(obstaclePath, obstaclePaint);

      }
    } 

    // drawing the boundaries
    for (int i=0;i<gamePlayState.boundaryData.length; i++) {
      Map<String,dynamic> boundaryObject = gamePlayState.boundaryData[i];
      if (boundaryObject["active"]) {
        Paint boundaryPaint = Paint()..color = Colors.black;
        // canvas.drawPath(boundaryObject["path"], boundaryPaint);
        List<Offset> boundaryPoints = boundaryObject["points"];
        Path boundaryPath = Path();
        boundaryPath.moveTo(boundaryPoints[0].dx,boundaryPoints[0].dy);
        for (int i=1; i<boundaryPoints.length; i++) {
          boundaryPath.lineTo(boundaryPoints[i].dx, boundaryPoints[i].dy);
        }
        boundaryPath.close();
        canvas.drawPath(boundaryPath,boundaryPaint);
      }
    }

  


    // point sizes
    // final double dot = size.width*0.01;
    // final double tinyDot = size.width*0.01;

    // linecoordinates
    final Offset? startPoint = gamePlayState.startPoint;
    final Offset? updatePoint = gamePlayState.updatePoint;

    // line path
    if (startPoint != null && updatePoint != null) {
      Path linePath = Path();
      linePath.moveTo(startPoint.dx,startPoint.dy);
      linePath.lineTo(updatePoint.dx,updatePoint.dy);
      canvas.drawPath(linePath, linePaint);
    }


    List<Offset> targetPath = Helpers().getShotPath(gamePlayState);
    for (Offset stop in targetPath) {
      canvas.drawCircle(stop, 1.0, targetPaint);
    }


    // draw the ball
    final double dot = size.width * 0.01;
    canvas.drawCircle(startPoint!, dot, targetPaint);      

  }

  @override
  bool shouldRepaint(covariant WindupPainter oldDelegate) {
    return true;
  }
} 
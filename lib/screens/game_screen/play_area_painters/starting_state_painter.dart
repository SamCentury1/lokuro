import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lokuro/functions/general.dart';
import 'package:lokuro/functions/helpers.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';

class StartingStatePainter extends CustomPainter {
  final GamePlayState gamePlayState;
  final SettingsState settingsState;
  final Animation<double> startingAnimation;
  StartingStatePainter({
    required this.gamePlayState,
    required this.settingsState,
    required this.startingAnimation,
  });

  @override
  void paint(Canvas canvas, Size size) {

    // Drawing the obstacles

    if (gamePlayState.levelTransition[0] != null) {
      // final int previousLevel = gamePlayState.levelTransition[0]!;
      // final List<Map<String,dynamic>> previousObstacles = settingsState.levelData[previousLevel]["obstacles"];
      Paint blackPaint = Paint()..color = Colors.black.withOpacity(0.2);

      // final double furthestYCoordinate = getFurthestYCoordinate(gamePlayState.previousLevelObstacleData);

      for (int i=0; i<gamePlayState.previousLevelObstacleData.length; i++) {
        Map<String,dynamic> previousLevelObstacle = gamePlayState.previousLevelObstacleData[i];
        if (previousLevelObstacle["key"] != 0) {
          // Offset origin = General().getOrigin(previousLevelObstacle, size);
          // canvas.drawCircle(origin, 2.0, blackPaint);
          Path previousObstaclePath = Path(); 
          previousObstaclePath = General().getPreviousObstacleShape(previousLevelObstacle,size, (startingAnimation.value*settingsState.playAreaSize.height));
          previousObstaclePath.close();
          canvas.drawPath(previousObstaclePath, blackPaint);

        }
      }

    }

    for (Map<String, dynamic> obstacleObject in gamePlayState.obstacleData) {
      if (obstacleObject["active"] && obstacleObject["key"] != 0) {

        // final int index = (startingAnimation.value * (obstacleObject["startingAnimationOpacity"].length-1)).floor();
        // final double opacity =  obstacleObject["startingAnimationOpacity"][index];
        final double opacity = 1.0;

        // Close the path to properly render the shadow

        // Draw shadow first
        // double shadowOpacity = opacity < 0.9? 0.0 : opacity;

        Offset origin = General().getOrigin(obstacleObject, size);
        double updatedYValue = (origin.dy + settingsState.playAreaSize.height) - startingAnimation.value*settingsState.playAreaSize.height;
        Offset origin2 = Offset(origin.dx, updatedYValue);

        // Path obstaclePath = obstacleObject["path"];
        Path obstaclePath = General().getShapeData(origin2, obstacleObject, size);
        canvas.drawShadow(
          obstaclePath, 
          Color.lerp(Colors.transparent, Colors.black.withOpacity(opacity), opacity) ?? Colors.black.withOpacity(opacity),
          5.0, 
          false
        );          

        Paint obstaclePaint = General().getObstaclePaint(origin2, obstacleObject, gamePlayState, opacity,0);
        canvas.drawPath(obstaclePath,obstaclePaint);

        // Paint redPaint = Paint();
        // redPaint.color = Colors.red;
        // canvas.drawCircle(origin, 3.0, redPaint);


        // List<Map<String,dynamic>> jewelData = General().getJewelShapeData(origin2, obstacleObject, size, gamePlayState, opacity, 0.5);
        List<Map<String,dynamic>> jewelData = General().getJewelShapeData2(origin2, obstacleObject, size, gamePlayState, opacity, 0.5);
        for (int i=0; i<jewelData.length; i++) {
          Map<String,dynamic> jewelPiece = jewelData[i];
          Path jewelPiecePath = jewelPiece["path"];
          jewelPiecePath.close();
          Paint jewelPiecePaint = jewelPiece["paint"];
          canvas.drawPath(jewelPiecePath,jewelPiecePaint);    
        }
        
      }
    }



    
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


    /// TESTING
    


  }

  @override
  bool shouldRepaint(covariant StartingStatePainter oldDelegate) {
    return true;
  }
}


List<double> getOpacityArray() {
  List<double> res = [];
  for (int i=0; i<50; i++){
    double val = i/50;
    res.add(val);
  }

  for (int i=0; i<20; i++){
    res.add(1.0);
  }

  for (int i=30; i>=0; i--){
    double val = i/30;
    res.add(val);
  }
  return res; 
}


List<double> getYPositionArray() {
  List<double> res = [];
  for (int i=0; i<70; i++){
    double val = i/140;
    res.add(val);
  }

//   for (int i=0; i<20; i++){
//     res.add(0.5);
//   }

  for (int i=0; i<=30; i++){
    double val = 0.5 + (i/60);
    res.add(val);
  }
  return res;
}

double getFurthestYCoordinate(List<Map<String,dynamic>> obstacles) {
  List<double> ys = [];
  for (int i=0;i<obstacles.length;i++) {
    if (obstacles[i]["key"] != 0) {
      for (int j=0; j<obstacles[i]["points"].length; j++) {
        ys.add(obstacles[i]["points"][j].dy);
      }
    }
  }
  ys.sort();
  return ys.last;
}
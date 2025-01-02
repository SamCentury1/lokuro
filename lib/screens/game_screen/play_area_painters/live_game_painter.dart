import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lokuro/functions/general.dart';
import 'package:lokuro/functions/helpers.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'dart:ui' as ui;

class LiveGamePainter extends CustomPainter {
  final GamePlayState gamePlayState;
  LiveGamePainter({
    required this.gamePlayState,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint ballPaint = Paint();
    ballPaint.color = Colors.black;
     
    // ballPaint.strokeWidth = 3.0;
    // ballPaint.style = PaintingStyle.stroke;
    final double dot = size.width * 0.01;

    // Drawing the obstacles
    for (Map<String, dynamic> obstacleObject in gamePlayState.obstacleData) {
      if (obstacleObject["key"] != 0) {

        late double opacity = 1.0;
        late double explosionOpacity = 0.0;

        late Color blockColor = gamePlayState.colors[obstacleObject["colorKey"]];
      
        bool isBlockAnimating = Helpers().getIsBlockAnimating(gamePlayState,obstacleObject["key"]);


        if (isBlockAnimating) {

          late Map<String, dynamic> collisionData = Helpers().getBlockAnimationData(gamePlayState,obstacleObject["key"]);

          double animationProgress = collisionData["animations"]["animationProgress"];
          Path borderPath = General().getShapeDataWhileAnimating(obstacleObject, size, animationProgress);
          Paint borderPaint = Paint();
          borderPaint.color = blockColor.withOpacity(animationProgress);
          borderPaint.strokeWidth = 3.0 - (3.0*animationProgress);
          borderPaint.style = PaintingStyle.stroke;
          canvas.drawPath(borderPath,borderPaint);

          opacity = collisionData["animations"]["blockOpacity"];
          explosionOpacity = 1.0 - animationProgress;
          /// explosion
          Paint explosionPaint = Paint();
          explosionPaint.style = PaintingStyle.fill;



          for (Map<String,dynamic> particleData in collisionData["animations"]["explosionData"]) {

            Paint explosionPaint = Paint();
            explosionPaint.style = PaintingStyle.fill;
            explosionPaint.color = Color.lerp(blockColor,Colors.white,particleData["color"])!.withOpacity(explosionOpacity);
            final double particleSize = particleData["size"];
            final double particleDistance = particleData["distance"] * collisionData["animations"]["animationProgress"];
            final Offset particlePosition = Helpers().getParticlePoint(particleData["angle"], collisionData["position"],particleDistance);
            // final Rect explosionRect = Rect.fromCenter(center: particlePosition, width: collisionData["size"], height: collisionData["size"]);
            Path particleShape = getParticleShapePath(particlePosition,particleData["shape"]);
            
            canvas.drawPath(particleShape,explosionPaint);
            // canvas.drawCircle(particlePosition, particleSize, explosionPaint);
            // canvas.drawRect(explosionRect, explosionPaint);
          }          


        } else {
          opacity = obstacleObject["active"] ? 1.0 : 0.0;
          explosionOpacity = 0.0;
        }
  
        // Paint obstaclePaint = General().getObstaclePaint(obstacleObject, gamePlayState, opacity);


        Path obstaclePath = obstacleObject["path"];
        // Path obstaclePath = Helpers().createBezierPath(obstacleObject["points"],15.0);

        // Close the path to properly render the shadow
        obstaclePath.close();

        // Draw shadow first
        if (opacity == 1.0) {
          canvas.drawShadow(obstaclePath, Colors.black.withOpacity(opacity), 5.0, false);
        }


        Offset origin = General().getOrigin(obstacleObject, size);
        Paint obstaclePaint = General().getObstaclePaint(origin, obstacleObject, gamePlayState, opacity,0);
        canvas.drawPath(obstaclePath,obstaclePaint);
        List<Map<String,dynamic>> jewelData = General().getJewelShapeData2(origin, obstacleObject, size, gamePlayState, opacity, 0.5);
        for (int i=0; i<jewelData.length; i++) {
          Map<String,dynamic> jewelPiece = jewelData[i];
          Path jewelPiecePath = jewelPiece["path"];
          jewelPiecePath.close();
          Paint jewelPiecePaint = jewelPiece["paint"];
          canvas.drawPath(jewelPiecePath,jewelPiecePaint);    
        }
      }
    }


    // drawing the boundaries
    for (int i=0;i<gamePlayState.boundaryData.length; i++) {
      Map<String,dynamic> boundaryObject = gamePlayState.boundaryData[i];



      // late double explosionOpacity = 0.0;

      // late Color blockColor = Colors.black;
      
    
      // bool isBlockAnimating = Helpers().getIsBoundaryAnimating(gamePlayState,boundaryObject["hitOrder"]);

      // if (isBlockAnimating) {
      //   late Map<String, dynamic> collisionData = Helpers().getBoundaryAnimationData(gamePlayState,boundaryObject["key"]);
      //   double animationProgress = collisionData["animations"]["animationProgress"];
      //   explosionOpacity = 1.0 - animationProgress;
      //   for (Map<String,dynamic> particleData in collisionData["animations"]["explosionData"]) {

      //     Paint explosionPaint = Paint();
      //     explosionPaint.style = PaintingStyle.fill;
      //     explosionPaint.color = Color.lerp(blockColor,const Color.fromARGB(255, 44, 44, 44),particleData["color"])!.withOpacity(explosionOpacity);
      //     final double particleSize = particleData["size"];
      //     final double particleDistance = particleData["distance"] * collisionData["animations"]["animationProgress"];
      //     final Offset particlePosition = Helpers().getParticlePoint(particleData["angle"], collisionData["position"],particleDistance);
          
      //     if (particleData["points"] >= 3) {
      //       // final Rect explosionRect = Rect.fromCenter(center: particlePosition, width: collisionData["size"], height: collisionData["size"]);
      //       Path particleShape = getParticleShapePath(particlePosition,particleData["shape"]);

      //       canvas.drawPath(particleShape,explosionPaint);
      //     } else {
      //       canvas.drawCircle(particlePosition, particleSize, explosionPaint);
      //     }
      //     // canvas.drawRect(explosionRect, explosionPaint);
      //   }   
      // } else {
      //   explosionOpacity = 0.0;        
      // }

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


    for (int i=0; i<gamePlayState.boundaryHitData.length;i++) {
      Map<String,dynamic> boundaryObject = gamePlayState.boundaryHitData[i];

      late double explosionOpacity = 0.0;
      late Color blockColor = Colors.black;
      
      bool isBlockAnimating = Helpers().getIsBoundaryAnimating(gamePlayState,boundaryObject["hitOrder"]);

      if (isBlockAnimating) {
        late Map<String, dynamic> collisionData = Helpers().getBoundaryAnimationData(gamePlayState,boundaryObject["hitOrder"]);
        double animationProgress = collisionData["animations"]["animationProgress"];
        explosionOpacity = 1.0 - animationProgress;
        for (Map<String,dynamic> particleData in collisionData["animations"]["explosionData"]) {

          Paint explosionPaint = Paint();
          explosionPaint.style = PaintingStyle.fill;
          explosionPaint.color = Color.lerp(blockColor,const Color.fromARGB(255, 44, 44, 44),particleData["color"])!.withOpacity(explosionOpacity);
          final double particleSize = particleData["size"];
          final double particleDistance = particleData["distance"] * collisionData["animations"]["animationProgress"];
          final Offset particlePosition = Helpers().getParticlePoint(particleData["angle"], collisionData["position"],particleDistance);
          
          if (particleData["points"] >= 3) {
            // final Rect explosionRect = Rect.fromCenter(center: particlePosition, width: collisionData["size"], height: collisionData["size"]);
            Path particleShape = getParticleShapePath(particlePosition,particleData["shape"]);

            canvas.drawPath(particleShape,explosionPaint);
          } else {
            canvas.drawCircle(particlePosition, particleSize, explosionPaint);
          }
          // canvas.drawRect(explosionRect, explosionPaint);
        }   
      } else {
        explosionOpacity = 0.0;        
      }      
    }


    // drawing the ball
    final Offset? ballPoint = gamePlayState.currentBallPoint;
    if (ballPoint != null) {
      if (gamePlayState.isGameOver) {
        Paint endOfGamePaint = Paint();
        endOfGamePaint.color = Colors.black.withOpacity(gamePlayState.endOfGameBallOpacity);
        canvas.drawCircle(ballPoint, dot, endOfGamePaint);
      } else {
        canvas.drawCircle(ballPoint, dot, ballPaint);

        Paint trailPaint = Paint();
        for (int i=0; i<gamePlayState.ballTrailEffect.length;i++) {
          final double trailPointOpacity = (i / gamePlayState.ballTrailEffect.length); 
          trailPaint.color = const Color.fromARGB(255, 71, 71, 71).withOpacity(trailPointOpacity);

          final Offset trailPoint = gamePlayState.ballTrailEffect[i];
          canvas.drawCircle(trailPoint, dot*trailPointOpacity, trailPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant LiveGamePainter oldDelegate) {
    return true;
  }
} 


Path getParticleShapePath(Offset origin, List<Map<String,dynamic>> shapeData) {
  Path path = Path();
  Offset firstPoint = Helpers().getParticlePoint(shapeData[0]["angle"], origin, shapeData[0]["distance"]);
  path.moveTo(firstPoint.dx, firstPoint.dy);
  for (int i=1; i<shapeData.length; i++) {
    Offset point = Helpers().getParticlePoint(shapeData[i]["angle"], origin, shapeData[i]["distance"]);
    path.lineTo(point.dx, point.dy);
  }
  return path;
}

// Offset getPointLocation(Offset origin, Map<String,dynamic> shapeData) {
//   late double angleThetaRadians = shapeData["angle"] * pi / 180;
//   double a = shapeData["distance"] * sin(angleThetaRadians);
//   double b = shapeData["distance"] * cos(angleThetaRadians);
//   late double targetPointX = point!.dx + b;
//   late double targetPointY = point!.dy + a;  
// }
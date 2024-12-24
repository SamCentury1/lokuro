import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lokuro/models/level_model.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';

class Helpers {


  double calculateAngleBetweenTwoPoints(Offset? point1, Offset? point2) {
    double startX = point1?.dx ?? 0;
    double startY = point1?.dy ?? 0;

    double endX = point2?.dx ?? 0;
    double endY = point2?.dy ?? 0;

    final double xLength = endX-startX;
    final double yLength = endY-startY;

    double angleInRadians = atan2(yLength, xLength);
    double angleInDegrees = angleInRadians * (180.0 / pi);

    if (angleInDegrees < 0) {
      angleInDegrees += 360;
    }

    final double res = double.parse(angleInDegrees.toStringAsFixed(2));
    return res;
  }  


  Offset getBallEndPoint(GamePlayState gamePlayState, Offset? point, double distance) {
    late double angleThetaRadians = gamePlayState.lineAngle * pi / 180;
    double a = distance * sin(angleThetaRadians);
    double b = distance * cos(angleThetaRadians);

    late double targetPointX = point!.dx + b;
    late double targetPointY = point!.dy + a;
    return Offset(targetPointX, targetPointY);
  }



  List<Map<String,dynamic>> getBorderData(GamePlayState gamePlayState) {
    late List<Map<String,dynamic>> res = [];
    
    for (Map<String,dynamic> obstacleData in gamePlayState.obstacleData) {
      List<Offset> obstaclePoints = obstacleData["points"];
      // print("get border data function => $obstacleData");
      for (int i=0; i<obstaclePoints.length; i++) {
        if(obstacleData["active"]) {
          Offset point1 = obstaclePoints[i];
          final int i2 = i == (obstaclePoints.length-1) ? 0 : (i + 1);
          Offset point2 = obstaclePoints[i2];
          double angle = calculateAngleBetweenTwoPoints(point1, point2);
          // Map<String,dynamic> lineData = {"obstacleKey":obstacleData["key"], "point1":point1, "point2": point2, "angle": angle};
          Map<String,dynamic> lineData = {"type":"obstacle","key":obstacleData["key"], "point1":point1, "point2": point2, "angle": angle};
          res.add(lineData);
        }
      }
    }

    for (int i=0; i<gamePlayState.boundaryData.length; i++) {
      Map<String,dynamic> boundary = gamePlayState.boundaryData[i];
      if (boundary["active"]) {

        List<Offset> boundaryPoints = boundary["points"];
        for (int j=0; j<boundaryPoints.length; j++) {
          Offset point1 = boundaryPoints[j];
          final int j2 = j == (boundaryPoints.length-1) ? 0 : (j + 1);
          Offset point2 = boundaryPoints[j2];
          double angle = calculateAngleBetweenTwoPoints(point1, point2);
          Map<String,dynamic> lineData = {"type":"boundary","key":boundary["key"], "point1":point1, "point2": point2, "angle": angle};
          res.add(lineData);        
        }
      }
    }
    return res;
  }

  Offset? findIntersection(Offset p1, Offset p2, Offset p3, Offset p4) {
    double dx1 = p2.dx - p1.dx;
    double dy1 = p2.dy - p1.dy;
    double dx2 = p4.dx - p3.dx;
    double dy2 = p4.dy - p3.dy;

    double denominator = dx1 * dy2 - dy1 * dx2;

    if (denominator == 0) {
      return null;
    }

    double dx3 = p3.dx - p1.dx;
    double dy3 = p3.dy - p1.dy;

    double s = (dx3 * dy2 - dy3 * dx2) / denominator;
    double t = (dx3 * dy1 - dy3 * dx1) / denominator;

    if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
      double ix = p1.dx + s * dx1;
      double iy = p1.dy + s * dy1;
      return Offset(ix, iy);
    }

    return null;
  }


  bool checkForCollision(Offset ballPoint, Offset collisionPoint) {
    late bool res = false;
    
    final double cpx = collisionPoint.dx;
    final double cpy = collisionPoint.dy;
    late double top = ballPoint.dy-5.0;
    late double bottom = ballPoint.dy+5.0;
    late double left = ballPoint.dx-5.0;
    late double right = ballPoint.dx+5.0;
    if (cpx >= left && cpx <= right && cpy >= top && cpy <= bottom) {
      res = true;
    }
    return res;
  }

  double calculateReflectedAngle(GamePlayState gamePlayState) {
    late double angleAB = gamePlayState.lineAngle;
    late double angleQU = gamePlayState.collisionPointData["object"]["angle"]??0.0;
    // late double angleQU = gamePlayState.collisionPointData["obstacle"]["angle"]??0.0;
    // normalize
    angleAB = angleAB % 360;
    angleQU = angleQU % 360;

    double angleBC = 2 * angleQU - angleAB;

    // normalize ange BC to [0,360]
    if (angleBC < 0) {
      angleBC += 360;
    } else if (angleBC >= 360) {
      angleBC -= 360;
    }
    
    return angleBC;
  }


  List<Widget> displayTargetObstacles(GamePlayState gamePlayState, double widgetWidth) {
    List<Widget> res = [];
    List<Color> colors = gamePlayState.colors;

    double targetWidth = widgetWidth/gamePlayState.obstacleData.length;
    late double widgetSize = targetWidth > 40 ? 40 : targetWidth;
    


    for (int i=0; i<gamePlayState.targetObstacleHitOrder.length; i++) {
      final int targetColorKey = gamePlayState.targetObstacleHitOrder[i];
      late Color targetColor = Color.lerp(colors[targetColorKey],Colors.white,0.4)  ?? colors[targetColorKey];
      Color actualColor = Colors.transparent;

      late int? actualIndex = null;
      late Map<String,dynamic> actualMap = {};
      

      if (gamePlayState.obstacleHitOrder.isNotEmpty) {
        try {
          Map<String,dynamic> obstacleWithMatchingOrder = gamePlayState.obstacleHitOrder[i];
          actualMap = obstacleWithMatchingOrder;
          actualColor = colors[actualMap["colorKey"]];
        } catch (error) {
          actualIndex = -1;
        }
      }

      Widget target = SizedBox(
        width: widgetSize,
        height: widgetSize,
        // color: Colors.orange,          
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: widgetSize*0.8,
            height: widgetSize*0.8,
            decoration: BoxDecoration(
              color:  actualColor, //colors[actualMap?["colorKey"]] ??,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  actualColor,
                  Color.lerp(actualColor, Colors.white, 0.5) ?? actualColor,
                ]
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              border: Border.all(
                width: 3.0,
                color: targetColor,
              )
            ),
          ),
        ),
      );
      res.add(target);
    }
    return res;
  }


  Map<String,dynamic> getCollisionPointData(GamePlayState gamePlayState) {
    List<Map<String,dynamic>> borderData = Helpers().getBorderData(gamePlayState);

    late Offset? origin = gamePlayState.currentBallPoint;
    late Offset ballEndPoint = Helpers().getBallEndPoint(gamePlayState, origin, 10000);
    List<Offset> points = [];
    late double shortestDistance = 100000;
    late Map<String,dynamic> closestPointData = {};
    for (Map<String,dynamic> border in borderData) {

      Offset p3 = border["point1"];
      Offset p4 = border["point2"];
      final Offset? point = Helpers().findIntersection(origin!, ballEndPoint, p3, p4);

      if (point!=null) {
        final Offset collisionPoint = Offset(point.dx.round()*1.0, point.dy.round()*1.0);
        final double distance = calculateDistanceBetweenTwoPoints(origin,collisionPoint);
        if (distance < shortestDistance && collisionPoint != origin) {
          shortestDistance = distance;
          closestPointData["point"] = collisionPoint;
          closestPointData["object"] = border;
          // closestPointData["obstacle"] = border;
        }
        points.add(collisionPoint);
      }
    }
    return closestPointData;
  }

  List<Offset> getShotPath(GamePlayState gamePlayState) {
    List<Offset> res = [];
    late Map<String,dynamic> closestPointData = getCollisionPointData(gamePlayState);
    late Offset? point = closestPointData["point"];
    if (point != null && gamePlayState.startPoint != null) {

      late double collisionDistnace = calculateDistanceBetweenTwoPoints(point, gamePlayState.startPoint!);
      late double distance = calculateDistanceBetweenTwoPoints(gamePlayState.updatePoint!, gamePlayState.startPoint!);

      late double inc = 10.0;
      final double shortestDistance = min(collisionDistnace,(distance*2));
      late int stops = (shortestDistance/inc).floor();
      for (int i=0; i<stops+1; i++) {
        Offset stop = getBallEndPoint(gamePlayState, gamePlayState.startPoint, (inc*i));
        res.add(stop);
      }
    }
    return res;
  }


  Map<String, dynamic> getBlockAnimationData(GamePlayState gamePlayState, int key) {
    // late Map<String, dynamic> collisionData = gamePlayState.obstacleHitOrder.firstWhere(
    late Map<String, dynamic> collisionData = gamePlayState.obstacleHitOrder.firstWhere(
      (e) => e["key"] == key,
      orElse: () => {}, // Returns null if no matching map is found
    );
    return collisionData;
  }

  bool getIsBlockAnimating(GamePlayState gamePlayState, int key) {
    late bool res = false;
    Map<String, dynamic> collisionData = getBlockAnimationData(gamePlayState, key);
    if (collisionData.isNotEmpty) {
      if (collisionData["animations"]["animationProgress"] > 0.0 && collisionData["animations"]["animationProgress"] < 1.0) {
        res = true;
      }
    }
    return res;
  }  

  Map<String, dynamic> getBoundaryAnimationData(GamePlayState gamePlayState, int key) {
    // late Map<String, dynamic> collisionData = gamePlayState.obstacleHitOrder.firstWhere(
    late Map<String, dynamic> collisionData = gamePlayState.boundaryHitData.firstWhere(
      (e) => e["hitOrder"] == key,
      orElse: () => {}, // Returns null if no matching map is found
    );
    return collisionData;
  }

  bool getIsBoundaryAnimating(GamePlayState gamePlayState, int key) {
    late bool res = false;
    Map<String, dynamic> collisionData = getBoundaryAnimationData(gamePlayState, key);
    if (collisionData.isNotEmpty) {
      if (collisionData["animations"]["animationProgress"] > 0.0 && collisionData["animations"]["animationProgress"] < 1.0) {
        res = true;
      }
    }
    return res;
  }  


  // Map<String, dynamic> getBlockAnimationData2(GamePlayState gamePlayState, int key) {
  //   // late Map<String, dynamic> collisionData = gamePlayState.obstacleHitOrder.firstWhere(
  //   late Map<String, dynamic> collisionData = gamePlayState.obstacleAnimationData.firstWhere(
  //     (e) => e["hitOrder"] == key,
  //     orElse: () => {}, // Returns null if no matching map is found
  //   );
  //   return collisionData;
  // }  



  // bool getIsBlockAnimating2(GamePlayState gamePlayState, int key) {
  //   late bool res = false;
  //   Map<String, dynamic> collisionData = getBlockAnimationData2(gamePlayState, key);
  //   if (collisionData.isNotEmpty) {
  //     if (collisionData["animations"]["animationProgress"] > 0.0 && collisionData["animations"]["animationProgress"] < 1.0) {
  //       // print("opacity => ${collisionData["animations"]["blockOpacity"]}" );
  //       res = true;
  //     }
  //   }
  //   return res;
  // }  

  Offset getParticlePoint(double angle, Offset? point, double distance) {
    late double angleThetaRadians = angle * pi / 180;
    double a = distance * sin(angleThetaRadians);
    double b = distance * cos(angleThetaRadians);

    late double targetPointX = point!.dx + b;
    late double targetPointY = point!.dy + a;
    return Offset(targetPointX, targetPointY);
  }  

  List<Map<String,dynamic>> getParticleData(Offset origin) {
    
    Random random = Random();
    double randomDouble(double min, double max) {
      return (random.nextDouble() * (max - min) + min);
    }  
  
    List<Map<String,dynamic>> res = [];
    for (int i=0; i < 100; i++) { 
      final double randomAngle = random.nextInt(359)*1.0;
      final double delay = random.nextInt(50) * 0.5;
      final double distance = random.nextInt(70) + 10;
      final double color = (random.nextInt(30)+20) / 100;
      final double size = (random.nextInt(20)+10)/10;
      final int points = random.nextInt(3)+3;
      final double angleBase = 360 / points;
      final List<Map<String,dynamic>> shapeData = [];
      for (int i=0;i<points;i++) {
        
        late double variation = 0.0;
        if (i == 0) {
          variation = random.nextDouble() * 20;
        } else if (i==points) {
          variation = random.nextDouble() * 20;
        } else {
          variation = randomDouble(-20,20);
        }
        final double angle = (i*angleBase) + num.parse(variation.toStringAsFixed(2));
        final double distance = (random.nextInt(60)+20)/10;
        shapeData.add({"angle":angle, "distance": distance});
      }

      res.add({
        "angle":randomAngle, 
        "delay":delay, 
        "distance": distance, 
        "color":color,
        "size": size,
        "shape": shapeData
      });
    }
    return res;
  }


  List<Map<String,dynamic>> getBoundaryParticleData(Offset origin) {
    
    Random random = Random();
    double randomDouble(double min, double max) {
      return (random.nextDouble() * (max - min) + min);
    }  
  
    List<Map<String,dynamic>> res = [];
    for (int i=0; i < 100; i++) { 
      final double randomAngle = random.nextInt(359)*1.0;
      final double delay = random.nextInt(50) * 0.5;
      final double distance = random.nextInt(70) + 10;
      final double color = (random.nextInt(30)+20) / 100;
      final double size = (random.nextInt(20)+10)/10;
      final int points = random.nextInt(5);
      final double angleBase = 360 / points;
      final List<Map<String,dynamic>> shapeData = [];
      for (int i=0;i<points;i++) {
        late double variation = 0.0;
        if (i == 0) {
          variation = random.nextDouble() * 20;
        } else if (i==points) {
          variation = random.nextDouble() * 20;
        } else {
          variation = randomDouble(-20,20);
        }
        final double angle = (i*angleBase) + num.parse(variation.toStringAsFixed(2));
        final double distance = (random.nextInt(30)+20)/10;
        shapeData.add({"angle":angle, "distance": distance});
      }

      res.add({
        "angle":randomAngle, 
        "delay":delay, 
        "distance": distance, 
        "color":color,
        "size": size,
        "points": points,
        "shape": shapeData
      });
    }
    return res;
  }

  // Path createBezierPath(List<Offset> points, double offsetDistance) {
  //   final Path path = Path();
  //   if (points.length < 2) return path;

  //   path.moveTo(points[0].dx, points[0].dy);

  //   for (int i = 1; i < points.length - 1; i++) {
  //     final Offset previous = _getOffset(points[i - 1], points[i], -offsetDistance);
  //     final Offset next = _getOffset(points[i], points[i + 1], offsetDistance);

  //     // Add a smooth curve
  //     path.quadraticBezierTo(
  //       previous.dx, previous.dy, // Control point
  //       points[i].dx, points[i].dy, // Endpoint
  //     );

  //     path.quadraticBezierTo(
  //       next.dx, next.dy, // Control point
  //       points[i + 1].dx, points[i + 1].dy, // Endpoint
  //     );
  //   }

  //   return path;
  // }

  // Offset _getOffset(Offset start, Offset end, double distance) {
  //   // Calculate the direction vector
  //   final Offset direction = _normalize(end - start);
  //   return start + direction * distance;
  // }

  // Offset _normalize(Offset offset) {
  //   final double length = sqrt(offset.dx * offset.dx + offset.dy * offset.dy);
  //   return length == 0 ? Offset.zero : Offset(offset.dx / length, offset.dy / length);
  // }


  Map<String,dynamic> getObstacleAreaData(Offset origin,) {
    List<double> xs = [origin.dx-50.0,origin.dx+50.0];
    List<double> ys = [origin.dy-50.0,origin.dy+50.0];
    // for (int i=0; i<obstacleObject["points"].length; i++) {
    //   xs.add(obstacleObject["points"][i].dx);
    //   ys.add(obstacleObject["points"][i].dy);
    // }

    // xs.sort();
    // ys.sort();

    return {"x": xs, "y": ys};
  }


  // void getShapeOpacityStartingAnimation(GamePlayState gamePlayState) {

  //   const int fps = 60;
  //   late double seconds = gamePlayState.startingAnimationDurationInSeconds;
  //   final int frames = (fps*seconds).floor(); 
  //   // final double delay = 0.15;
  //   final double duration = (90 / gamePlayState.obstacleData.length) / 100; // percent
  //   // const double duration = 0.3;

  //   for (int j=0; j<gamePlayState.obstacleData.length; j++) {

  //     late List<double> values = [];
  //     late double delay = j * 0.1;

  //     final double buffer = 1.0 - (duration+delay);

  //     for (int i=0; i<(frames*delay).floor(); i++) {
  //       values.add(0.0);
  //     }

  //     for (int i=0; i<(frames*duration).floor(); i++) {
  //       double val = i/(frames*duration);
  //       values.add(val);
  //     }

  //     for (int i=0; i<(frames*buffer).floor(); i++) {
  //       values.add(1.0);
  //     }

  //     // gamePlayState.obstacleData[j]["startingAnimationOpacity"] = values;
  //     // return values;  

  //   }

  // }

  void setBallTrailEffect(GamePlayState gamePlayState, Offset newBallPosition) {
    if (gamePlayState.ballTrailEffect.isEmpty) {
      gamePlayState.setBallTrailEffect([newBallPosition]);
    } else {
      List<Offset> trailPoints = [...gamePlayState.ballTrailEffect,newBallPosition];
      if (trailPoints.length > 10) {
        trailPoints = gamePlayState.ballTrailEffect.sublist(trailPoints.length - 10);
      }
      gamePlayState.setBallTrailEffect(trailPoints);
    }
  }

  List<Offset> getPlayAreaCorners(SettingsState settingsState) {
    List<Offset> res = [
      Offset.zero,
      Offset(settingsState.playAreaSize.width.floor()*1.0,0.0),
      Offset(settingsState.playAreaSize.width.floor()*1.0,settingsState.playAreaSize.height.floor()*1.0),
      Offset(0.0,settingsState.playAreaSize.height.floor()*1.0)
    ];
    return res;
  }

  Offset adjustForCornerCollision(GamePlayState gamePlayState, SettingsState settingsState, Offset upcomingCollisionPoint) {
    List<Offset> corners = getPlayAreaCorners(settingsState);
    Offset res = upcomingCollisionPoint;
    if (corners.contains(upcomingCollisionPoint)) {

      double adjustmentX = 0.0;
      double adjustmentY = 0.0;
      if (upcomingCollisionPoint.dx == 0.0 && upcomingCollisionPoint.dy == 0.0) {
        adjustmentX = 1.0;
        adjustmentY = 1.0;
      } else if (upcomingCollisionPoint.dx == settingsState.playAreaSize.width.floor()*1.0 && upcomingCollisionPoint.dy == 0.0) {
        adjustmentX = -1.0;
        adjustmentY = 1.0;
      } else if (upcomingCollisionPoint.dx == settingsState.playAreaSize.width.floor()*1.0 && upcomingCollisionPoint.dy == settingsState.playAreaSize.height.floor()*1.0) {
        adjustmentX = -1.0;
        adjustmentY = -1.0;
      } else if (upcomingCollisionPoint.dx == 0.0 && upcomingCollisionPoint.dy == settingsState.playAreaSize.height.floor()*1.0) {
        adjustmentX = 1.0;
        adjustmentY = -1.0;
      }
      res = Offset(upcomingCollisionPoint.dx + adjustmentX, upcomingCollisionPoint.dy + adjustmentY);
    }
    return res;
  }
  

  // Offset convertPercentDataIntoOffset(List<double> coord , Size size) {
  Offset convertPercentDataIntoOffset(List<dynamic> coord , Size size) {
    final double dx = coord[0];
    final double dy = coord[1];
    final double top = 0.0 + (dy/100)*size.height;
    final double left = 0.0 + (dx/100)*size.width;
    return Offset(left,top);
  }

  Path getBoundaryPath(List<Offset> boundaryPoints) {
    Path path = Path();
    Offset firstPoint = boundaryPoints[0];
    path.moveTo(firstPoint.dx, firstPoint.dy);
    for (int i=1; i<boundaryPoints.length;i++) {
      Offset point = boundaryPoints[i];
      path.moveTo(point.dx,point.dy);
    }
    path.close();
    return path;
  }


  double calculateDistanceBetweenTwoPoints(Offset point1, Offset point2) {
    final num xPow = pow((point2.dx - point1.dx),2);
    final num yPow = pow((point2.dy - point1.dy),2);
    final double distance = double.parse(sqrt( xPow + yPow ).toStringAsFixed(2));
    return distance;
  }


  List<Map<String, dynamic>> deepCopyList(List<Map<String, dynamic>> original) {
    return original.map((map) {
      return map.map((key, value) {
        if (value is List) {
          // If the value is a list, recursively copy each element.
          return MapEntry(key, List.from(value.map((e) {
            if (e is List) {
              return List.from(e); // Nested list
            } else if (e is Map) {
              return Map.from(e); // Nested map
            } else {
              return e; // Primitive type
            }
          })));
        } else if (value is Map) {
          // If the value is a map, recursively copy the map.
          return MapEntry(key, Map.from(value));
        } else {
          // If it's a primitive, just return the value.
          return MapEntry(key, value);
        }
      });
    }).toList();
  }

  List<Map<String,dynamic>> generateListOfBlocks(double averageBlockSize,double blockSizeVariation, double sideLength) {
    Random random = Random();
    List<Map<String,dynamic>> blockData = [];
    late double blockLength = 0.0;
    bool isValid = true;
    while (isValid) {
  
      final double newBlockSize = averageBlockSize + ((random.nextDouble()*(blockSizeVariation*2))-blockSizeVariation);
      final double newBlockSizeClean = double.parse(newBlockSize.toStringAsFixed(2));
      final double outsidePointVariation1 = double.parse((random.nextDouble()*blockSizeVariation).toStringAsFixed(2));
      final double outsidePointVariation2 = double.parse((random.nextDouble()*blockSizeVariation).toStringAsFixed(2));
      
      Map<String,dynamic> blockObject = {
        "key": blockData.length, 
        "insideStart": blockLength, 
        "insideEnd": blockLength+newBlockSizeClean,
        "outsideStart": blockLength-outsidePointVariation1<= 0 ? 0.0 : blockLength-outsidePointVariation1,
        "outsideEnd": blockLength+newBlockSizeClean+outsidePointVariation2>= sideLength ? sideLength : blockLength+newBlockSizeClean+outsidePointVariation2,
      };
      
      blockData.add(blockObject);
      
      blockLength = blockLength + newBlockSizeClean;
      
      if (blockLength + newBlockSizeClean >= sideLength) {
        isValid = false;
      }
    }
    
    final double lastBlockSize = double.parse((sideLength - blockLength).toStringAsFixed(2));
    
      final double variation = double.parse((random.nextDouble()*blockSizeVariation).toStringAsFixed(2));
      Map<String,dynamic> blockObject = {
        "key": blockData.length, 
        "insideStart": blockLength, 
        "insideEnd": blockLength+lastBlockSize,
        "outsideStart": blockLength-variation,
        "outsideEnd": sideLength,
      };    
    blockData.add(blockObject);
    
    
    return blockData;
  }
  
  List<Offset> generateBlockOffsets(String side, Map<String,dynamic> blockObject, double boundaryThickness, Size playAreaSize) {
    late Offset point1 = Offset.zero;
    late Offset point2 = Offset.zero;
    late Offset point3 = Offset.zero;
    late Offset point4 = Offset.zero;
    if (side == "top") {
      // outside start -> 
      point1 = Offset(blockObject["outsideStart"], 0.0);
      // outside end ->
      point2 = Offset(blockObject["outsideEnd"], 0.0);
      // inside end ->
      point3 = Offset(blockObject["insideEnd"], (0.0+boundaryThickness));
      // inside start ->
      point4 = Offset(blockObject["insideStart"], (0.0+boundaryThickness));
    } else if (side == 'right') {
      // outside start -> 
      point1 = Offset(playAreaSize.width,blockObject["outsideStart"]);
      // outside end ->
      point2 = Offset(playAreaSize.width,blockObject["outsideEnd"]);
      // inside end ->
      point3 = Offset((playAreaSize.width-boundaryThickness),blockObject["insideEnd"]);
      // inside start ->
      point4 = Offset((playAreaSize.width-boundaryThickness),blockObject["insideStart"]);        
      
    } else if (side == 'bottom') {
      // outside start -> 
      point1 = Offset(blockObject["outsideStart"],playAreaSize.height);
      // outside end ->
      point2 = Offset(blockObject["outsideEnd"], playAreaSize.height);
      // inside end ->
      point3 = Offset(blockObject["insideEnd"], (playAreaSize.height-boundaryThickness));
      // inside start ->
      point4 = Offset(blockObject["insideStart"], (playAreaSize.height-boundaryThickness));
    } else if (side == 'left') {
      // outside start -> 
      point1 = Offset(0.0,blockObject["outsideStart"]);
      // outside end ->
      point2 = Offset(0.0,blockObject["outsideEnd"]);
      // inside end ->
      point3 = Offset((0.0+boundaryThickness),blockObject["insideEnd"]);
      // inside start ->
      point4 = Offset((0.0+boundaryThickness),blockObject["insideStart"]);      
    }
    
    return [point1,point2,point3,point4];
    
  }
  
  List<Map<String,dynamic>> generateBoundaryData(Size playAreaSize) {
    
    final double averageBlockSize = playAreaSize.width*0.025;
    final double blockSizeVariation = playAreaSize.width*0.010;

    
    final List<Map<String,dynamic>> topBlocks = generateListOfBlocks(averageBlockSize,blockSizeVariation,playAreaSize.width);
    final List<Map<String,dynamic>> rightBlocks = generateListOfBlocks(averageBlockSize,blockSizeVariation,playAreaSize.height);
    final List<Map<String,dynamic>> bottomBlocks = generateListOfBlocks(averageBlockSize,blockSizeVariation,playAreaSize.width);
    final List<Map<String,dynamic>> leftBlocks = generateListOfBlocks(averageBlockSize,blockSizeVariation,playAreaSize.height);
    
    // List<List<Offset>> shapes = []; 
    List<Map<String,dynamic>> boundaryData = [];
    for (int i=0; i<topBlocks.length; i++) {
      Map<String,dynamic> blockObject = topBlocks[i];
      List<Offset> offsets = generateBlockOffsets("top",blockObject,averageBlockSize, playAreaSize);
      Map<String,dynamic> boundaryObject = {"key": boundaryData.length,"active": true, "side": "top", "points": offsets};
      boundaryData.add(boundaryObject);
    }

    for (int i=0; i<rightBlocks.length; i++) {
      Map<String,dynamic> blockObject = rightBlocks[i];
      List<Offset> offsets = generateBlockOffsets("right",blockObject,averageBlockSize, playAreaSize);
      Map<String,dynamic> boundaryObject = {"key": boundaryData.length, "active": true, "side": "right", "points": offsets};
      boundaryData.add(boundaryObject);
    }

    for (int i=0; i<bottomBlocks.length; i++) {
      Map<String,dynamic> blockObject = bottomBlocks[i];
      List<Offset> offsets = generateBlockOffsets("bottom",blockObject,averageBlockSize, playAreaSize);
      Map<String,dynamic> boundaryObject = {"key": boundaryData.length, "active": true, "side": "bottom", "points": offsets};
      boundaryData.add(boundaryObject);
    }

    for (int i=0; i<leftBlocks.length; i++) {
      Map<String,dynamic> blockObject = leftBlocks[i];
      List<Offset> offsets = generateBlockOffsets("left",blockObject,averageBlockSize, playAreaSize);
      Map<String,dynamic> boundaryObject = {"key": boundaryData.length, "active": true, "side": "left", "points": offsets};
      boundaryData.add(boundaryObject);
    }            

    return boundaryData;
    
  }


  void resetBoundaryData(GamePlayState gamePlayState) {
    List<int> hitBoundaries = gamePlayState.hitBoundaries;
    for (int i=0; i<gamePlayState.boundaryData.length; i++) {
      if (hitBoundaries.contains(gamePlayState.boundaryData[i]["key"])) {
        gamePlayState.boundaryData[i].update("active", (v) => false);
      } else {
        gamePlayState.boundaryData[i].update("active", (v) => true);
      }
    }
    gamePlayState.setBoundaryData(gamePlayState.boundaryData);
  }

  void updateHitBoundaries(GamePlayState gamePlayState) {
    List<int> hitBoundaries = [];
    for (int i=0; i<gamePlayState.boundaryData.length; i++) {
      if (!gamePlayState.boundaryData[i]["active"]) {
        hitBoundaries.add(gamePlayState.boundaryData[i]["key"]);
      }
    }
    gamePlayState.setHitBoundaries(hitBoundaries);
  }

  double getPercentCampaignCompleteBarWidth(GamePlayState gamePlayState,SettingsState settingsState) {
    int currentLevel = gamePlayState.levelKey!;
    int levelCount = gamePlayState.currentCampaignState.levels.length;
    double complete = (currentLevel/levelCount)*settingsState.playAreaSize.width;
    complete;
    return complete;
  }

  Map<int,int> getMapOfCollectedGems(GamePlayState gamePlayState) {
    List<int> allGems = [];
    List<int> uniqueGems = [];
    int currentLevel = gamePlayState.levelKey!;
    for (int i=0; i<gamePlayState.currentCampaignState.levels.length; i++) {
      var order = gamePlayState.currentCampaignState.levels[i]["order"];
      for (int number in order) {
        if (!uniqueGems.contains(number)) {
          uniqueGems.add(number);
        }

        if (i < currentLevel) {
          allGems.add(number);
        }
      }
    }

    Map<int,int> counts = {};
    for (int number in uniqueGems) {
      counts[number] = (counts[number] ?? 0) + 0;
    }

    for (int number in allGems) {
      counts[number] = (counts[number] ?? 0) + 1;
    }

    return counts;
  }


}
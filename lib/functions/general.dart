import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:lokuro/functions/game_logic.dart';
import 'package:lokuro/functions/helpers.dart';
import 'package:lokuro/models/campaign_model.dart';
import 'package:lokuro/models/level_model.dart';
import 'package:lokuro/providers/animation_state.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:lokuro/screens/game_over_screen.dart/game_over_screen.dart';
import 'package:lokuro/screens/game_screen/game_screen.dart';
import 'package:lokuro/screens/home_screen/home_screen.dart';
import 'package:lokuro/settings/settings_controller.dart';

class General {


  void navigateToMainMenu(BuildContext context, GamePlayState gamePlayState) {
    try{
      gamePlayState.restartGame();
      gamePlayState.setHitBoundaries([]);
    } catch (error) {
      print("error in navigateToMainMenu() : => ${error}");
    }
    gamePlayState.setObstacleData([]);
    gamePlayState.setBoundaryData([]);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen())
    );       
  }

  void navigateToCampaign(
    BuildContext context,
    int campaignId, 
    SettingsState settingsState, 
    GamePlayState gamePlayState, 
    AnimationState animationState,
    SettingsController settings,  
  ) {
    initializeCampaign(context, campaignId, settingsState,gamePlayState,settings);
    navigateToLevel(context, campaignId, 0, settingsState, gamePlayState, animationState, settings);
  }


  void navigateToLevel(
    BuildContext context,
    int campaignId, 
    int levelId,
    SettingsState settingsState, 
    GamePlayState gamePlayState, 
    AnimationState animationState, 
    // Map<String,dynamic> levelData
    SettingsController settings,
  ) {


    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const GameScreen())
    );



    gamePlayState.setLevelTransition([null, levelId]);
    initializeGame(context,campaignId,levelId,settingsState,gamePlayState,settings);
    animationState.setShouldRunGameStartedAnimation(true);
    
  }




void navigateToNextLevel(
  BuildContext context, 
  int campaignId, 
  int levelId,
  SettingsState settingsState, 
  GamePlayState gamePlayState, 
  AnimationState animationState,
  SettingsController settings,
) {
  Random rand = Random();
  final int newCoins = rand.nextInt(40)+80;
  final int currentCoinsSum = gamePlayState.coinsCollected.last;
  final int totalCoins = currentCoinsSum+newCoins;
  gamePlayState.setCoinsCollected([...gamePlayState.coinsCollected,totalCoins]);
        // check if the level was the last in the list

  initializeGame(context,campaignId,levelId,settingsState,gamePlayState,settings);
  animationState.setShouldRunGameStartedAnimation(true);
  
}


void initializeCampaign(
  BuildContext context,
  int campaignId, 
  SettingsState settingsState, 
  GamePlayState gamePlayState, 
  SettingsController settings  
) {

  gamePlayState.setCampaignKey(campaignId);
  gamePlayState.setCurrentCampaignState(settings, campaignId);
  gamePlayState.setCoinsCollected([0]);
  List<Map<String, dynamic>> rawBoundaryData = Helpers().generateBoundaryData(settingsState.playAreaSize);
  gamePlayState.setBoundaryData(rawBoundaryData); 

}

void initializeGame(
  BuildContext context,
  int campaignId, 
  int levelId,
  SettingsState settingsState, 
  GamePlayState gamePlayState, 
  SettingsController settings
) async {
  // Map<String, dynamic> levelData = Map<String, dynamic>.from(settingsState.levelData[index-1]);
  // Map<String, dynamic> levelData = gamePlayState.levelData;
  // Map<String, dynamic> levelData = Map<String, dynamic>.from(settingsState.levelData[index]);
  // Map<String,dynamic> levelData = Map<String, dynamic>.from(settings.levelData.value[index]);
  // levelData = settingsState.initialLevelState.copy();
  // Map<String,dynamic> levelData = {
  //   "levelId"
  // };

  // await settingsState.loadInitialStateForCampaign(settings, index);
  // await settingsState.loadInitialStateForLevel(settings,index);
  

  // gamePlayState.startLevel(settingsState);

  // Level levelData = gamePlayState.currentState;

  // gamePlayState.setCampaignKey(campaignId);
  // gamePlayState.setCurrentCampaignState(settings, campaignId);

  // List<int> hitBoundaries = [];
  // gamePlayState.boundaryData.forEach((val) {
  //   if (!val["active"]) {
  //     hitBoundaries.add(val["key"]);
  //   }
  // });

  // print(hitBoundaries);
  Helpers().resetBoundaryData(gamePlayState);

  Campaign campaignData = gamePlayState.currentCampaignState;

  // Map<String,dynamic> levelData = campaignData.levels.firstWhere((value) => value["levelId"]==levelId);
  Level levelData = Level.fromJson(campaignData.levels.firstWhere((v) => v["levelId"] == levelId));

  // int levelId = levelData.levelId;
  gamePlayState.setLevelKey(levelId);

  // Level levelData = settings.campaignData.value.firstWhere(test)
  
  
  List<int> order = List<int>.from(levelData.order);
  gamePlayState.setTargetObstacleHitOrder(order);
  
  Size size = settingsState.playAreaSize;
  List<Map<String, dynamic>> rawObstacleData = List<Map<String, dynamic>>.from(levelData.obstacles.map((e) => Map<String, dynamic>.from(e)));
  // List<Map<String, dynamic>> rawObstacleDataCopy = Helpers().deepCopy(rawObstacleData);
  List<Map<String, dynamic>> obstacleDataWithBoundary = createObstacleListWithGameBorders(settingsState, rawObstacleData);

  List<Map<String, dynamic>> obstacleData = addPathToObstacles(obstacleDataWithBoundary, size);
  gamePlayState.setObstacleData(obstacleData);

  // List<Map<String, dynamic>> rawBoundaryData = List<Map<String, dynamic>>.from(levelData.boundaries.map((e) => Map<String, dynamic>.from(e)));
  // List<Map<String, dynamic>> rawBoundaryData = Helpers().generateBoundaryData(settingsState.playAreaSize);
  // List<Map<String, dynamic>> rawBoundaryDataCopy = Helpers().deepCopy(rawBoundaryData);
  // List<Map<String, dynamic>> boundaryData = addPathToBoundaries(rawBoundaryData, size);
  // gamePlayState.setBoundaryData(boundaryData); 
  // List<Map<String, dynamic>> boundaryDataCopy = Helpers().deepCopy(boundaryData);
  // gamePlayState.setBoundaryDataCopy(boundaryDataCopy);
  gamePlayState.setIsLevelPassed(false);
  gamePlayState.setIsGameOver(false);  
}




  Map<String,dynamic> getAdjacents(Offset previousPoint,Offset currentPoint,Offset nextPoint, int index, double gap) {

    double x1 = currentPoint.dx + gap * (previousPoint.dx - currentPoint.dx);
    double y1 = currentPoint.dy + gap * (previousPoint.dy - currentPoint.dy);

    double x2 = currentPoint.dx + gap * (nextPoint.dx - currentPoint.dx);
    double y2 = currentPoint.dy + gap * (nextPoint.dy - currentPoint.dy);

    final Offset previous = Offset(x1,y1);
    final Offset next = Offset(x2, y2);

    return {"key": index, "previous": previous, "current": currentPoint, "next": next};
  }


  // List<Map<String,dynamic>> getOffsets(Offset origin, List<Map<String,dynamic>> points, Size size, double distanceFactor) {
  List<Map<String,dynamic>> getOffsets(Offset origin, List<dynamic> points, Size size, double distanceFactor) {
    List<Map<String,dynamic>> res = [];

    for (int index=0; index<points.length; index++) {
      late int previousIndex = index == 0 ? points.length-1 : (index-1);
      late int nextIndex = index == points.length-1 ? 0 : (index+1);
      final Map<String,dynamic> point0 = points[previousIndex];
      final Map<String,dynamic> point1 = points[index];
      final Map<String,dynamic> point2 = points[nextIndex];

      final Offset previousPoint = getCoordinatesFromDistanceAndAngle(origin, point0, size,distanceFactor);
      final Offset currentPoint = getCoordinatesFromDistanceAndAngle(origin, point1, size,distanceFactor);
      final Offset nextPoint = getCoordinatesFromDistanceAndAngle(origin, point2, size,distanceFactor);      

      final Map<String,dynamic> adjacents = getAdjacents(previousPoint,currentPoint,nextPoint,index,0.0);
      res.add(adjacents);
    }
    return res;
  }

  // List<Map<String,dynamic>> getAnimatingPolygonOffsets(Offset origin, List<Map<String,dynamic>> points, Size size, double progress) {
  List<Map<String,dynamic>> getAnimatingPolygonOffsets(Offset origin, List<dynamic> points, Size size, double progress, double cornerGap) {
    List<Map<String,dynamic>> res = [];

    for (int index=0; index<points.length; index++) {
      late int previousIndex = index == 0 ? points.length-1 : (index-1);
      late int nextIndex = index == points.length-1 ? 0 : (index+1);
      final Map<String,dynamic> point0 = points[previousIndex];
      final Map<String,dynamic> point1 = points[index];
      final Map<String,dynamic> point2 = points[nextIndex];

      // final Map<String,dynamic> point0Data = {
      //   "key": point0["key"],
      //   "distance": point0["distance"] * (1.0 + (0.5 *progress)),
      //   "angle": point0["angle"]
      // };

      // final Map<String,dynamic> point1Data = {
      //   "key":point1["key"],
      //   "distance": point1["distance"] * (1.0 + (0.5 *progress)),
      //   "angle": point1["angle"]
      // };

      // final Map<String,dynamic> point2Data = {
      //   "key":point2["key"],
      //   "distance": point2["distance"] * (1.0 + (0.5 *progress)),
      //   "angle": point2["angle"]
      // };            

      final Offset previousPoint = getCoordinatesFromDistanceAndAngle(origin, point0, size, (1.0 + (0.5 *progress)) );
      final Offset currentPoint = getCoordinatesFromDistanceAndAngle(origin, point1, size, (1.0 + (0.5 *progress)));
      final Offset nextPoint = getCoordinatesFromDistanceAndAngle(origin, point2, size, (1.0 + (0.5 *progress)));      

      final Map<String,dynamic> adjacents = getAdjacents(previousPoint,currentPoint,nextPoint,index,cornerGap);
      res.add(adjacents);
    }
    return res;
  }


  Offset getOrigin(Map<String,dynamic> obstacleData, Size size) {
    late double dx = obstacleData["origin"][0];
    late double dy = obstacleData["origin"][1];
    final double top = 0.0 + (dy/100)*size.height;
    final double left = 0.0 + (dx/100)*size.width;
    return Offset(left,top);
  }

  Offset getCoordinatesFromDistanceAndAngle(Offset origin, Map<String,dynamic> pointData, Size size, double distanceFactor) {
    double angle1Radians = pointData["angle"] * (pi/180);
    double scalor = size.width;
    double distance = (pointData["distance"]/100) * scalor * distanceFactor;

    double sideA = distance * sin(angle1Radians);
    double sideB = distance * cos(angle1Radians);

    final double dx = (origin.dx + sideA);
    final double dy = (origin.dy + sideB);

    return Offset(dx,dy);
  }

  Path getPreviousObstacleShape(Map<String,dynamic> obstacle, Size size, double yIncrement) {

    Path obstaclePath = Path();
    final Offset origin = getOrigin(obstacle, size);
    final Offset origin2 = Offset(origin.dx, origin.dy-yIncrement);    
    // if (obstacle["isCircle"]) {
    //   List<Offset> circlePoints = getCircleOffsetData(obstacle,origin2, size);
    //   Offset firstPoint = circlePoints[0];
    //   obstaclePath.moveTo(firstPoint.dx, firstPoint.dy);
    //   for (int i=1; i<circlePoints.length; i++) {
    //     Offset point = circlePoints[i];
    //     obstaclePath.lineTo(point.dx, point.dy);
    //   }
    // } else {
      List<Map<String,dynamic>> allPoints = getOffsets(origin2, obstacle["data"],size, 1.0,);
      Map<String,dynamic> firstPoints = allPoints[0];
      obstaclePath.moveTo(firstPoints["previous"].dx,firstPoints["previous"].dy);
      obstaclePath.quadraticBezierTo(
        firstPoints["current"].dx,
        firstPoints["current"].dy,
        firstPoints["next"].dx,
        firstPoints["next"].dy
      );
      for (int i=1; i<allPoints.length; i++) {
        late Map<String,dynamic> cornerData = allPoints[i];
        obstaclePath.lineTo(cornerData["previous"].dx, cornerData["previous"].dy);
        obstaclePath.quadraticBezierTo(
          cornerData["current"].dx,
          cornerData["current"].dy,
          cornerData["next"].dx,
          cornerData["next"].dy
        );
      }
      obstaclePath.close();
    // }

    return obstaclePath;
  }  



  Path getShapeData(Offset origin, Map<String,dynamic> obstacle, Size size) {

    // final Offset origin = getOrigin(obstacle, size);
    Path obstaclePath = Path();
    // if (obstacle["isCircle"]) {
    //   List<Offset> circlePoints = getCircleOffsetData(obstacle,origin, size);
    //   Offset firstPoint = circlePoints[0];
    //   obstaclePath.moveTo(firstPoint.dx, firstPoint.dy);
    //   for (int i=1; i<circlePoints.length; i++) {
    //     Offset point = circlePoints[i];
    //     obstaclePath.lineTo(point.dx, point.dy);
    //   }
    // } else {
      
      List<Map<String,dynamic>> allPoints = getOffsets(origin, obstacle["data"],size, 1.0,);
      Map<String,dynamic> firstPoints = allPoints[0];
      obstaclePath.moveTo(firstPoints["previous"].dx,firstPoints["previous"].dy);
      obstaclePath.quadraticBezierTo(
        firstPoints["current"].dx,
        firstPoints["current"].dy,
        firstPoints["next"].dx,
        firstPoints["next"].dy
      );
      for (int i=1; i<allPoints.length; i++) {
        late Map<String,dynamic> cornerData = allPoints[i];
        obstaclePath.lineTo(cornerData["previous"].dx, cornerData["previous"].dy);
        obstaclePath.quadraticBezierTo(
          cornerData["current"].dx,
          cornerData["current"].dy,
          cornerData["next"].dx,
          cornerData["next"].dy
        );
      }
      obstaclePath.close();
    // }

    return obstaclePath;
  }

  Path getShapeDataWhileAnimating(Map<String,dynamic> obstacle, Size size, double progress) {
    Path obstaclePath = Path();
    // if (obstacle["isCircle"]) {
    //   List<Offset> circlePoints = getCircleOffsetDataWhileAnimating(obstacle, size, progress);
    //   Offset firstPoint = circlePoints[0];
    //   obstaclePath.moveTo(firstPoint.dx, firstPoint.dy);
    //   for (int i=0; i<circlePoints.length; i++) {
    //     Offset point = circlePoints[i];
    //     obstaclePath.lineTo(point.dx, point.dy);
    //   }
    // } else {
      final Offset origin = getOrigin(obstacle, size);
      List<Map<String,dynamic>> allPoints = getAnimatingPolygonOffsets(origin, obstacle["data"],size,progress, 0.05);
      Map<String,dynamic> firstPoints = allPoints[0];
      obstaclePath.moveTo(firstPoints["previous"].dx,firstPoints["previous"].dy);
      obstaclePath.quadraticBezierTo(
        firstPoints["current"].dx,
        firstPoints["current"].dy,
        firstPoints["next"].dx,
        firstPoints["next"].dy
      );
      for (int i=1; i<allPoints.length; i++) {
        late Map<String,dynamic> cornerData = allPoints[i];
        obstaclePath.lineTo(cornerData["previous"].dx, cornerData["previous"].dy);
        obstaclePath.quadraticBezierTo(
          cornerData["current"].dx,
          cornerData["current"].dy,
          cornerData["next"].dx,
          cornerData["next"].dy
        );
      }
      obstaclePath.close();
    // }
    return obstaclePath;
  }


  // List<Offset> getCircleOffsetData(Map<String,dynamic> obstacleData, Offset origin, Size size) {
  //   List<Offset> points = [];
  //   // final Offset origin = getOrigin(obstacleData, size);
  //   for (int i=0; i<90;i++) {
  //     Map<String,dynamic> obstaclePointData = {
  //       "key":i,
  //       "distance": obstacleData["data"][0]["distance"],
  //       "angle": i*4.0
  //     };
  //     late Offset point = getCoordinatesFromDistanceAndAngle(origin, obstaclePointData, size, 1.0);
  //     points.add(point);
  //   }
  //   return points;
  // }

  List<Map<String,dynamic>> updateCirclePointData(Map<String,dynamic> obstacleData, Offset origin, Size size, int points) {
    List<Map<String,dynamic>> data = [];
    // final Offset origin = getOrigin(obstacleData, size);
    for (int i=0; i<points;i++) {
      Map<String,dynamic> obstaclePointData = {
        "key":i,
        "distance": obstacleData["data"][0]["distance"],
        "angle": (i*(360/points))-(360/points)
      };
      data.add(obstaclePointData);
    }
    return data;
  }  

  // List<Offset> getCircleOffsetDataWhileAnimating(Map<String,dynamic> obstacleData, Size size, double progress, ) {
  //   List<Offset> points = [];
  //   final Offset origin = getOrigin(obstacleData, size);
  //   for (int i=0; i<90;i++) {
  //     Map<String,dynamic> obstaclePointData = {
  //       "key":i,
  //       "distance": obstacleData["data"][0]["distance"] * (1.0 + (0.5 *progress)),
  //       "angle": i*4.0
  //     };
  //     late Offset point = getCoordinatesFromDistanceAndAngle(origin, obstaclePointData, size, 1.0);
  //     points.add(point);
  //   }
  //   return points;
  // }  

  List<Map<String, dynamic>> createObstacleListWithGameBorders(SettingsState settingsState, List<Map<String, dynamic>> rawObstacleData) {
    List<Map<String, dynamic>> obstaclesCopy = List<Map<String, dynamic>>.from(rawObstacleData.map((e) => Map<String, dynamic>.from(e)));
    
    Map<String, Object> outsideBorders = {
      "key": 0,
      "active": true,
      "points": [
        // Offset.zero,
        Offset(settingsState.playAreaSize.width.floor() * -1.0, settingsState.playAreaSize.height.floor() * -1.0),
        Offset(settingsState.playAreaSize.width.floor() * 2.0,  settingsState.playAreaSize.height.floor() * -1.0),
        Offset(settingsState.playAreaSize.width.floor() * 2.0,  settingsState.playAreaSize.height.floor() * 2.0),
        Offset(settingsState.playAreaSize.width.floor() * -1.0, settingsState.playAreaSize.height.floor() * 2.0)
      ],
      "colorKey": 0,
    };
    
    obstaclesCopy.insert(0, outsideBorders);
    return obstaclesCopy;
  }


  List<Map<String,dynamic>> addPathToObstacles(List<Map<String,dynamic>> obstacles, Size size,) {
    // final Random random = Random();
    for (int i=0; i<obstacles.length; i++) {
      if (i != 0) {
        late Map<String,dynamic> obstacle = obstacles[i];
        final Offset origin = getOrigin(obstacle, size);
        // final double innerJewelSize = (random.nextInt(30)+30)/100;
        // final double jewelCornerSize = (random.nextInt(10)+5)/100;

        obstacles[i]["data"] = getPointData(obstacle);
        if (obstacle["isCircle"]) {
          obstacle.update("data", (v) => updateCirclePointData(obstacle,origin,size,24));
        }

        
        List<Offset> points = [];
        for (int j=0; j<obstacles[i]["data"].length; j++) {
          final Map<String,dynamic> point = obstacles[i]["data"][j];
          final Offset pointOffset = getCoordinatesFromDistanceAndAngle(origin, point, size, 1.0);
          points.add(pointOffset);
        }
        // obstacles[i]["innerJewelSize"] = innerJewelSize;
        // obstacles[i]["jewelCornerSize"] = jewelCornerSize;
        obstacles[i]["points"] = points;
        Path shapeData = getShapeData(origin, obstacles[i],size);
        obstacles[i]["path"] = shapeData;
    
      }
    }
    return obstacles;
  }

  List<Map<String,dynamic>> getPointData(Map<String,dynamic> obstacle) {
    // Random random = Random();
    final int faces = obstacle["faces"];
    final double factor = obstacle["factor"];
    final double angleMultiplier = obstacle["angleMultiplier"];
    final int angleStep = obstacle["angleStep"];
    final double originalDistance = obstacle["distance"];
    final double distanceMultiplier = obstacle["distanceMultiplier"];
    final int distanceStep = obstacle["distanceStep"];
    late double startingIncline = obstacle["incline"];
    late double count = startingIncline;
    late List<Map<String,dynamic>> data = [];
    for (int i=0; i<faces; i++) {
      final double angleFactor = (i%angleStep)==0 ? (1+angleMultiplier) : (1-angleMultiplier);
      final double distanceFactor = (i%distanceStep)==0 ? (1+distanceMultiplier):(1-distanceMultiplier);
      final double distance =  double.parse((originalDistance*distanceFactor).toStringAsFixed(2));
      final double angle = double.parse(((360/faces) * angleFactor).toStringAsFixed(2));
      count = count+angle;
      final Map<String,dynamic> pointData = {"key": i, "distance": distance, "angle": count, "factor": factor};
      // print("obstacle: ${obstacle["key"]} => ${pointData}");
      data.add(pointData);
    } 
    return data;
  }

  List<Map<String,dynamic>> addPathToBoundaries(List<Map<String,dynamic>> boundaries, Size size,) {
    for (int i=0; i<boundaries.length; i++) {
      
      final Map<String,dynamic> boundaryData = boundaries[i];
      // List<Offset> points = convertBoundaryDataIntoCoordinates(boundaryData,size);

      // boundaries[i]["points"] = boundaryData["points"];
      Path shapeData = Helpers().getBoundaryPath(boundaryData["points"]);
      boundaries[i]["path"] = shapeData;
    }
    
    return boundaries;
  }  

  // List<Offset> adjustShapeForRounding(Map<String,dynamic> obstacle, Size size) {
  //   // List<Offset> points = getPointsAsOffsets(obstacle);
  //   List<Map<String,dynamic>> allPoints = getOffsets(origin, obstacle["points"],size);
  //   List<Offset> offsets = [];
  //   for (int i=0; i<allPoints.length; i++) {
  //     offsets.add(allPoints[i]["previous"]);
  //     offsets.add(allPoints[i]["current"]);
  //     offsets.add(allPoints[i]["next"]);
  //   }
  //   return offsets;
  // }

  Paint getObstaclePaint(Offset origin, Map<String, dynamic> obstacleObject, GamePlayState gamePlayState, double opacity, int alignment) {
    Map<String, dynamic> areaData = Helpers().getObstacleAreaData(origin);
    double minX = areaData["x"][0];
    double minY = areaData["y"][0];
    double maxX = areaData["x"][areaData["x"].length-1];
    double maxY = areaData["y"][areaData["y"].length-1];

    List<List<Offset>> alignments = [
      [Offset((minX + maxX) / 2, minY),Offset((minX + maxX) / 2, maxY), ],
      [Offset((minX + maxX) / 2, maxY),Offset((minX + maxX) / 2, minY), ],
    ];


    Color color = gamePlayState.colors[obstacleObject["colorKey"]];
    Paint obstaclePaint = Paint();
    obstaclePaint.shader = ui.Gradient.linear(
      alignments[alignment][0],
      alignments[alignment][1],
      // Offset((minX + maxX) / 2, minY), // Top-center of the shape
      // Offset((minX + maxX) / 2, maxY), // Bottom-center of the shape
          [
            color.withAlpha((255*opacity).floor()),
            Color.lerp(
              color.withAlpha((255*opacity).floor()), 
              const Color.fromARGB(255, 43, 43, 43).withAlpha((255*opacity).floor()), 
              0.2
            ) ?? color.withAlpha((255*opacity).floor()),
          ],
    );
    obstaclePaint.style = PaintingStyle.fill;
  
    return obstaclePaint;
  }


  List<Map<String,dynamic>> getJewelShapeData(Offset origin, Map<String,dynamic> obstacle, Size size, GamePlayState gamePlayState,double opacity, double sizeFactor) {
    List<Map<String,dynamic>> obstacleFaces = [];

    // get the points of the shape outer shape, and n smaller
    // final Offset origin = getOrigin(obstacle,size);
    // double innerJewelGap = obstacle["innerJewelSize"];
    // double cornerGap = obstacle["jewelCornerSize"];
    List<Map<String,dynamic>> innerShapePoints = getOffsets(origin, obstacle["data"], size, sizeFactor, );
    List<Map<String,dynamic>> outerShapePoints = getOffsets(origin, obstacle["data"], size, 1.0, );

    for (int index=0; index<obstacle["data"].length; index++) {
      int nextIndex = index+1 == obstacle["data"].length ? 0 : index+1;

      // CREATE SIDE PIECE
      Path sidePath = Path();
      Offset outerPoint1 = outerShapePoints.firstWhere((v) => v["key"]==index)["next"];
      Offset outerPoint2 = outerShapePoints.firstWhere((v) => v["key"]==nextIndex)["previous"];
      Offset innerPoint1 = innerShapePoints.firstWhere((v) => v["key"]==index)["next"];
      Offset innerPoint2 = innerShapePoints.firstWhere((v) => v["key"]==nextIndex)["previous"];

      sidePath.moveTo(outerPoint1.dx, outerPoint1.dy);
      sidePath.lineTo(outerPoint2.dx, outerPoint2.dy);
      sidePath.lineTo(innerPoint2.dx,innerPoint2.dy);
      sidePath.lineTo(innerPoint1.dx,innerPoint1.dy);

      Paint sidePaint = getObstaclePaint(origin, obstacle, gamePlayState, opacity,0);
      obstacleFaces.add({"key": index, "path": sidePath, "paint": sidePaint});

      Paint sidePaintShade = Paint()..color=Colors.black.withOpacity(0.4*opacity);
      obstacleFaces.add({"key": index, "path": sidePath, "paint": sidePaintShade});

      // CREATE CORNER PIECES 
      Path cornerPath = Path();
      Offset previousOuter = outerShapePoints.firstWhere((v) => v["key"]==index)["previous"];
      Offset currentOuter = outerShapePoints.firstWhere((v) => v["key"]==index)["current"];
      Offset nextOuter = outerShapePoints.firstWhere((v) => v["key"]==index)["next"];

      Offset previousInner = innerShapePoints.firstWhere((v) => v["key"]==index)["previous"];
      Offset currentInner = innerShapePoints.firstWhere((v) => v["key"]==index)["current"];
      Offset nextInner = innerShapePoints.firstWhere((v) => v["key"]==index)["next"];
      
      cornerPath.moveTo(previousOuter.dx, previousOuter.dy);
      cornerPath.quadraticBezierTo(
        currentOuter.dx, 
        currentOuter.dy,
        nextOuter.dx,
        nextOuter.dy,
      );
      cornerPath.lineTo(nextInner.dx, nextInner.dy);
      cornerPath.quadraticBezierTo(
        currentInner.dx, 
        currentInner.dy, 
        previousInner.dx, 
        previousInner.dy
      );
      cornerPath.lineTo(previousOuter.dx, previousOuter.dy);
      cornerPath.close();

      Paint cornerPaint = getObstaclePaint(origin, obstacle, gamePlayState, opacity,0);
      obstacleFaces.add({"key": index, "path": cornerPath, "paint": cornerPaint});
      Paint cornerPaintShade = Paint()..color=Colors.black.withOpacity(0.1*opacity);
      obstacleFaces.add({"key": index, "path": cornerPath, "paint": cornerPaintShade});
    }

    // CREATE INNER SHAPE
    Path innerPath = Path();
    Map<String,dynamic> firstPoint = innerShapePoints.firstWhere((v) => v["key"] == 0);
    innerPath.moveTo(firstPoint["previous"].dx, firstPoint["previous"].dy);
    innerPath.quadraticBezierTo(
      firstPoint["current"].dx, 
      firstPoint["current"].dy,
      firstPoint["next"].dx,
      firstPoint["next"].dy,
    );

    for (int i=1; i<innerShapePoints.length; i++) {
      final Map<String,dynamic> cornerData = innerShapePoints.firstWhere((v) => v["key"] == i);
      innerPath.lineTo(cornerData["previous"].dx, cornerData["previous"].dy);
      innerPath.quadraticBezierTo(
        cornerData["current"].dx, 
        cornerData["current"].dy,
        cornerData["next"].dx,
        cornerData["next"].dy,
      );
    }

    Paint innerPaint = getObstaclePaint(origin, obstacle, gamePlayState, opacity,1);
    obstacleFaces.add({"key": obstacle["key"], "path": innerPath, "paint": innerPaint});

    return obstacleFaces;
  }


List<Map<String,dynamic>> getJewelShapeData2(
  Offset origin, 
  Map<String,dynamic> obstacle, 
  Size size, 
  GamePlayState gamePlayState,
  double opacity, 
  double sizeFactor,
  ) {
    List<Map<String,dynamic>> obstacleFaces = [];
    List<Map<String,dynamic>> outsideFaces = [];
    // List<Map<String,dynamic>> insideFaces = [];
    Color gemColor = gamePlayState.colors[obstacle["colorKey"]];

    /// get each of the faces;
    // List<Map<String,dynamic>> pointData = obstacle["data"];

    List<double> outsideDistances = [];
    // List<double> insideDistances = [];

    const double ubpct = 0.9; // upper boundary paint percent
    const double lbpct = 0.5; // lower boundary paint percent


    for (int i=0; i<obstacle["data"].length; i++) {
      int currentIndex = i;
      int nextIndex = (i+1) == obstacle["data"].length ? 0 : (i+1);

      final double currentAngle = obstacle["data"][currentIndex]["angle"];
      final double currentOutsideDistance = obstacle["data"][currentIndex]["distance"];
      final double currentFactor = obstacle["data"][currentIndex]["factor"];
      final double currentInsideDistance = double.parse((currentOutsideDistance*currentFactor).toStringAsFixed(2));
      
      final Offset point1 = getCoordinatesFromDistanceAndAngle(origin, {"angle": currentAngle, "distance": currentOutsideDistance}, size, 1.0);
      final Offset point4 = getCoordinatesFromDistanceAndAngle(origin, {"angle": currentAngle, "distance": currentInsideDistance}, size, 1.0);

      final double nextAngle = obstacle["data"][nextIndex]["angle"];
      final double nextOutsideDistance = obstacle["data"][nextIndex]["distance"];
      final double nextFactor = obstacle["data"][nextIndex]["factor"];
      final double nextInsideDistance = double.parse((nextOutsideDistance*nextFactor).toStringAsFixed(2));

      final Offset point2 = getCoordinatesFromDistanceAndAngle(origin, {"angle": nextAngle, "distance": nextOutsideDistance}, size, 1.0);
      final Offset point3 = getCoordinatesFromDistanceAndAngle(origin, {"angle": nextAngle, "distance": nextInsideDistance}, size, 1.0);

      final List<Offset> outsideFacePoints = [point1,point2,point3,point4];
      // final List<Offset> insideFacePoints = [origin,point3,point4];

      const Offset corner = Offset(10000.0,-10000.0);
      final double outsideFaceDistance = getAverageDistanceBetweenJewelFaceAndCorner(corner,outsideFacePoints);
      outsideDistances.add(outsideFaceDistance);
      
      // final double insideFaceDistance = getAverageDistanceBetweenJewelFaceAndCorner(corner,insideFacePoints);
      // insideDistances.add(insideFaceDistance);

      // outside face is a rectangle
      Path outsidePath = Path();
      outsidePath.moveTo(point1.dx, point1.dy);
      outsidePath.lineTo(point2.dx, point2.dy);
      outsidePath.lineTo(point3.dx, point3.dy);
      outsidePath.lineTo(point4.dx, point4.dy);
      outsidePath.close();
      final Map<String,dynamic> outsideFaceData = {
        "points": outsideFacePoints, 
        "distance": outsideFaceDistance, 
        "path": outsidePath,
        "outside": true,
      };
      outsideFaces.add(outsideFaceData);

      // // inside face is a triangle connecting the inside points to the origin
      // Path insidePath = Path();
      // insidePath.moveTo(origin.dx, origin.dy);
      // insidePath.lineTo(point3.dx, point3.dy);
      // insidePath.lineTo(point4.dx, point4.dy);
      // insidePath.close();      
      // final Map<String,dynamic> insideFaceData = {
      //   "points": insideFacePoints, 
      //   "distance": insideFaceDistance,
      //   "path": insidePath,
      //   "outside": false, 
      // };
      // insideFaces.add(insideFaceData);
      
    }


    double shortestDistanceOutside = outsideDistances.reduce(min);
    double longestDistanceOutside = outsideDistances.reduce(max);
    double differenceOutside = longestDistanceOutside-shortestDistanceOutside;

    outsideFaces.sort((a, b) => a["distance"].compareTo(b["distance"]));


    // double shortestDistanceInside = insideDistances.reduce(min);
    // double longestDistanceInside = insideDistances.reduce(max);
    // double differenceInside = longestDistanceInside-shortestDistanceInside;

    for (int i=0; i<outsideFaces.length; i++) {
      final double distanceFromFirst = outsideFaces[i]["distance"]-shortestDistanceOutside;
      // final double percentDistanceFromFirst = distanceFromFirst/differenceOutside;
      final double rankAsPercentage = i/outsideFaces.length;
      final double percentWhiteness = rankAsPercentage*(ubpct-lbpct)+lbpct;

      Color color = Color.lerp(gemColor, Colors.black, 0.1)??gemColor;
      Paint paint = Paint();
      paint.color = Color.lerp(
        Colors.white.withAlpha((255*opacity).floor()), 
        color.withAlpha((255*opacity).floor()), 
        percentWhiteness)??
        gemColor.withAlpha((255*opacity).floor());
      outsideFaces[i]["paint"] = paint;
      obstacleFaces.add(outsideFaces[i]);
    }


    // for (int i=0; i<insideFaces.length; i++) {
    //   final double distanceFromFirst = insideFaces[i]["distance"]-shortestDistanceOutside;
    //   final double percentDistanceFromFirst = distanceFromFirst/differenceInside;
    //   final double percentWhiteness = percentDistanceFromFirst*(ubpct-lbpct)+lbpct;
    //   Paint paint = Paint();
    //   paint.color = Color.lerp(Colors.white, gemColor, percentWhiteness)??gemColor;
    //   insideFaces[i]["paint"] = paint;
    //   obstacleFaces.add(insideFaces[i]);
    // }
    return obstacleFaces;
}


double getAverageDistanceBetweenJewelFaceAndCorner(Offset corner, List<Offset> pointsList) {
  double countOfDistance = 0.0;
  for (int i=0; i<pointsList.length; i++) {
    final Offset point = pointsList[i];
    final double distanceBetweenPoints = Helpers().calculateDistanceBetweenTwoPoints(point, corner);
    countOfDistance = countOfDistance + distanceBetweenPoints;
  }
  final double res = (countOfDistance / pointsList.length);
  return res;
}





  // List<Offset> convertBoundaryDataIntoCoordinates(Map<String,dynamic> boundaryData, Size size) {
  //   // final List<dynamic> anchors = boundaryData["anchors"];
  //   final double angle = boundaryData["angle"];
  //   final double axisBase = boundaryData["base"];
  //   final bool xAxis = boundaryData["xAxis"];

  //   List<Offset> offsets = [];
  //   // for (int i=0; i<anchors.length; i++) {
  //   //   // List<double> anchor = anchors[i];
  //   //   List<dynamic> anchor = anchors[i];
  //   //   Offset point = Helpers().convertPercentDataIntoOffset(anchor, size);
  //   //   offsets.add(point);
  //   // }

  //   // final List<Map<String,dynamic>> boundaryObjects = boundaryData["data"];
  //   final List<dynamic> boundaryObjects = boundaryData["data"];

  //   for (int i=0; i<boundaryObjects.length; i++) {
  //     final Map<String,dynamic> boundaryObject = boundaryObjects[i];
  //     final double coordinate = boundaryObject["coordinate"];
  //     final double distance = boundaryObject["distance"];
  //     final List<double> coord = xAxis ? [coordinate,axisBase] : [axisBase,coordinate];
  //     final Offset origin = Helpers().convertPercentDataIntoOffset(coord, size);
  //     final Map<String,dynamic> pointData = {"angle": angle, "distance": distance};
  //     final Offset finalCoordinate = getCoordinatesFromDistanceAndAngle(origin, pointData, size, 1.0);
  //     offsets.add(finalCoordinate);
  //   }
  //   return offsets;
  // }


}


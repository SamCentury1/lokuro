import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lokuro/functions/general.dart';
import 'package:lokuro/functions/helpers.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:lokuro/screens/game_screen/dialogs/level_failed_dialog.dart';
import 'package:lokuro/screens/game_screen/dialogs/level_passed_dialog.dart';
import 'package:lokuro/settings/settings_controller.dart';

class GameLogic {
  void panStart(GamePlayState gamePlayState, DragStartDetails details) {
    
    if (gamePlayState.isGameActive) {
      print("game is active");
    } else {
      print("game is not active");
      gamePlayState.setIsGameActive(false);
      gamePlayState.setIsDragStart(true);
      gamePlayState.setStartPoint(details.localPosition);
      gamePlayState.setUpdatePoint(details.localPosition);
      gamePlayState.setCurrentBallPoint(details.localPosition);      
    }

    
  }

  void panUpdate(GamePlayState gamePlayState, DragUpdateDetails details) {
    // if (gamePlayState.isInvalidDrag) {
    //   return;
    // } else {
      if (!gamePlayState.isGameActive) {
        gamePlayState.setUpdatePoint(details.localPosition);
        GameLogic().calculateLineAngle(gamePlayState);
      } else {
        print("trying to drag while game is going on");
      }
    // }
  }

  void panEnd(BuildContext context, GamePlayState gamePlayState, DragEndDetails details, SettingsState settingsState, SettingsController settings) {
    // if (gamePlayState.isInvalidDrag) {
    //   print("can't start from inside an obstacle");
    // } else {
      if (gamePlayState.isDragStart) {
        print("drag is start");
        gamePlayState.setIsDragStart(false);
        gamePlayState.setEndPoint(details.localPosition);
        gamePlayState.setLineData([gamePlayState.startPoint,details.localPosition]);
        gamePlayState.setIsDragEnd(true);
        gamePlayState.setCurrentBallPoint(gamePlayState.startPoint);
        gamePlayState.setIsGameActive(true);
        calculateBallVelocity(gamePlayState,settingsState.playAreaSize);
        startGame(context, gamePlayState,settingsState, settings);
      } else {
        print("drag is not start");
        return;
      }
    // }
  }






  void startGame(BuildContext context, GamePlayState gamePlayState, SettingsState settingsState, SettingsController settings) {
    if (gamePlayState.isGameActive) {
      gamePlayState.startGame( () => GameLogic().updateGameState(context, gamePlayState,settingsState, settings));
    } else {
      gamePlayState.pauseGame();
    }
  }


  void calculateLineAngle(GamePlayState gamePlayState) {
    Offset? startPoint = gamePlayState.startPoint;
    Offset? updatePoint = gamePlayState.updatePoint;
    double angleInDegrees = Helpers().calculateAngleBetweenTwoPoints(updatePoint, startPoint);
    gamePlayState.setLineAngle(angleInDegrees);
  }


  void validateGameOver(BuildContext context, GamePlayState gamePlayState) {

      print("last hit is zero - do nothing");

    List<int> actual = [];
    for (Map<String,dynamic> obstacle in gamePlayState.obstacleHitOrder) {
      if (obstacle["colorKey"]!=0) {
        actual.add(obstacle["colorKey"]);
      }
    }
    List<int> target =  gamePlayState.targetObstacleHitOrder;

      print("actual: => $actual || target => $target");

    if (!gamePlayState.isGameOver) {
      if (actual.length == target.length) {
        late int mistakes = 0;
        for (int i=0; i<actual.length; i++) {
          if (target[i] != actual[i]) {
            mistakes++;
          }
        }

        print(actual.length == target.length);
        if (mistakes > 0) {
          gamePlayState.setIsGameOver(true);
          gamePlayState.setIsLevelPassed(false);
          print("level ended?");
        } else {
          gamePlayState.setIsGameOver(true);
          gamePlayState.setIsLevelPassed(true);

          Helpers().updateHitBoundaries(gamePlayState);    
        }

        Future.delayed(const Duration(milliseconds: 1000), () {
          gamePlayState.timer?.cancel();
        });

        showGameOverDialog(context,gamePlayState);         
      } else {
        if (actual.isNotEmpty) {
          late int mistakes = 0;
          List<int> targetCut = List<int>.generate(actual.length, (int index) => target[index]);

          for (int i=0; i<actual.length; i++) {
            if (targetCut[i] != actual[i]) {
              mistakes++;
            }
          }

          if (mistakes > 0) {
            print("level not ended?");
            gamePlayState.setIsGameOver(true);
            gamePlayState.setIsLevelPassed(false);

            Future.delayed(const Duration(milliseconds: 500), () {
              gamePlayState.timer?.cancel();
            });

            showGameOverDialog(context,gamePlayState);             
          }
        }
      }   
      
    }
  }

  Future<void> showGameOverDialog(BuildContext context, GamePlayState gamePlayState) async {
    int count = 0;
    int stops = 100;
    Timer.periodic(const Duration(milliseconds: 5), (Timer t) {
      if (count == stops) {
        t.cancel();        
      } else {
        count++;
        double opacity = (1-(count/stops));
        gamePlayState.setEndOfGameBallOpacity(opacity);
      }
    });

    gamePlayState.setPreviousLevelObstacleData(gamePlayState.obstacleData);

    if (gamePlayState.isLevelPassed) {
      print("LEVEL PASSED DAWG");
      // Future.delayed(const Duration(milliseconds: 850), () async {
        showDialog(
          context: context,
          barrierColor: Colors.transparent,
          barrierDismissible: false,
          builder: (context) {
            return const LevelPassedDialog();
          }
        );  
      // });
    } else {
      print("LEVEL failed penis head");
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const LevelFailedDialog();
        }
      ); 
    }
    
  }

  // this function is run at initialization of the game and prevents the user from
  // dragging the ball from inside an obstacle. It creates a path that is then used to draw
  // the polygon
  // void initializeObstaclePaths(GamePlayState gamePlayState) {
  //   for (var obstacleObject in gamePlayState.obstacleData) {

  //     // Path obstaclePath = Path();
  //     // obstaclePath.moveTo(obstacleObject["points"][0].dx, obstacleObject["points"][0].dy);
  //     // for (int i = 1; i < obstacleObject["points"].length; i++) {
  //     //   obstaclePath.lineTo(obstacleObject["points"][i].dx, obstacleObject["points"][i].dy);
  //     // }
  //     // obstaclePath.close();
  //     // obstacleObject["path"] = obstaclePath; // Save the Path

  //     Path obstaclePath = Path();
  //     List<Map<String,dynamic>> all
  //   }
  // }

  void updateCollisionPoint(GamePlayState gamePlayState) {
    late Map<String,dynamic> closestPointData = Helpers().getCollisionPointData(gamePlayState);
    gamePlayState.setCollisionPointData(closestPointData);

  } 

  void updateGameState(BuildContext context, GamePlayState gamePlayState, SettingsState settingsState, SettingsController settings) {

    try {
      if (gamePlayState.isGameActive) { 
        

        
        Offset? currentBallPosition = gamePlayState.currentBallPoint;
        double increment = gamePlayState.ballIncrement;
        
        /// calculates where the ball would be with an increment of inc and an angle in the gamePlayState class
        Offset newBallPosition = Helpers().getBallEndPoint(gamePlayState,currentBallPosition, increment);

        /// void function updating the collision point in the gamePlayState class
        updateCollisionPoint(gamePlayState);

        checkOutOfBounds(context,gamePlayState,settingsState.playAreaSize);

        // gets the upcoming collision point based on angle;
        if (gamePlayState.collisionPointData["point"] == null) {
          
          gamePlayState.restartGame();
          General().initializeGame(context,gamePlayState.campaignKey!, gamePlayState.levelKey!, settingsState, gamePlayState, settings);

        } else {

          Offset upcomingCollisionPoint = gamePlayState.collisionPointData["point"];


          // check whether the new ball position WOULD collide with upcoming collision point
          final bool collision = Helpers().checkForCollision(newBallPosition,upcomingCollisionPoint);




          /// if there is a collision, first calculate the new angle and new position,
          /// if there isn't, set to the new ball position initially calculated
          if (collision) {



            

            // make sure to redirect the point if the collision is a direct corner hit
            upcomingCollisionPoint = Helpers().adjustForCornerCollision(gamePlayState, settingsState,upcomingCollisionPoint);

            // calculate the angle of the ball after hitting an obstacle. update it
            double newAngle = Helpers().calculateReflectedAngle(gamePlayState);

            gamePlayState.setLineAngle(newAngle);

            // check whether the obstacle hit was a game boundary or an obstacle
            if (gamePlayState.collisionPointData["object"]["type"]=="obstacle") {
              
              final int hitKey = gamePlayState.collisionPointData["object"]["key"];
              if (hitKey != 0) {
                gamePlayState.obstacleData
                .firstWhere((v) => v["key"] == hitKey)
                .update("active", (_) => false);

                Map<String,dynamic> obstacleHitData = {
                  "key": hitKey,
                  "hitOrder": gamePlayState.obstacleHitOrder.length,
                  "colorKey" : gamePlayState.obstacleData[hitKey]["colorKey"],
                  "position": newBallPosition, 
                  "animations": {
                    "animationProgress": 0.0,
                    "blockOpacity": 1.00,
                    // "explosionProgress": 0.0,
                    "explosionData": Helpers().getParticleData(newBallPosition),
                  }
                };

                gamePlayState.setObstacleHitOrder([...gamePlayState.obstacleHitOrder,obstacleHitData]);
                validateGameOver(context, gamePlayState); 
              }
            }

    

            
            if (gamePlayState.collisionPointData["object"]["type"]=="boundary") {
              executeBoundaryCollision(gamePlayState);

              // updateBoundaryData(gamePlayState, settingsState.playAreaSize);

              final int hitKey = gamePlayState.collisionPointData["object"]["key"];

              Map<String,dynamic> boundaryHitData = {
                "key": hitKey,
                "hitOrder": gamePlayState.boundaryHitData.length,
                // "colorKey" : gamePlayState.obstacleData[hitKey]["colorKey"],
                "position": newBallPosition, 
                "animations": {
                  "animationProgress": 0.0,
                  // "explosionProgress": 0.0,
                  "explosionData": Helpers().getBoundaryParticleData(newBallPosition),
                }
              };
              gamePlayState.setBoundaryHitData([...gamePlayState.boundaryHitData,boundaryHitData]);
            }

            gamePlayState.setCurrentBallPoint(upcomingCollisionPoint);

            
          } else {
            gamePlayState.setCurrentBallPoint(newBallPosition);
          }



          // if (gamePlayState.ballTrailEffect.isEmpty) {
          //   gamePlayState.setBallTrailEffect([newBallPosition]);
          // } else {
          //   List<Offset> trailPoints = [...gamePlayState.ballTrailEffect,newBallPosition];
          //   if (trailPoints.length > 10) {
          //     trailPoints = gamePlayState.ballTrailEffect.sublist(trailPoints.length - 10);
          //   }
          //   gamePlayState.setBallTrailEffect(trailPoints);
          // }

          Helpers().setBallTrailEffect(gamePlayState,newBallPosition);

          for (Map<String, dynamic> obstacleObject in gamePlayState.obstacleHitOrder) {

            double blockOpacity = obstacleObject["animations"]["blockOpacity"];
            double newBlockOpacity = (blockOpacity - 0.05).clamp(0.0, 1.0);
            obstacleObject["animations"].update("blockOpacity", (v) => newBlockOpacity);  

            double animationProgress = obstacleObject["animations"]["animationProgress"];
            double newAnimationProgress = (animationProgress + 0.025).clamp(0.0, 1.0);
            obstacleObject["animations"].update("animationProgress", (v) => newAnimationProgress);  
          }   

          for (Map<String, dynamic> boundaryObject in gamePlayState.boundaryHitData) {
            double animationProgress = boundaryObject["animations"]["animationProgress"];
            double newAnimationProgress = (animationProgress + 0.025).clamp(0.0, 1.0);
            boundaryObject["animations"].update("animationProgress", (v) => newAnimationProgress);              
          }
        }

        // print("obstacle animation data => ${gamePlayState.obstacleAnimationData.length}");

      }
    }catch (error) {
      print("updateGameState: ${error}");
    }
  }

  // void updateBoundaryData(GamePlayState gamePlayState, Size playAreaSize) {

  //   final int boundaryKey = gamePlayState.collisionPointData["object"]["key"];
  //   Map<String,dynamic> boundaryObject = gamePlayState.boundaryData[boundaryKey];
  //   final Offset point1 = gamePlayState.collisionPointData["object"]["point1"];
  //   final Offset point2 = gamePlayState.collisionPointData["object"]["point2"];
  //   List<Offset> rawPoints = boundaryObject["points"];

  //   int index1 = rawPoints.indexOf(point1);
  //   int index2 = rawPoints.indexOf(point2);

  //   Offset hitPoint = gamePlayState.collisionPointData["point"];
  //   // get the distance of the hit point to the edge
  //   final bool xAxis = boundaryObject["xAxis"];
  //   Map<String,dynamic> point1Data = boundaryObject["data"][index1];
  //   Map<String,dynamic> point2Data = boundaryObject["data"][index2];

  //   /// Which point was the collision closer to between the two points making the line that was hit?
  //   final double distanceToPoint1 = Helpers().calculateDistanceBetweenTwoPoints(point1, hitPoint);
  //   final double distanceToPoint2 = Helpers().calculateDistanceBetweenTwoPoints(point2, hitPoint);
  //   Map<String,dynamic> closestPointToCollision = {
  //     "index" : distanceToPoint1 < distanceToPoint2 ? index1 : index2,
  //     "pointData": distanceToPoint1 < distanceToPoint2 ? point1Data : point2Data,
  //     "location" : distanceToPoint1 < distanceToPoint2 ? point1 : point2,
  //   };
  //   Map<String,dynamic> furthestPointToCollision = {
  //     "index" : distanceToPoint1 >= distanceToPoint2 ? index1 : index2,
  //     "pointData": distanceToPoint1 >= distanceToPoint2 ? point1Data : point2Data,
  //     "location" : distanceToPoint1 >= distanceToPoint2 ? point1 : point2,
  //   };

  //   final int minIndex = min(index1,index2);
  //   final int maxIndex = max(index1,index2);

  //   late int chosen;
  //   if (maxIndex == boundaryObject["data"].length-1) {
  //     /// hit the two last points");
  //     chosen = maxIndex;                  
  //   } else {
  //     if (minIndex == 1 && maxIndex ==2) {
  //       /// hit two first points");
  //       chosen = maxIndex;
  //     } else {

  //       /// hit points in middle
  //       chosen = minIndex+1;
  //     }
  //   }    
  //   // remove the closest point
  //   if (closestPointToCollision["pointData"]["distance"]>(furthestPointToCollision["pointData"]["distance"]/2)) {
  //     // boundaryObject["data"].removeAt(closestPointToCollision["index"]);
  //     final double newPointDistance = ((closestPointToCollision["pointData"]["distance"]+furthestPointToCollision["pointData"]["distance"]).abs()/2)/2;
  //     boundaryObject["data"][closestPointToCollision["index"]].update("distance", (v) => newPointDistance);
  //   } else {
  //     final double collisionCoord = xAxis ? hitPoint.dx : hitPoint.dy;
  //     final double pointLocation = xAxis ? closestPointToCollision["location"].dx : closestPointToCollision["location"].dy;
  //     final double pointCoordinate = closestPointToCollision["pointData"]["coordinate"];
  //     final double newPointCoord = double.parse(((collisionCoord / ((pointLocation*100)/pointCoordinate))*100).toStringAsFixed(2));
  //     // final double newPointDistance = ((closestPointToCollision["pointData"]["distance"]+furthestPointToCollision["pointData"]["distance"]).abs()/2)/2;
  //     final double newPointDistance = 0.0;

  //     final Map<String,dynamic> newPointData = ({"coordinate": newPointCoord, "distance": newPointDistance} as Map<String,dynamic>);
      

  //     boundaryObject["data"].insert(chosen,newPointData);

  //   }
  //   late List<Map<String,dynamic>> newBoundaryData2 = General().addPathToBoundaries(gamePlayState.boundaryData, playAreaSize);
  //   gamePlayState.setBoundaryData(newBoundaryData2);      
    
  // }

  void checkOutOfBounds(BuildContext context, GamePlayState gamePlayState, Size playAreaSize) {
    

    if (
      gamePlayState.currentBallPoint!.dx < 0.0 || 
      gamePlayState.currentBallPoint!.dx > playAreaSize.width ||
      gamePlayState.currentBallPoint!.dy < 0.0 ||
      gamePlayState.currentBallPoint!.dy > playAreaSize.height) {

        print("~~~~~~~~~~~~~~~ OUT OF BOUNDS ~~~~~~~~~~~~~~");


        Future.delayed(const Duration(milliseconds: 1000), () {
          gamePlayState.timer?.cancel();
        });
        if (!gamePlayState.isGameOver) {
          showGameOverDialog(context,gamePlayState);
        }

        gamePlayState.setIsGameOver(true);
        gamePlayState.setIsGameActive(false);        

      }

  }


  /// calculates the distance between the start and end points of the pan,
  /// attributes a value that will be the distance the ball travels each refresh
  void calculateBallVelocity(GamePlayState gamePlayState, Size size) {

    late double maxIncrement = 8.0;
    late double minIncrement = 3.0;
    late double inc = (maxIncrement-minIncrement);
    double xDif = gamePlayState.startPoint!.dx - gamePlayState.endPoint!.dx;
    double yDif = gamePlayState.startPoint!.dy - gamePlayState.endPoint!.dy;
    final num xPow = pow((gamePlayState.startPoint!.dx - gamePlayState.endPoint!.dx),2);
    final num yPow = pow((gamePlayState.startPoint!.dy - gamePlayState.endPoint!.dy),2);
    final double distance = sqrt( xPow + yPow );
    
    int vel = (minIncrement + (distance/size.width) * inc).round();


    print("start x: ${xDif} - y${yDif}");

    gamePlayState.setBallIncrement(vel*1.0);


  }


  void executeBoundaryCollision(GamePlayState gamePlayState) {
    Map<String,dynamic> collisionData = gamePlayState.collisionPointData;
    int boundaryKey = collisionData["object"]["key"];
    Map<String,dynamic> boundaryData = gamePlayState.boundaryData.firstWhere((val) => val["key"] == boundaryKey);

    gamePlayState.boundaryData[boundaryKey].update("active", (v) => false);
    // boundaryData.update("active")
    gamePlayState.setBoundaryData(gamePlayState.boundaryData);
    print("boundary => $boundaryData"); 
  }





 

}
 
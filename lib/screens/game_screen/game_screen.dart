import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lokuro/components/coin_painter.dart';
import 'package:lokuro/components/gem_painter.dart';
import 'package:lokuro/functions/game_logic.dart';
import 'package:lokuro/functions/general.dart';
import 'package:lokuro/functions/helpers.dart';
import 'package:lokuro/providers/animation_state.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:lokuro/screens/game_over_screen.dart/game_over_screen.dart';
import 'package:lokuro/screens/game_screen/background_painter/background_painter.dart';
import 'package:lokuro/screens/game_screen/components/coin_collector.dart';
import 'package:lokuro/screens/game_screen/components/gem_scoreboard_item.dart';
import 'package:lokuro/screens/game_screen/components/gem_scoreboard_item_animation.dart';
import 'package:lokuro/screens/game_screen/play_area_painters/live_game_painter.dart';
import 'package:lokuro/screens/game_screen/play_area_painters/starting_state_painter.dart';
import 'package:lokuro/screens/game_screen/play_area_painters/windup_painter.dart';
import 'package:lokuro/screens/home_screen/home_screen.dart';
import 'package:lokuro/settings/settings_controller.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {

  late GamePlayState _gamePlayState;
  late AnimationState animationState;
  late SettingsState _settingsState;
  late SettingsController _settings;
  late AnimationController gameStartedController;
  late Animation<double> gameStartedAnimation;

  late ScrollController _scrollController;

  late Offset? menuBarDragStartOffset = null;
  late Offset? menuBarDragUpdateOffset = null;

  // Timer? _timer;

  late bool _isBottomBarActive = false;
  late bool _isBottomBarSuperActive = false;
  // late bool _goToNextLevel = false;

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    animationState = Provider.of<AnimationState>(context, listen: false);
    _settingsState = Provider.of<SettingsState>(context, listen: false);
    _settings = Provider.of<SettingsController>(context, listen: false);
    initializeAnimations();

    animationState.addListener(handleAnimationStateChange);
    _gamePlayState.addListener(handleAnimationStateChange);


    _scrollController = ScrollController();

    _scrollController.addListener((){
      setState(() {
        _isBottomBarSuperActive = true;
      });
    });

    executeGameStartedAnimation();



  }

  void initializeAnimations() {
    gameStartedController = AnimationController(
      duration: Duration(milliseconds: (_gamePlayState.startingAnimationDurationInSeconds * 1000).floor()),
      vsync:this
    );

    List<TweenSequenceItem<double>> gameStartedSequence = [
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0,), weight: 100),
      // TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0,), weight: 10),
    ];
    gameStartedAnimation = TweenSequence<double>(gameStartedSequence).animate(
      CurvedAnimation(
        parent: gameStartedController,
        curve: Curves.easeOut
      )
    );

      
  }

  void handleAnimationStateChange() {
    if (animationState.shouldRunGameStartedAnimation) {
      print("caca butt");
      executeGameStartedAnimation();
    }

    // if (animationState.shouldRunCountGemsAnimation) {

    //   var gems = _gamePlayState.currentCampaignState.levels[_gamePlayState.levelKey!]["order"];
    //   int count = 0;
    //   int target = (100 * gems.length).floor();

      // List<Map<String,dynamic>> scoreWidgets = [];
      // for (int i=0;i<gems.length;i++) {

      // }

      // for (int i=0;i<gems.length;i++) {

      //   int durationCount = 0;
      //   Future.delayed(Duration(seconds: i*1), () {
      //     Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      //       if (durationCount == 100) {

      //       }
      //     });
      //   });
      // }
      // Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      //   if (count == target) {
      //     timer.cancel();
      //     animationState.setShouldRunCountGemsAnimation(false);
      //     int campaignId = _gamePlayState.campaignKey!;
      //     int nextLevel = _gamePlayState.levelKey! + 1;          

      //     if (nextLevel == _gamePlayState.currentCampaignState.levels.length) {
      //       print("go to this new thing??");
      //       Navigator.of(context).pushReplacement(
      //         MaterialPageRoute(builder: (context) => const GameOverScreen())
      //       );  
      //     } else {
      //       General().navigateToNextLevel(context, campaignId, nextLevel, _settingsState, _gamePlayState, animationState,_settings);
      //       Navigator.of(context).pop();        
      //     } 
              
      //   } else {
      //     count++;
      //   }
      // });


    // }
  }

  void executeGameStartedAnimation() {
    gameStartedController.reset();
    gameStartedController.forward();

    Future.delayed(Duration(milliseconds: (_gamePlayState.startingAnimationDurationInSeconds * 1000).floor()), () {
      animationState.setShouldRunGameStartedAnimation(false);
      // gameStartedController.reset();
    });
  }


  @override
  Widget build(BuildContext context) {
    SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    SettingsController settings = Provider.of<SettingsController>(context, listen: false);

    final double playAreaWidth = settingsState.playAreaSize.width;
    final double coinCollectorWidth = playAreaWidth * 0.2;




    return SafeArea(
      minimum: EdgeInsets.only(bottom: 0.5),
      child: Consumer<GamePlayState>(
        builder: (context,gamePlayState,child) {


        

          // Helpers().getMapOfCollectedGems(gamePlayState);
          return Scaffold(
            // backgroundColor: const Color.fromARGB(255, 219, 219, 219),
            backgroundColor: Colors.black,
            body: AnimatedBuilder(
              animation: gameStartedController,
              builder: (context,child) {

                // Map<int,int> mapOfCollectedGems = Helpers().getMapOfCollectedGems(gamePlayState);
                
                // getCollectedGems
                return SizedBox(
                  width: settingsState.screenSize.width,
                  height: settingsState.screenSize.height,
                  child: Stack(
                    children: [

                      Positioned(
                        top: 0,
                        left: (settingsState.screenSize.width*0.05)/2,
                        child: Container(
                          width: settingsState.playAreaSize.width*0.95,
                          height: 30,
                          // color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 2,
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 1500),
                                      width: Helpers().getPercentCampaignCompleteBarWidth(gamePlayState,settingsState),
                                      height: 2,
                                      color: Colors.white,
                                    ),                              
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CoinCollector(gamePlayState: gamePlayState, animationState: animationState,),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children : getCollectedGems(gamePlayState,animationState),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        top:30,
                        child: Stack(
                          children: [
                            SizedBox(
                              width: settingsState.screenSize.width,
                              height: settingsState.playAreaSize.height,
                              child: CustomPaint(
                                painter: BackgroundPainter(
                                  settingsState: settingsState,
                                  gamePlayState: gamePlayState,
                                  startingAnimation: gameStartedAnimation,
                                  settings: settings,
                                ),
                              ),
                            ),
                            
                            Positioned(
                              top: 0,
                              child: GestureDetector(
                                onPanStart: (DragStartDetails details) {
                                  Offset touchPoint = details.localPosition;
                                      
                                  late bool touchValid = false;
                                      
                                  // Check if the touch point is inside any obstacle
                                  for (var obstacleObject in gamePlayState.obstacleData) {
                                    if (obstacleObject["active"] && obstacleObject["path"] != null && obstacleObject["key"]!=0) {
                                      if (obstacleObject["path"]!.contains(touchPoint)) {
                                        print("Touch on obstacle - ignoring input");
                                        touchValid = false;
                                        return; // Prevent interaction if inside an obstacle
                                      } else {
                                        touchValid = true;
                                        // gamePlayState.setIsInvalidDrag(true);
                                      }
                                    }
                                  }
                                  for (var boundaryObject in gamePlayState.boundaryData) {
                                    if (boundaryObject["path"]!=null) {
                        
                                      Path boundaryPath = Path();
                                      boundaryPath.moveTo(boundaryObject["points"][0].dx,boundaryObject["points"][0].dy);
                                      for (int i=0;i<boundaryObject["points"].length;i++) {
                                        boundaryPath.lineTo(boundaryObject["points"][i].dx,boundaryObject["points"][i].dy);
                                      }
                                      boundaryPath.close();
                        
                                      if (boundaryPath.contains(touchPoint)) {
                                        print("Touch on boundary - ignoring input");
                                        touchValid = false;
                                        return;
                                      } else {
                                        touchValid = true;
                                      }
                                    }
                                  }
                                  if (touchValid) {
                                    GameLogic().panStart(gamePlayState,details);
                                  }
                                },
                                onPanUpdate: (DragUpdateDetails details) => GameLogic().panUpdate(gamePlayState,details),
                                onPanEnd: (DragEndDetails details) => GameLogic().panEnd(context, gamePlayState,details,settingsState,settings),
                                onTap: () {
                                  if (gamePlayState.isGameActive) {
                                    
                                    print("tapped while game is active");
                                    gamePlayState.setIsGameActive(false);
                                    gamePlayState.restartGame();
                                    // gamePlayState.setBoundaryData(gamePlayState.boundaryData);
                                    gamePlayState.pauseGame();
                                    int currentLevel = gamePlayState.levelKey!; // Retrieve the current level key
                                    int currentCampaign = gamePlayState.campaignKey!;
                                    General().initializeGame(context, currentCampaign, currentLevel, settingsState, gamePlayState,settings);                            
                                    
                                    
                                    // General().initializeGame(context, gamePlayState.levelKey!, settingsState, gamePlayState);
                                  } else {
                                    print("tapped while game is not active");
                                  }
                                },
                                
                                child: Container(
                                  // color: Colors.orange,
                                  width: settingsState.playAreaSize.width,
                                  height: settingsState.playAreaSize.height,
                                  child: Builder(
                                    builder: (context) {
                                      if (gamePlayState.isDragStart) {
                                        return CustomPaint(
                                          painter: WindupPainter(gamePlayState: gamePlayState),
                                        );
                                      } else if (gamePlayState.isDragEnd) {
                                        return CustomPaint(
                                          painter: LiveGamePainter(gamePlayState: gamePlayState),
                                        );                                      
                                      } else {
                                        return CustomPaint(
                                          painter: StartingStatePainter(
                                            gamePlayState: gamePlayState, 
                                            settingsState: settingsState,
                                            startingAnimation: gameStartedAnimation
                                          ),
                                        );
                                      }
                                    }
                                  )
                                ),
                              ),
                        
                            ),
                            Positioned(
                              top: -2,
                              left: 0,
                              child: Container(
                                width: settingsState.screenSize.width,
                                height: 1,
                                color: Colors.black,
                        
                              ),
                            )
                          ],
                        ),
                      ),

                      // Positioned(
                      //   top: 2,
                      //   left: (settingsState.screenSize.width*0.05)/2,
                      //   child: Container(
                      //     // color: Colors.orange,
                      //     width: settingsState.playAreaSize.width*0.95,
                      //     height: 150,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Container(
                      //           width: coinCollectorWidth,
                      //           height: 25,
                      //         ),
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //           children : getCollectedGemsAnimation(gamePlayState,animationState),
                      //         ),
                      //       ],
                      //     ),
                      //   )
                      // ),

                      // animationState.shouldRunCountGemsAnimation ?
                      // Positioned(
                      //   top: 100,
                      //   left: 100,
                      //   child: Container(
                      //     width: 50,
                      //     height: 50,
                      //     color: Colors.red,
                      //   )
                      // ) : SizedBox(),




                      Positioned(
                        bottom: 0,
                        
                        left: (settingsState.screenSize.width*0.1)/2,
                        child: Container(
                          
                          height: 40,
                          width: settingsState.screenSize.width*0.9,
                          // color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                // color: Colors.yellow,
                              ),
                              Row(
                                
                                children: Helpers().displayTargetObstacles(gamePlayState, settingsState.playAreaSize.width - 140.0),
                              ),
                              Container(
                                // color: Colors.blue,
                                height: 40,
                                width: 40,
                                child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context, 
                                      builder: (context) {
                                        return Dialog(
                                          backgroundColor: const Color.fromARGB(255, 63, 62, 62),
                                          child: Container(
                                            child: Padding(
                                              padding: const EdgeInsets.all(22.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // Text("Help"),
                                                  // Divider(thickness: 1.0, color: Colors.white,),
                                                  Text(
                                                    "How to play: ",
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      color: Colors.white
                                                    ),
                                                  ),
                                                  Text(
                                                    "Hit the jewels in the order given at the bottom of the screen.",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white
                                                    ),                                                  
                                                  ),
                                                  Divider(thickness: 1.0, color: Colors.white,),
                                          
                                              
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    );
                                  }, 
                                  icon: const Icon(
                                    Icons.help,
                                    size: 25,
                                  )
                                ),
                              ),
                            ],
                          ),
                        )
                      ),
                    ],
                  ),
                );
              }
            ),
          );
        }
      ),
    );
  }
}

// double getBottomBarHeight(bool isBottomBarActive, GamePlayState gamePlayState, double screenHeight) {
//   late double res = 60.0; // default height

//   if (isBottomBarActive) {
//     res = 200.0;
//   } 

//   if (gamePlayState.isNextLevel) {
//     res = screenHeight;
//   }

//   return res;

// }

Widget mainMenuButton(String body, IconData icon, VoidCallback onTap) {
  Color fontColor = Colors.black;
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: GestureDetector(
      onTap: () => onTap(),
      child: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 1.0, 10.0, 1.0),
          child: Row(
            children: [
              Icon(icon, color: fontColor, size: 26,),
              SizedBox(width: 10.0,),
              Text(
                body,
                style: TextStyle(
                  color: fontColor,
                  fontSize: 24
                ),
              )
            ],
          ), 
        ),
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
      ),
    ),
  );
}

void goToMainMenu(BuildContext conte) {
  print("go to main menu!");
}


double getBottomBarHeight(bool isBottomBarActive, bool isBottomBarSuperActive) {
  late double res = 40.0;
  if (isBottomBarActive) {
    if (isBottomBarSuperActive) {
      res = 400.0;
    } else {
      res = 200.0;
    }
  }
  return res;
}
double getBottomBarContentHeight(bool isBottomBarSuperActive) {
  late double res = 140.0;
  if (isBottomBarSuperActive) {
    res = 340.0;
  } else {
    res = 140.0;
  }
  return res;
}

List<Widget> getCollectedGems(GamePlayState gamePlayState, AnimationState animationState) {
  // Map<int,int> mapCollectedGems = Helpers().getMapOfCollectedGems(gamePlayState);
  List<int> uniqueGems = Helpers().getUniqueGems(gamePlayState);

  List<int> previousGems = [];
  for (int i=0;i<gamePlayState.previousLevelObstacleData.length; i++) {
    int colorKey = gamePlayState.previousLevelObstacleData[i]["colorKey"];
    if (colorKey !=0 && !previousGems.contains(colorKey)) {
      previousGems.add(colorKey);
    }
  }
  
  List<Widget> widgets = [];
  for (int i=0; i<uniqueGems.length; i++) {
    int gemId = uniqueGems[i];
    // Widget item = getCollectedGem(gamePlayState,gemId,animationState);
    int order = previousGems.indexOf(gemId);
    // List<int> scores = Helpers().getCollectedGems(gamePlayState, gemId);
    Widget item = GemScoreboardItem(index:gemId, order: order,  animationState: animationState,);
    widgets.add(item);
  }
  return widgets;
} 

// List<Widget> getCollectedGemsAnimation(GamePlayState gamePlayState, AnimationState animationState) {
//   // Map<int,int> mapCollectedGems = Helpers().getMapOfCollectedGems(gamePlayState);
//   List<int> uniqueGems = Helpers().getUniqueGems(gamePlayState);

//   List<int> previousGems = [];
//   for (int i=0;i<gamePlayState.previousLevelObstacleData.length; i++) {
//     int colorKey = gamePlayState.previousLevelObstacleData[i]["colorKey"];
//     if (colorKey !=0 && !previousGems.contains(colorKey)) {
//       previousGems.add(colorKey);
//     }
//   }
  
//   List<Widget> widgets = [];
//   for (int i=0; i<uniqueGems.length; i++) {
//     int gemId = uniqueGems[i];
//     // Widget item = getCollectedGem(gamePlayState,gemId,animationState);
//     int order = previousGems.indexOf(gemId);
//     List<int> scores = Helpers().getCollectedGems(gamePlayState, gemId);
//     Widget item = GemScoreboardItemAnimation(index:gemId, order: order, scoreData:scores,  animationState: animationState,);
//     // Widget item = Container(
//     //   width: 50,
//     //   height:150,
//     //   color: gamePlayState.colors[i],
//     // );
//     widgets.add(item);
//   }
//   return widgets;
// } 


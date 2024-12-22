import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lokuro/functions/game_logic.dart';
import 'package:lokuro/functions/general.dart';
import 'package:lokuro/functions/helpers.dart';
import 'package:lokuro/providers/animation_state.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:lokuro/screens/game_screen/background_painter/background_painter.dart';
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
    initializeAnimations();
    animationState.addListener(handleAnimationStateChange);

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
    return SafeArea(
      minimum: EdgeInsets.only(bottom: 0.5),
      child: Consumer<GamePlayState>(
        builder: (context,gamePlayState,child) {
          return Scaffold(
            // backgroundColor: const Color.fromARGB(255, 219, 219, 219),
            backgroundColor: Colors.black,
            body: AnimatedBuilder(
              animation: gameStartedController,
              builder: (context,child) {
                return Stack(
                  children: [
                    SizedBox(
                      width: settingsState.screenSize.width,
                      height: settingsState.screenSize.height,
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
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: _isBottomBarActive ? Radius.circular(25.0) : Radius.circular(0.0),
                            topRight: _isBottomBarActive ? Radius.circular(25.0) : Radius.circular(0.0),
                          ),
                          color: const Color.fromARGB(255, 238, 231, 231).withOpacity(1.0),
                        ),
                        width: settingsState.playAreaSize.width,
                        // height: getBottomBarHeight(_isBottomBarActive, gamePlayState, settingsState.playAreaSize.height),
                        // height: _isBottomBarActive ? 200.0 : 60.0,
                        height: getBottomBarHeight(_isBottomBarActive, _isBottomBarSuperActive),
                        child: Stack(
                          children: [
                
                            Positioned(
                              left: 10,
                              top: 0,
                              child: SizedBox(
                                height: 60,
                                width: 60,
                                
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2.0, color: const Color.fromARGB(164, 39, 39, 39)),
                                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
                                    ),
                                    width: 30,
                                    height: 30,
                                    child: Center(
                                      child: Text(
                                        gamePlayState.levelKey.toString()
                                      )
                                    )
                                  ),
                                )
                              )
                            ),
                
                            Positioned(
                              top: 0,
                              child: GestureDetector(
                                onTap: () {
                                  if (_isBottomBarActive && !_isBottomBarSuperActive) {
                                    setState(() {
                                      _isBottomBarActive = true;
                                      _isBottomBarSuperActive = true;
                                    });                                
                                  }
                
                                  else if (!_isBottomBarActive && !_isBottomBarSuperActive) {
                                    setState(() {
                                      _isBottomBarActive = true;
                                      _isBottomBarSuperActive = false;
                                    });                                 
                                  }
                
                                  else if (_isBottomBarActive && _isBottomBarSuperActive) {
                                    setState(() {
                                      _isBottomBarActive = false;
                                      _isBottomBarSuperActive = false;
                                    });                                 
                                  }                              
                                },
                                onVerticalDragUpdate: (details) {
                                  if (details.localPosition.dy > 50) {
                                    setState(() {
                                      _isBottomBarActive = false;
                                      _isBottomBarSuperActive = false;
                                    });
                                  }
                
                                  if (details.localPosition.dy < 0 ) {
                                    setState(() {
                                      _isBottomBarActive = true;
                                      _isBottomBarSuperActive = false;
                                    });
                                  }
                                },                            
                                child: SizedBox(
                                  width: settingsState.playAreaSize.width,
                                  height: 60,
                                  child: Center(
                                    child: Container(
                                      width: settingsState.playAreaSize.width - 140,
                                      height: 60,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: Helpers().displayTargetObstacles(gamePlayState, settingsState.playAreaSize.width - 140.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                                      
                            Positioned(
                              right: 10,
                              top: 0,
                              child: Container(
                                height: 60,
                                width: 60,
                                // color: Colors.green,
                                child: IconButton(
                                  onPressed: () {
                                    /// SCENARIO 1: ACTIVE = FALSE | SUPERACTIVE = FALSE
                                    if (!_isBottomBarActive && !_isBottomBarSuperActive) {
                                      print("closed -> open only to half");
                                      setState(() {
                                        _isBottomBarActive = true;
                                        _isBottomBarSuperActive = false;
                                      });
                                    } else
                                     
                                    /// SCENARIO 2: ACTIVE = TRUE | SUPERACTIVE = FALSE
                                    if (_isBottomBarActive && !_isBottomBarSuperActive) {
                                      print("open at half - close it");
                                      setState(() {
                                        _isBottomBarActive = false;
                                        _isBottomBarSuperActive = false;
                                      });
                                    }
                                     
                                    /// SCENARIO 3: ACTIVE = TRUE | SUPERACTIVE = TRUE
                                    else if (_isBottomBarActive && _isBottomBarSuperActive) {
                                      print("open fully - close it");
                                      setState(() {
                                        _isBottomBarActive = false;
                                        _isBottomBarSuperActive = false;
                                      });
                                    } else {
                                      print("what the fuck??? ");
                                    }
                                  }, 
                                  icon: _isBottomBarActive ? Icon(Icons.arrow_downward) : Icon(Icons.settings)
                                ),
                              )
                            ),
                                      
                            !_isBottomBarActive ? SizedBox() : 
                            Positioned(
                              top: 60,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Container(
                                  height: getBottomBarContentHeight(_isBottomBarSuperActive),
                                  // color: Colors.orange,
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    child: Column(
                                      children: [
                                          mainMenuButton(
                                            "Main Menu",
                                            Icons.home,
                                            // () => goToMainMenu()
                                            () => General().navigateToMainMenu(context, gamePlayState)
                                          ),                                      
                                        // Container(
                                        //   height: 140,
                                        //   color: Colors.green,
                                        //   width: 300,
                                        // ),
                
                                        // Container(
                                        //   height: 50,
                                        //   color: Colors.blue,
                                        //   width: 300,
                                        // ),
                
                
                                        // Container(
                                        //   height: 170,
                                        //   color: Colors.yellow,
                                        //   width: 300,
                                        // ),
                
                
                                        // Container(
                                        //   height: 100,
                                        //   color: Colors.red,
                                        //   width: 300,
                                        // ),                                                                        
                                        // mainMenuButton(
                                        //   "Main Menu",
                                        //   Icons.home,
                                        //   () => goToMainMenu()
                                        // ),  
                                    
                                        // mainMenuButton(
                                        //   "How to Play",
                                        //   Icons.home,
                                        //   () => goToMainMenu()
                                        // ),  
                                    
                                        // mainMenuButton(
                                        //   "Settings",
                                        //   Icons.home,
                                        //   () => goToMainMenu()
                                        // ), 
                                    
                                        // mainMenuButton(
                                        //   "Skip Level",
                                        //   Icons.home,
                                        //   () => goToMainMenu()
                                        // ),  
                                    
                                        // mainMenuButton(
                                        //   "Hint",
                                        //   Icons.home,
                                        //   () => goToMainMenu()
                                        // ),                                                                                                                                                                          
                                    
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                      )
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
  late double res = 60.0;
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


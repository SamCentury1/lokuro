import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lokuro/functions/helpers.dart';
import 'package:lokuro/models/campaign_model.dart';
import 'package:lokuro/models/level_model.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:lokuro/settings/settings_controller.dart';

class GamePlayState extends ChangeNotifier {

  // late Campaign currentCampaignState;
  // void startCampaign(SettingsState settingsState) {
  //   currentCampaignState = settingsState.initialCampaignState.copy();
  //   notifyListeners();
  // }

  // void restartCampaign(SettingsState settingsState) {
  //   startCampaign(settingsState);
  // }  


  // // late Level currentState;
  // void startLevel(SettingsState settingsState) {
  //   currentState = settingsState.initialLevelState.copy();
  //   notifyListeners();
  // }

  // void restartLevel(SettingsState settingsState) {
  //   startLevel(settingsState);
  // }



  late int? _campaignKey = null;
  int? get campaignKey => _campaignKey;
  void setCampaignKey(int? value) {
    _campaignKey = value;
    notifyListeners();
  }

  late Campaign _currentCampaignState;
  Campaign get currentCampaignState => _currentCampaignState;
  void setCurrentCampaignState(SettingsController settings, int campaignId) {
    final Map<String,dynamic> jsonData = settings.campaignData.value[campaignId];
    _currentCampaignState = Campaign.fromJson(jsonData);  
    notifyListeners();
  }  



  late int? _levelKey = null;
  int? get levelKey => _levelKey;
  void setLevelKey(int? value) {
    _levelKey = value;
    notifyListeners();
  }

  late List<int?> _levelTransition = [null, null];
  List<int?> get levelTransition => _levelTransition;
  void setLevelTransition(List<int?> value) {
    _levelTransition = value;
    notifyListeners();
  }


  late List<Map<String,dynamic>>  _previousLevelObstacleData = [];
  List<Map<String,dynamic>>  get previousLevelObstacleData => _previousLevelObstacleData;
  void setPreviousLevelObstacleData(List<Map<String,dynamic>>  value) {
    _previousLevelObstacleData = value;
    notifyListeners();
  }  

  late Map<String,dynamic>  _levelData = {};
  Map<String,dynamic>  get levelData => _levelData;
  void setLevelData(Map<String,dynamic>  value) {
    _levelData = value;
    notifyListeners();
  }    

  late bool _isGameActive = false;
  bool get isGameActive => _isGameActive;
  void setIsGameActive(bool value) {
    _isGameActive = value;
    notifyListeners();
  }

  late bool _isInvalidDrag = false;
  bool get isInvalidDrag => _isInvalidDrag;
  void setIsInvalidDrag(bool value) {
    _isInvalidDrag = value;
    notifyListeners();
  }  

  late bool _isGameOver = false;
  bool get isGameOver => _isGameOver;
  void setIsGameOver(bool value) {
    _isGameOver = value;
    notifyListeners();
  }

  late bool _isLevelPassed = false;
  bool get isLevelPassed => _isLevelPassed;
  void setIsLevelPassed(bool value) {
    _isLevelPassed = value;
    notifyListeners();
  }    

  late double _endOfGameBallOpacity = 1.0;
  double get endOfGameBallOpacity => _endOfGameBallOpacity;
  void setEndOfGameBallOpacity(double value) {
    _endOfGameBallOpacity = value;
    notifyListeners();
  }  

  late bool _isDragStart = false;
  bool get isDragStart => _isDragStart;
  void setIsDragStart(bool value) {
    _isDragStart = value;
    notifyListeners();
  }

  late bool _isNextLevel = false;
  bool get isNextLevel => _isNextLevel;
  void setIsNextLevel(bool value) {
    _isNextLevel = value;
    notifyListeners();
  }  

  late bool _isDragEnd = false;
  bool get isDragEnd => _isDragEnd;
  void setIsDragEnd(bool value) {
    _isDragEnd = value;
    notifyListeners();
  }


  late Offset? _startPoint = null;
  Offset? get startPoint => _startPoint;
  void setStartPoint(Offset? value) {
    _startPoint = value;
    notifyListeners();
  }

  late Offset? _updatePoint = null;
  Offset? get updatePoint => _updatePoint;
  void setUpdatePoint(Offset? value) {
    _updatePoint = value;
    notifyListeners();
  }

  late Offset? _endPoint = null;
  Offset? get endPoint => _endPoint;
  void setEndPoint(Offset? value) {
    _endPoint = value;
    notifyListeners();
  }

  late Offset? _currentBallPoint = null;
  Offset? get currentBallPoint => _currentBallPoint;
  void setCurrentBallPoint(Offset? value) {
    _currentBallPoint = value;
    notifyListeners();
  } 

  late List<Offset> _ballTrailEffect = [];
  List<Offset> get ballTrailEffect => _ballTrailEffect;
  void setBallTrailEffect(List<Offset> value) {
    _ballTrailEffect = value;
    notifyListeners();
  }

  late double _lineAngle = 0.0;
  double get lineAngle => _lineAngle;
  void setLineAngle(double value) {
    _lineAngle = value;
    notifyListeners();
  }

  late double _ballIncrement = 0.0;
  double get ballIncrement => _ballIncrement;
  void setBallIncrement(double value) {
    _ballIncrement = value;
    notifyListeners();
  }  

  late double _startingAnimationDurationInSeconds = 1.5;
  double get startingAnimationDurationInSeconds => _startingAnimationDurationInSeconds;
  // void setStartingAnimationDurationInSeconds(double value) {
  //   _startingAnimationDurationInSeconds = value;
  //   notifyListeners();
  // }


  late List<int> _coinsCollected = [0];
  List<int> get coinsCollected => _coinsCollected;
  void setCoinsCollected(List<int> value) {
    _coinsCollected = value;
    notifyListeners();
  }



  late List<Offset?> _lineData = [];
  List<Offset?> get lineData => _lineData;
  void setLineData(List<Offset?> value) {
    _lineData = value;
    notifyListeners();
  }

  final List<Color> _colors = [
    Colors.transparent,
    const Color.fromARGB(255, 114, 8, 0),
    const Color.fromARGB(255, 75, 1, 104),
    const Color.fromARGB(255, 1, 65, 1),
    const Color.fromARGB(255, 197, 137, 8),
    const Color.fromARGB(255, 3, 82, 146),
    const Color.fromARGB(255, 16, 152, 141),
  ];
  List<Color> get colors => _colors;

  // late double? incrementX = _playAreaSize!.width * 0.01;
  // late double? incrementY = _playAreaSize!.height * 0.01;
  late List<Map<String,dynamic>> _obstacleData = [];
  List<Map<String,dynamic>> get obstacleData => _obstacleData;
  void setObstacleData(List<Map<String,dynamic>> value) {
    _obstacleData = value;
    notifyListeners();
  }  

  late List<Map<String,dynamic>> _boundaryData = [];
  List<Map<String,dynamic>> get boundaryData => _boundaryData;
  void setBoundaryData(List<Map<String,dynamic>> value) {
    _boundaryData = value;
    notifyListeners();
  }

  late List<int> _hitBoundaries = [];
  List<int> get hitBoundaries => _hitBoundaries;
  void setHitBoundaries(List<int> value) {
    _hitBoundaries = value;
    notifyListeners();
  }



  // late List<Map<String,dynamic>> _boundaryDataCopy = [];
  // List<Map<String,dynamic>> get boundaryDataCopy => _boundaryDataCopy;
  // void setBoundaryDataCopy(List<Map<String,dynamic>> value) {
  //   _boundaryDataCopy = value;
  //   notifyListeners();
  // }    




  late Map<String,dynamic> _collisionPointData = {};
  Map<String,dynamic> get collisionPointData => _collisionPointData;
  void setCollisionPointData(Map<String,dynamic> value) {
    _collisionPointData = value;
    notifyListeners();
  }


  late List<int> _targetObstacleHitOrder = [];// [1,5,1,5];
  List<int> get targetObstacleHitOrder => _targetObstacleHitOrder;
  void setTargetObstacleHitOrder(List<int> value) {
    _targetObstacleHitOrder = value;
    notifyListeners();
  }

  late List<Map<String,dynamic>> _obstacleHitOrder = [];
  List<Map<String,dynamic>> get obstacleHitOrder => _obstacleHitOrder;
  void setObstacleHitOrder(List<Map<String,dynamic>> value) {
    _obstacleHitOrder = value;
    notifyListeners();
  }

  late List<Map<String,dynamic>> _boundaryHitData = [];
  List<Map<String,dynamic>> get boundaryHitData => _boundaryHitData;
  void setBoundaryHitData(List<Map<String,dynamic>> value) {
    _boundaryHitData = value;
    notifyListeners();
  }  


  // late List<Map<String,dynamic>> _obstacleAnimationData = [];
  // List<Map<String,dynamic>> get obstacleAnimationData => _obstacleAnimationData;
  // void setObstacleAnimationData(List<Map<String,dynamic>> value) {
  //   _obstacleAnimationData = value;
  //   notifyListeners();
  // }


  Timer? _timer;
  Timer? get timer => _timer;

  void startGame( VoidCallback func) {
    
    _timer = Timer.periodic(const Duration(milliseconds: 10), (Timer t) {
      func();
    });
  }

  void restartGame() {
    _timer!.cancel();
    // _isGameOver = false;
    _isGameActive = false;
    _isDragStart = false;
    _isDragEnd = false;
    _startPoint = null;
    _currentBallPoint = null;
    _updatePoint = null;
    _endPoint = null;
    _endOfGameBallOpacity = 1.0;
    _ballIncrement = 0.0;
    _obstacleHitOrder = [];
    _boundaryHitData = [];
    // _obstacleAnimationData = [];
    // _boundaryData = Helpers().deepCopy(_boundaryDataCopy);
    _ballTrailEffect= [];
    // _isNextLevel = false;
    _obstacleData = [];
    _obstacleData.forEach((dynamic value) {
      value.update("active", (v) => true);
      // value.update("opacity", (v)=> 1.0);
    });    
  }

  void pauseGame() {

    _timer!.cancel();
    _isGameActive = false;
    _currentBallPoint = null;
    _obstacleHitOrder = [];
    _ballTrailEffect = [];
    _ballIncrement = 0.0;
    _boundaryHitData = [];
    // _obstacleAnimationData = [];
    // _boundaryData = Helpers().deepCopy(_boundaryDataCopy);
    // _boundaryData = boundaryData;
    _obstacleData.forEach((dynamic value) {
      value.update("active", (v) => true);
    });    
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }  

}
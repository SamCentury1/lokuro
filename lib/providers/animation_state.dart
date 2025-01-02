import 'package:flutter/material.dart';

class AnimationState extends ChangeNotifier {



  late bool _shouldRunGameStartedAnimation = false;
  bool get shouldRunGameStartedAnimation => _shouldRunGameStartedAnimation;
  void setShouldRunGameStartedAnimation(bool value) {
    _shouldRunGameStartedAnimation = value;
    notifyListeners();
  }


  late bool _shouldRunCountGemsAnimation = false;
  bool get shouldRunCountGemsAnimation => _shouldRunCountGemsAnimation;
  void setShouldRunCountGemsAnimation(bool value) {
    _shouldRunCountGemsAnimation = value;
    notifyListeners();
  }  


}
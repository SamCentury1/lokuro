import 'package:flutter/material.dart';

class AnimationState extends ChangeNotifier {



  late bool _shouldRunGameStartedAnimation = false;
  bool get shouldRunGameStartedAnimation => _shouldRunGameStartedAnimation;
  void setShouldRunGameStartedAnimation(bool value) {
    _shouldRunGameStartedAnimation = value;
    notifyListeners();
  }


}
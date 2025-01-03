import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lokuro/components/gem_painter.dart';
import 'package:lokuro/functions/helpers.dart';
import 'package:lokuro/providers/animation_state.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:provider/provider.dart';

class GemScoreboardItem extends StatefulWidget {
  final int index;
  final int order;
  final AnimationState animationState;
  const GemScoreboardItem({
    super.key,
    required this.index,
    required this.order,
    required this.animationState,
  });

  @override
  State<GemScoreboardItem> createState() => _GemScoreboardItemState();
}

class _GemScoreboardItemState extends State<GemScoreboardItem> {

  late int target = 0;
  late int val = 0;
  late int val2 = 0;
  late GamePlayState _gamePlayState;
  @override
  void initState() {
    // TODO: implement initState


    super.initState();
    
    _gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    widget.animationState.addListener(handleAnimationStateChanges);
    


  }

  void handleAnimationStateChanges() {
    if (widget.animationState.shouldRunGameStartedAnimation) {
      if (widget.order >= 0) {
        // startAnimation();
        Future.delayed(Duration(milliseconds: 300 * widget.order), () {
          startAnimation();
        });
      }
      // startAnimation();
    }  
  }

  void startAnimation() {
    List<int> scores = Helpers().getCollectedGems(_gamePlayState, widget.index);
    // target = scores[1];
    // val = scores[0];
    int diff = scores[1]-scores[0];

    for (int i=0; i<(diff); i++) {

      print("add score ${i} in gem ${widget.index}");
      startTimer((1));
    }
    // Timer.periodic(const Duration(milliseconds:500), (Timer timer) {
    //   if (val == target) {
    //     timer.cancel();
    //   } else {
    //     setState(() {
    //       val++;
    //     });
    //   }
    // });

  }

  void startTimer(int counter) {
    // val = scores[0]+counter;
    const int inc = 10;
    Timer.periodic(const Duration(milliseconds: inc), (Timer timer) {
      if (val2 == 500) {
        timer.cancel();
        setState(() {
          val2 = 0;
          val = val + counter;
        });
      } else {
        setState(() {
          val2 = val2 + inc;
        });            
      }
    });
  }



  @override
  Widget build(BuildContext context) {

    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        SettingsState settingsState = Provider.of<SettingsState>(context,listen: false);
        final double playAreaWidth = settingsState.playAreaSize.width;
        List<int> uniqueGems = Helpers().getUniqueGems(gamePlayState);
        final double gemCollectorWidth = playAreaWidth * (0.7)/uniqueGems.length;         
        Color color = gamePlayState.gemstoneData[widget.index]["color"];
        final double progress = (val2/500);

        // final double parabollicCurveProgress = getParabollicCurveProgress(progress);
        // final Color shadowColor = getShadowColor(parabollicCurveProgress);
        // final FontWeight fontWeight = getFontWeight(progress);
        // print("parabollicCurveProgress => $parabollicCurveProgress");
        return Container(
          width: gemCollectorWidth,
          // color: color,           
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(

                width: 25,
                height: 25,
                child: CustomPaint(
                  painter: GemPainter1(color: color),
                ),
              ),
              // SizedBox(width: 3,),
              Text(
                val.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  // shadows: [
                  //   Shadow(
                  //     color: shadowColor,
                  //     offset: Offset(-2.0,-2.0),
                  //     blurRadius:15.0,
                  //   ),

                  //   Shadow(
                  //     color: shadowColor,
                  //     offset: Offset(-2.0,2.0),
                  //     blurRadius:15.0,
                  //   ),

                  //   Shadow(
                  //     color: shadowColor,
                  //     offset: Offset(2.0,-2.0),
                  //     blurRadius:15.0,
                  //   ),

                  //   Shadow(
                  //     color: shadowColor,
                  //     offset: Offset(2.0,2.0),
                  //     blurRadius:15.0,
                  //   ),                                                            
                  // ] 
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

Color getShadowColor(double progress) {
  Color res = Colors.transparent;
  if (progress > 0.0) {
    res = Colors.white.withAlpha((255 * (progress)).floor());
  }
  return res;
}


FontWeight getFontWeight(double progress) {
  FontWeight res = FontWeight.w400;
  if (progress > 0.0) {
    res = FontWeight.lerp(FontWeight.w400, FontWeight.w800, (progress))??FontWeight.w400;
  }
  return res;
}

double getParabollicCurveProgress(double progress) {
  late double res = progress; 
  if (progress > 0.5) {
    res = 1.0 - progress;
  }
  double res2 = res*2; 
  return res2;
}
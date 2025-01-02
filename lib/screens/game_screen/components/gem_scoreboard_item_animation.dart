import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lokuro/components/gem_painter.dart';
import 'package:lokuro/functions/helpers.dart';
import 'package:lokuro/providers/animation_state.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:provider/provider.dart';

class GemScoreboardItemAnimation extends StatefulWidget {
  final int index;
  final int order;
  final List<int> scoreData;
  final AnimationState animationState;
  const GemScoreboardItemAnimation({
    super.key,
    required this.index,
    required this.order,
    required this.scoreData,
    required this.animationState,
  });

  @override
  State<GemScoreboardItemAnimation> createState() => _GemScoreboardItemAnimationState();
}

class _GemScoreboardItemAnimationState extends State<GemScoreboardItemAnimation> {

  late int val = 0;
  final int durationMs = 500;
  late int target = durationMs;
  // late double progress = 0.0;
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

        Future.delayed(Duration(milliseconds: 300 * widget.order), () {
          // print("you are in gem id ${widget.index} and the order of ${widget.order}");
          startAnimation();
        });
      }
    }  
  }

  void startAnimation() {
    // int count = 0;
    List<int> scoreData = Helpers().getCollectedGems(_gamePlayState, widget.index);
    int diff = (scoreData[1]-scoreData[0]);

    for (int i=0; i<diff; i++) {
      // print("starting progress anim");
      startTimer();
    }


  }

  void startTimer() {
    const int inc = 10;
    Timer.periodic(const Duration(milliseconds: inc), (Timer timer) {
      if (val == 500) {
        timer.cancel();
        setState(() {
          val = 0;
        });
      } else {
        setState(() {
          val = val + inc;
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
        Color color = gamePlayState.colors[widget.index];

        final double progress = (val/durationMs); //val == 0 ? 0.0 : (val / durationMs);     
        return Container(
          // color: color.withAlpha(255),
          width: gemCollectorWidth,
          height: 100,
          child: Stack(
            children: [
              Positioned(
                bottom: 100 * (progress),
                // bottom:  0,
                child: SizedBox(
                  width: gemCollectorWidth,
                  child: Center(
                    child: Text(
                      // val.toString(),
                      // progress.toString(),
                      "+1",
                      style: TextStyle(
                        color: Colors.black.withAlpha((255*progress).floor()),
                        fontSize: 18 + (8 * progress),
                        shadows: <Shadow>[
                          Shadow(
                            color: Colors.white.withAlpha((255*progress).floor()),
                            offset: Offset(-2.0,-2.0),
                            blurRadius:15.0 * progress,
                          ),

                          Shadow(
                            color: Colors.white.withAlpha((255*progress).floor()),
                            offset: Offset(-2.0,2.0),
                            blurRadius:15.0 * progress,
                          ),

                          Shadow(
                            color: Colors.white.withAlpha((255*progress).floor()),
                            offset: Offset(2.0,-2.0),
                            blurRadius:15.0 * progress,
                          ),

                          Shadow(
                            color: Colors.white.withAlpha((255*progress).floor()),
                            offset: Offset(2.0,2.0),
                            blurRadius:15.0 * progress,
                          ),                           
                        ]
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
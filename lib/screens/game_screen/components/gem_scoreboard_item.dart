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
  final List<int> scoreData;
  final AnimationState animationState;
  const GemScoreboardItem({
    super.key,
    required this.index,
    required this.order,
    required this.scoreData,
    required this.animationState,
  });

  @override
  State<GemScoreboardItem> createState() => _GemScoreboardItemState();
}

class _GemScoreboardItemState extends State<GemScoreboardItem> {

  late int target = 0;
  late int val = 0;
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
    target = scores[1];
    val = scores[0];
    Timer.periodic(const Duration(milliseconds:500), (Timer timer) {
      if (val == target) {
        timer.cancel();
      } else {
        setState(() {
          val++;
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
                  shadows: [
                    // Shadow(
                    //   color: Colors.white,
                    //   offset: Offset(-2.0,-2.0),
                    //   blurRadius:15.0,
                    // ),

                    // Shadow(
                    //   color: Colors.white,
                    //   offset: Offset(-2.0,2.0),
                    //   blurRadius:15.0,
                    // ),

                    // Shadow(
                    //   color: Colors.white,
                    //   offset: Offset(2.0,-2.0),
                    //   blurRadius:15.0,
                    // ),

                    // Shadow(
                    //   color: Colors.white,
                    //   offset: Offset(2.0,2.0),
                    //   blurRadius:15.0,
                    // ),                                                            
                  ] 
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
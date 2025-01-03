import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lokuro/components/coin_painter.dart';
import 'package:lokuro/providers/animation_state.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:provider/provider.dart';

class CoinCollector extends StatefulWidget {
  final GamePlayState gamePlayState;
  final AnimationState animationState;
  const CoinCollector({
    super.key,
    required this.gamePlayState,
    required this.animationState,
  });

  @override
  State<CoinCollector> createState() => _CoinCollectorState();
}

class _CoinCollectorState extends State<CoinCollector> {

  // late GamePlayState _gamePlayState;
  late int counter = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _gamePlayState = Provider.of<GamePlayState>(context, listen:false);

        
    widget.animationState.addListener(handleAnimationStateChanges);
  }
  void handleAnimationStateChanges() {
    if (widget.animationState.shouldRunGameStartedAnimation) {
      startTimer();
      // if (widget.order >= 0) {

        // Future.delayed(Duration(milliseconds: 300 * widget.order), () {
        //   print("you are in gem id ${widget.index} and the order of ${widget.order}");
        //   startAnimation();
        // });
      // }
    }  
  }
  void startTimer() {
    const int inc = 10;
    final int stops = (1500/inc).floor();
    

    final List<int> coins = widget.gamePlayState.coinsCollected;
    final int previousIndex = coins.length==1 ? coins.length-1:coins.length-2;
    final int currentIndex = coins.length-1;
    final int previousAmount = coins[previousIndex]; 
    final int newAmount = coins[currentIndex]; 
    final int countIncrement = ((newAmount-previousAmount)/stops).floor();
    counter = previousAmount;    

    Timer.periodic(const Duration(milliseconds: inc), (Timer timer) {

      if (counter >= newAmount) {
        timer.cancel();
        setState(() {
          counter = newAmount;
        });
      } else {
        setState(() {
          counter = counter + countIncrement;
        });            
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    
    final double playAreaWidth = settingsState.playAreaSize.width;
    final double coinCollectorWidth = playAreaWidth * 0.2;

    return Consumer<GamePlayState>(
      builder: (context, gamePlayState,child) {
        // final List<int> coins = gamePlayState.coinsCollected;
        // final int previousIndex = coins.length==1 ? coins.length-1:coins.length-2;
        // final int currentIndex = coins.length-1;
        // final int previousAmount = coins[previousIndex]; 
        // final int newAmount = coins[currentIndex]; 

        return Container(
          width: coinCollectorWidth,
          height: 25,
          // color: Colors.yellow,
          child: Row(
            children: [
              SizedBox(
                width: 25,
                height: 25,
                child: CustomPaint(
                  painter: CoinPainter(),
                ),
              ),
              SizedBox(width: 5,),
              Text(
                // gamePlayState.coinsCollected.toString(),
                counter.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
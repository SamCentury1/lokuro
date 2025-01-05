import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lokuro/components/coin_painter.dart';
import 'package:lokuro/functions/helpers.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:provider/provider.dart';

class CoinsCollectedWidget extends StatefulWidget {
  final GamePlayState gamePlayState;
  final List<Map<String,dynamic>> gemSummaryTableData;
  const CoinsCollectedWidget({
    super.key,
    required this.gamePlayState,
    required this.gemSummaryTableData
  });

  @override
  State<CoinsCollectedWidget> createState() => _CoinsCollectedWidgetState();
}

class _CoinsCollectedWidgetState extends State<CoinsCollectedWidget> {





  late double coinsCollected = 0;
  late int index = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startCoinCount();
  }

  void startCoinCount() async {

    
    final int durationMs = (widget.gamePlayState.startingAnimationDurationInSeconds*1000).floor();
    final int tableLength = widget.gemSummaryTableData.length;
    final int gemCountDuration = (durationMs*tableLength);
    const int step= 10;
    final int stops = (gemCountDuration/step).floor();
    final double target = widget.gemSummaryTableData.map((e) => e["value"]).toList().reduce((a,b) => a+b);
    final double increment =target/stops;

    Timer.periodic(const Duration(milliseconds: step), (Timer timer) {

      // double increment = widget.gemSummaryTableData[index]["value"];
      if (coinsCollected >= target) {
        timer.cancel();
        setState(() {
          coinsCollected = target;
        });        
      } else {
        setState(() {
          coinsCollected = coinsCollected + increment;
          index++;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {


    // final GamePlayState gamePlayState = Provider.of<GamePlayState>(context,listen:false);
    final SettingsState settingsState = Provider.of<SettingsState>(context,listen:false);    

    return GestureDetector(
      onTap: () {
        setState(() {
          coinsCollected = 0.0;
          index = 0;
        });        
          startCoinCount();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            width: settingsState.screenSize.width*0.95,
            height: 100,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 14, 14, 14),
              borderRadius: BorderRadius.all(Radius.circular(12.0))
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: CustomPaint(
                        painter: CoinPainter(),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "${Helpers().formatDigits(coinsCollected,)} \$",
                        // coinsCollected.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
          ),
        ),
      ),
    );
  }
}
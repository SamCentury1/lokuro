import 'package:flutter/material.dart';
import 'package:lokuro/functions/game_logic.dart';
import 'package:lokuro/functions/general.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:lokuro/settings/settings_controller.dart';
import 'package:provider/provider.dart';

class LevelFailedDialog extends StatelessWidget {
  const LevelFailedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    GamePlayState _gamePlayState = Provider.of<GamePlayState>(context,listen: false);
    SettingsState _settingsState = Provider.of<SettingsState>(context,listen: false);
    SettingsController settings = Provider.of<SettingsController>(context,listen: false);
    final String messageBody = generateGameOverMessage(_gamePlayState);
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(12.0)) 
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  messageBody, 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 33,
                  )
                ),
                SizedBox(height: 30,),
        
                GestureDetector(
                  onTap: () {

                    Navigator.of(context).pop();
                    gamePlayState.restartGame();
                    gamePlayState.setIsGameOver(false);
                    General().initializeGame(context,gamePlayState.campaignKey!, gamePlayState.levelKey!, _settingsState, gamePlayState,settings);                    
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 59, 59, 59),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      boxShadow:[
                        BoxShadow(
                          color: Color.fromARGB(74, 219, 218, 218),
                          blurRadius: 12.0,
                          offset: Offset.zero,
                          spreadRadius: 5.0
                        )
                      ]
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Try Again",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 228, 226, 226),
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}


String generateGameOverMessage(GamePlayState gamePlayState) {
  final int hits = gamePlayState.obstacleHitOrder.length-1;
  final int total = gamePlayState.obstacleData.length;
  // final int left = total-hits;
  final double rate = hits/(total-1);
  late String res = "";
  if (rate >= 0.0 && rate < 0.10) {
    res = "Try a bit harder...";
  } else if (rate >= 0.10 && rate <0.20) {
    res = "Yikes, give it another shot";
  } else if (rate >=0.20 && rate <0.30) {
    res = "Oof we got work to do";
  } else if (rate >=0.30 && rate <0.40) {
    res = "That's okay, try again!";
  } else if (rate >=0.40 && rate <0.50) {
    res = "We'll get there!";
  } else if (rate >=0.50 && rate <0.60) {
    res = "We're getting close!";
  } else if (rate >=0.60 && rate <0.70) {
    res = "Getting real close!";
  } else if (rate >=0.70 && rate <0.80) {
    res = "Wow! Almost had it!";
  } else if (rate >=0.80 && rate <0.90) {
    res = "So close!";
  } else if (rate >=0.90 && rate <1.00) {
    res = "THIS close!!!";
  }
  return res;
}
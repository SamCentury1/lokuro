import 'package:flutter/material.dart';
import 'package:lokuro/functions/general.dart';
import 'package:lokuro/providers/animation_state.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:lokuro/screens/game_over_screen.dart/game_over_screen.dart';
import 'package:lokuro/settings/settings_controller.dart';
import 'package:provider/provider.dart';

class LevelPassedDialog extends StatefulWidget {
  const LevelPassedDialog({super.key});

  @override
  State<LevelPassedDialog> createState() => _LevelPassedDialogState();
}

class _LevelPassedDialogState extends State<LevelPassedDialog> {

  late SettingsState settingsState;
  late GamePlayState gamePlayState;
  late AnimationState animationState;
  late SettingsController settings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settingsState = Provider.of<SettingsState>(context, listen: false);
    gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    animationState = Provider.of<AnimationState>(context, listen: false);
    settings = Provider.of<SettingsController>(context,listen: false);
    closeDialog();
  }

  Future<void> closeDialog() async {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        gamePlayState.restartGame();
        int campaignId = gamePlayState.campaignKey!;
        int nextLevel = gamePlayState.levelKey! + 1;
        gamePlayState.setLevelTransition([gamePlayState.levelKey!,nextLevel]);

        // animationState.setShouldRunCountGemsAnimation(true);
        
        if (nextLevel == gamePlayState.currentCampaignState.levels.length) {
          print("go to this new thing??");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const GameOverScreen())
          );  
        } else {
          General().navigateToNextLevel(context, campaignId, nextLevel, settingsState, gamePlayState, animationState,settings);
          Navigator.of(context).pop();        
        }

      }
    });
    
  }


  @override
  Widget build(BuildContext context) {
    // SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    // GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    // AnimationState animationState = Provider.of<AnimationState>(context, listen: false);
    


    return Dialog(
      backgroundColor: Colors.transparent,
      shadowColor:null,
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
              "Well done!", 
              style: TextStyle(
                color: Colors.white,
                fontSize: 33,
              )
            ),
            SizedBox(height: 30,),

            // GestureDetector(
              // onTap: () {
              //   int nextLevel = gamePlayState.levelKey! + 1;
              //   // General().navigateToLevel(context,nextLevel,settingsState,gamePlayState);
              //   // gamePlayState.setIsNextLevel(true);
              //   Future.delayed(const Duration(milliseconds: 500), () {
              //     General().initializeGame(context, nextLevel, settingsState, gamePlayState, animationState);
              //     gamePlayState.restartGame();
              //     Navigator.of(context).pop();
              //   });
                

            //   },
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: const Color.fromARGB(255, 59, 59, 59),
            //       borderRadius: BorderRadius.all(Radius.circular(12.0)),
            //       boxShadow:[
            //         BoxShadow(
            //           color: const Color.fromARGB(74, 219, 218, 218),
            //           blurRadius: 12.0,
            //           offset: Offset.zero,
            //           spreadRadius: 5.0
            //         )
            //       ]
            //     ),
            //     child: Center(
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Text(
            //           "Next Level",
            //           style: TextStyle(
            //             color: const Color.fromARGB(255, 228, 226, 226),
            //             fontSize: 22,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
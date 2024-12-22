// import 'package:flutter/material.dart';
// import 'package:lokuro/functions/general.dart';
// import 'package:lokuro/providers/animation_state.dart';
// import 'package:lokuro/providers/game_play_state.dart';
// import 'package:lokuro/providers/settings_state.dart';
// import 'package:lokuro/screens/game_screen/game_screen.dart';
// import 'package:lokuro/settings/settings_controller.dart';
// import 'package:provider/provider.dart';

// class LevelButton extends StatelessWidget {
//   final int index;
//   const LevelButton({
//     super.key,
//     required this.index,
//   });

//   @override
//   Widget build(BuildContext context) {
//     SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
//     GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
//     AnimationState animationState = Provider.of<AnimationState>(context, listen: false);
//     SettingsController settings = Provider.of<SettingsController>(context, listen: false);

//     // Map<String,dynamic> backgroundData = settingsState.levelData[index]["background"];
//     Map<String,dynamic> backgroundData = {"colors": [2,4], "alignment": 4};
//     List<Color> backgroundColors = settingsState.backgroundColors;
//     List<List<Offset>> alignments = settingsState.backgroundAlignments;


//     // backgroundPaint.color = Colors.yellow;

//     int alignmentIndex =  backgroundData["alignment"];
//     // List<Offset> alignment = alignments[alignmentIndex];
//     // print(alignment);
    
//     // Offset start = alignment[0];
//     // Offset end = alignment[1];

//     List<Color> colors = [];
//     for (int i in backgroundData["colors"]) {
//       colors.add(backgroundColors[i]);
//     }



//     return GestureDetector(
//       onTap: () => General().navigateToLevel(context,index,settingsState,gamePlayState,animationState,settings),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           width: 60,
//           height: 60,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(12.0)),
//             // color: const Color.fromARGB(255, 59, 59, 59)
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: colors
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color.fromARGB(157, 231, 227, 227),
//                 offset: Offset(0.0,2.0),
//                 blurRadius: 3.0,
//                 spreadRadius: 1.0
//               )
//             ]
//           ),
//           child: Center(
//             child: Text(
//               index.toString(),
//               style: TextStyle(
//                 color: const Color.fromARGB(255, 46, 45, 45),
//                 fontSize: 22
//               ),
//             ),
//           ),
        
//         ),
//       ),
//     );
//   }
// }
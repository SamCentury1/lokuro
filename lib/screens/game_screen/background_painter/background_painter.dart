import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:lokuro/models/campaign_model.dart';
import 'package:lokuro/providers/game_play_state.dart';
import 'package:lokuro/providers/settings_state.dart';
import 'package:lokuro/settings/settings_controller.dart';

class BackgroundPainter extends CustomPainter {
  final SettingsState settingsState;
  final GamePlayState gamePlayState;
  final SettingsController settings;
  final Animation<double> startingAnimation;
  // final SettingsState settingsState;
  BackgroundPainter({
    required this.settingsState,
    required this.gamePlayState,
    required this.settings,
    required this.startingAnimation,
  });

  @override
  void paint(Canvas canvas, Size size) {





    Rect backgroundRect = Rect.fromCenter(
      center: Offset(size.width/2,size.height/2), 
      width: size.width, 
      height: size.height
    );
    
    Campaign campaignData = gamePlayState.currentCampaignState;
    List<String> campaignColors = campaignData.colors;

    late int previousLevelKey = gamePlayState.levelKey!-1 < 0 ? 0 : gamePlayState.levelKey!-1 ;
    late int currentLevelKey = gamePlayState.levelKey!;
    late int nextLevelKey = gamePlayState.levelKey!+1 > campaignColors.length ? gamePlayState.levelKey! : gamePlayState.levelKey!+1;


    String previousColorCode = campaignColors[previousLevelKey];
    String currentColorCode = campaignColors[currentLevelKey];
    String nextColorCode = campaignColors[nextLevelKey];
    
    int previousColorAsInt = int.parse(previousColorCode);
    int currentColorAsInt = int.parse(currentColorCode);
    int nextColorAsInt = int.parse(nextColorCode);
    
    Color previousColor =  Color(previousColorAsInt);
    Color currentColor = Color(currentColorAsInt);
    Color nextColor = Color(nextColorAsInt);


    List<Color> colors = [
      Color.lerp(currentColor, nextColor, startingAnimation.value)!,
      Color.lerp(previousColor, currentColor, startingAnimation.value)!,
    ];

    // backgroundPaint.shader = ui.Gradient.linear(
    //   Offset(size.width/2,0.0),
    //   Offset(size.width/2,size.height),
    //   colors,
    // );

    // Define the radial gradient
    final gradient = RadialGradient(
      center: Alignment.center, // Center of the gradient
      radius: 1.0, // Radius of the gradient (0.5 covers half the smallest side)
      colors: colors
      // stops: [0.2, 0.3],
    );

    // Define the paint with the gradient shader
    Paint backgroundPaint = Paint();
      backgroundPaint.shader = gradient.createShader(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.shortestSide / 2,
        ),
      );




    // canvas.drawRect(bgRect,backgroundPaint);
    canvas.drawRect(backgroundRect, backgroundPaint);
    // canvas.drawPaint(backgroundPaint);


    for (Map<String, dynamic> obstacleObject in gamePlayState.obstacleData) {
      if (!obstacleObject["active"] && obstacleObject["key"] != 0) {
        Path obstaclePath = obstacleObject["path"];
        Paint obstaclePaint = Paint();
        obstaclePaint.color = const ui.Color.fromARGB(48, 0, 0, 0);
        obstaclePaint.style = PaintingStyle.fill;
        canvas.drawPath(obstaclePath, obstaclePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) {
    return false;
  }
}   


// import 'dart:ui' as ui;

// import 'package:flutter/material.dart';
// import 'package:lokuro/models/campaign_model.dart';
// import 'package:lokuro/providers/game_play_state.dart';
// import 'package:lokuro/providers/settings_state.dart';
// import 'package:lokuro/settings/settings_controller.dart';

// class BackgroundPainter extends CustomPainter {
//   final SettingsState settingsState;
//   final GamePlayState gamePlayState;
//   final SettingsController settings;
//   final Animation<double> startingAnimation;

//   BackgroundPainter({
//     required this.settingsState,
//     required this.gamePlayState,
//     required this.settings,
//     required this.startingAnimation,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.shortestSide / 2;

//     // Fetch colors for the current campaign
//     Campaign campaignData = gamePlayState.currentCampaignState;
//     List<String> campaignColors = campaignData.colors;

//     int previousLevelKey = (gamePlayState.levelKey! - 1).clamp(0, campaignColors.length - 1);
//     int currentLevelKey = gamePlayState.levelKey!.clamp(0, campaignColors.length - 1);
//     int nextLevelKey = (gamePlayState.levelKey! + 1).clamp(0, campaignColors.length - 1);

//     Color previousColor = _colorFromHex(campaignColors[previousLevelKey]);
//     Color currentColor = _colorFromHex(campaignColors[currentLevelKey]);
//     Color nextColor = _colorFromHex(campaignColors[nextLevelKey]);

//     // Define colors for the void effect
//     List<Color> colors = [
//       Color.lerp(currentColor, nextColor, startingAnimation.value)!, // Inner color
//       currentColor.withOpacity(0.8), // Middle color
//       previousColor.withOpacity(0.5), // Outer color
//       Colors.black.withOpacity(0.8), // Edge fading into void
//     ];

//     List<double> stops = [
//       0.0, // Center
//       0.4, // Mid-region
//       0.7, // Near-edge
//       1.0, // Outer edge
//     ];

//     // Create the radial gradient
//     final gradient = RadialGradient(
//       center: Alignment.center,
//       radius: 1.0 + startingAnimation.value, // Expands the gradient over time
//       colors: colors,
//       stops: stops,
//     );

//     // Paint the gradient
//     Paint gradientPaint = Paint()
//       ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius));
//     canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), gradientPaint);

//     // Add optional depth rings for perspective
//     _paintDepthRings(canvas, center, radius, startingAnimation.value);
//   }

//   void _paintDepthRings(Canvas canvas, Offset center, double radius, double progress) {
//     for (int i = 1; i <= 5; i++) {
//       final ringRadius = radius * (progress + i * 0.2);
//       final opacity = (1.0 - i * 0.2).clamp(0.0, 1.0);
//       final ringPaint = Paint()
//         ..color = Colors.black.withOpacity(opacity)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2.0;
//       canvas.drawCircle(center, ringRadius, ringPaint);
//     }
//   }

//   Color _colorFromHex(String hexColor) {
//     int hexValue = int.parse(hexColor);
//     return Color(hexValue);
//   }

//   @override
//   bool shouldRepaint(covariant BackgroundPainter oldDelegate) {
//     return startingAnimation.value != oldDelegate.startingAnimation.value ||
//         gamePlayState.levelKey != oldDelegate.gamePlayState.levelKey;
//   }
// }

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
    Paint backgroundPaint = Paint();
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
      Color.lerp(previousColor, currentColor, startingAnimation.value)!,
      Color.lerp(currentColor, nextColor, startingAnimation.value)!,
    ];

    backgroundPaint.shader = ui.Gradient.linear(
      Offset(size.width/2,0.0),
      Offset(size.width/2,size.height),
      colors,
    );


    // canvas.drawRect(bgRect,backgroundPaint);
    canvas.drawPaint(backgroundPaint);


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
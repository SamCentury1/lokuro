import 'package:lokuro/models/level_model.dart';

class Campaign {
  final int campaignId;
  final String campaignName;
  final String campaignDescription;
  final String campaignPhotoUrl;
  final int difficulty;
  final List<String> colors;
  final List<Map<String,dynamic>> levels;


  Campaign({
    required this.campaignId,
    required this.campaignName,
    required this.campaignDescription,
    required this.campaignPhotoUrl,
    required this.difficulty,
    required this.colors,
    required this.levels,
  });

  /// copy the level state
  Campaign copy() {
    return Campaign(
      campaignId: campaignId,
      campaignName: campaignName,
      campaignDescription: campaignDescription,
      campaignPhotoUrl: campaignPhotoUrl,
      difficulty: difficulty,
      colors: colors,
      levels: levels,
    );
  }

  // create a level state from JSON
  factory Campaign.fromJson(Map<String,dynamic> json) {
    return Campaign(
      campaignId: json["campaignId"] is int ? json["campaignId"] : int.parse(json["campaignId"]),
      campaignName: json["campaignName"],
      campaignDescription: json["campaignDescription"],
      campaignPhotoUrl: json["campaignPhotoUrl"],
      difficulty : json["difficulty"]is int ? json["difficulty"] : int.parse(json["difficulty"]),
      colors: List<String>.from(json["colors"]),
      levels: List<Map<String,dynamic>>.from(json["levels"]),
  
    );
  }

  // convert the level state to JSON
  Map<String,dynamic> toJson() {
    return {
      'campaignId' : campaignId,
      'campaignName': campaignName,
      'campaignDescription': campaignDescription,
      'campaignPhotoUrl': campaignPhotoUrl,
      'difficulty': difficulty,
      'colors': colors,
      'levels': levels,
    };
  }
}


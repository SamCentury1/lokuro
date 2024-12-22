import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:lokuro/settings/settings_controller.dart';


class StorageMethods {
  
  Future<List<Map<String, dynamic>>> getLevelData() async {
    // Load the JSON file as a string
    final String jsonData = await rootBundle.loadString('assets/json/levels.json');

    // Decode the JSON string into a Map
    final List<dynamic> allLevels = jsonDecode(jsonData);

    
    final List<Map<String, dynamic>> res = List<Map<String, dynamic>>.from(allLevels.map((item) => item as Map<String, dynamic>)); 
    // Convert the list of dynamic objects to a list of maps
    return res;


  }

  Future<List<dynamic>> getLevelDataFromJsonFile(SettingsController settings) async {
    // Load the JSON file as a string
    final String jsonData = await rootBundle.loadString('assets/json/levels.json');

    // Decode the JSON string into a Map
    final List<dynamic> allLevels = jsonDecode(jsonData);

    return allLevels;

  }  


  Future<void> saveCampaignDataFromJsonFileToLocalStorage(SettingsController settings) async {
    // Load the JSON file as a string
    final String jsonData = await rootBundle.loadString('assets/json/levels.json');

    // Decode the JSON string into a Map
    final List<dynamic> allCampaigns = jsonDecode(jsonData);

    settings.setCampaignData(allCampaigns);
    
  } 

  Future<Map<String,dynamic>> getLevelFromStorage(SettingsController settings, int index) async {
    // Load the JSON file as a string
    final String jsonData = await rootBundle.loadString('assets/json/levels.json');

    // Decode the JSON string into a Map
    final List<dynamic> allLevels = jsonDecode(jsonData);

    final Map<String,dynamic> level = allLevels[index]; 

    return level;

  }    


  Future<Map<String,dynamic>> getCampaignFromStorage(SettingsController settings, int index) async {
    // Load the JSON file as a string
    final String jsonData = await rootBundle.loadString('assets/json/levels.json');

    // Decode the JSON string into a Map
    final List<dynamic> allCampaigns = jsonDecode(jsonData);

    final Map<String,dynamic> campaign = allCampaigns[index]; 

    return campaign;

  }         
}

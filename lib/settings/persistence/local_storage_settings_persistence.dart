import 'dart:convert';

import 'package:lokuro/settings/persistence/settings_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageSettingsPersistence extends SettingsPersistence {
  final Future<SharedPreferences> instanceFuture = SharedPreferences.getInstance();

  @override
  Future<List<dynamic>> getLevelData() async {
    final prefs = await instanceFuture;
    return json.decode(prefs.getString("levelData")??json.encode([]));
  }

  @override
  Future<List<dynamic>> getCampaignData() async {
    final prefs = await instanceFuture;
    return json.decode(prefs.getString("campaignData")??json.encode([]));
  }
  // =====================================================
  @override
  Future<void> saveLevelData(List<dynamic> value) async {
    final prefs = await instanceFuture;
    prefs.setString("levelData", json.encode(value)); 
  }

  @override
  Future<void> saveCampaignData(List<dynamic> value) async {
    final prefs = await instanceFuture;
    prefs.setString("campaignData", json.encode(value)); 
  }  
}
import 'package:lokuro/settings/persistence/settings_persistence.dart';

class MemoryOnlySettingsPersistence implements SettingsPersistence {
  List<dynamic> levelData = [];
  List<dynamic> campaignData = [];

  @override
  Future<List<dynamic>> getLevelData() async => levelData;

  Future<List<dynamic>> getCampaignData() async => campaignData;

  /// ---------------------------------------------------------

  @override
  Future<void> saveLevelData(List<dynamic> value) async => levelData = value;

  Future<void> saveCampaignData(List<dynamic> value) async => campaignData = value;

}
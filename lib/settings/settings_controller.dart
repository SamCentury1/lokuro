import 'package:flutter/foundation.dart';
import 'package:lokuro/settings/persistence/settings_persistence.dart';

class SettingsController {
  final SettingsPersistence _persistence;

  ValueNotifier<List<dynamic>> levelData = ValueNotifier([]);
  ValueNotifier<List<dynamic>> campaignData = ValueNotifier([]);

  /// Creates a new instance of [SettingsController] backed by [persistence].
  SettingsController({required SettingsPersistence persistence})
      : _persistence = persistence;

  Future<void> loadStateFromPersistance() async {
    await Future.wait([
      _persistence.getLevelData().then((value) => levelData.value = value),
      _persistence.getCampaignData().then((value) => campaignData.value = value)
    ]);
  }

  void setLevelData(List<dynamic> value) {
    levelData.value = value;
    _persistence.saveLevelData(levelData.value);
  }

  void setCampaignData(List<dynamic> value) {
    campaignData.value = value;
    _persistence.saveCampaignData(campaignData.value);
  }  
}
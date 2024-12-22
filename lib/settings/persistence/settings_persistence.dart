/// An interface of persistence stores for settings.
///
/// Implementations can range from simple in-memory storage through
/// local preferences to cloud-based solutions.
abstract class SettingsPersistence {
  /// ========== GET THE DATA ===================


  Future<List<dynamic>> getLevelData();

  Future<List<dynamic>> getCampaignData();


  /// ========== SAVE THE DATA ===================
  Future<void> saveLevelData(List<dynamic> value);

  Future<void> saveCampaignData(List<dynamic> value);

}

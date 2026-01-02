abstract class ManagerKpiRepo {
  Future<List<Map<String, dynamic>>> getTodayBatches();
  Future<List<Map<String, dynamic>>> getTodayInspections();
  Future<List<Map<String, dynamic>>> getHighRiskAlertsToday();
}

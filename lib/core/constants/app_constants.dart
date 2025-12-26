class AppConstants {
  // User Roles
  static const String roleSupervisor = 'supervisor';
  static const String roleQC = 'qc';
  static const String roleManager = 'manager';

  // Batch Status
  static const String statusInProgress = 'in_progress';
  static const String statusWaitingQC = 'waiting_qc';
  static const String statusPassed = 'passed';
  static const String statusFailed = 'failed';

  // QC Result
  static const String qcResultPass = 'pass';
  static const String qcResultFail = 'fail';
  // QC Reports
  static const String qcReportsCollection = "qc_reports";
  static const String qcReportsPath = "qc_reports";

  // Product Types
  static const List<String> productTypes = [
    'Burger',
    'Nuggets',
    'Escalope',
    'Luncheon',
    'Chicken Strips',
    'Meatballs',
    'Zinger',
    'Hot Dog',
    'Sausage',
  ];

  // Production Lines
  static const List<String> productionLines = [
    'Line GEA CutMaster',
    'Line WEILER ',
    'Line Laska',
    'Line WolfKing',
    'Line Zinger Production',
    'Line Burger Patties',
    'Line Escalope Production',
    'Line Nuggets Production',
  ];

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String batchesCollection = 'production_batches';
  static const String qcResultsCollection = 'qc_results';

  // Storage Paths
  static const String batchImagesPath = 'batch_images';
  static const String qcImagesPath = 'qc_images';
}

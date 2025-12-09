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

  // Product Types
  static const List<String> productTypes = [
    'Burger',
    'Nuggets',
    'Luncheon',
    'Zinger',
    'Hot Dog',
    'Sausage',
    'Chicken Strips',
    'Meatballs',
  ];

  // Production Lines
  static const List<String> productionLines = [
    'Line A',
    'Line B',
    'Line C',
    'Line D',
  ];

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String batchesCollection = 'production_batches';
  static const String qcResultsCollection = 'qc_results';

  // Storage Paths
  static const String batchImagesPath = 'batch_images';
  static const String qcImagesPath = 'qc_images';
}

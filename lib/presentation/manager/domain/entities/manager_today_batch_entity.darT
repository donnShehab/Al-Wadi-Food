class ManagerTodayBatchEntity {
  final String id;
  final String productName;
  final String line;
  final int quantity;
  final String status;
  final String? imageUrl;

  const ManagerTodayBatchEntity({
    required this.id,
    required this.productName,
    required this.line,
    required this.quantity,
    required this.status,
    this.imageUrl,
  });
}

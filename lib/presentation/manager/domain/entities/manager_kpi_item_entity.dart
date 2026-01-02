class ManagerKpiItemEntity {
  final String id;

  final String title; // productName
  final String subtitle; // line / inspector ...
  final String status; // passed / failed / waiting / in_progress
  final String? imageUrl;

  // Optional fields (for alerts / inspections)
  final double? temperature;
  final double? moisture;

  ManagerKpiItemEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
    this.imageUrl,
    this.temperature,
    this.moisture,
  });
}

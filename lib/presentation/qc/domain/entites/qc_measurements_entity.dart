class QCMeasurementsEntity {
  final double temperature;
  final double weight;
  final double moisture;
  final String texture;
  final String notes;
  final String packaging;

  QCMeasurementsEntity({
    required this.temperature,
    required this.weight,
    required this.moisture,
    required this.texture,
    required this.notes,

    required this.packaging,
  });
}

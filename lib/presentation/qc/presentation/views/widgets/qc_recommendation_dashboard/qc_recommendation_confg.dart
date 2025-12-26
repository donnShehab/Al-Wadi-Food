import 'package:flutter/material.dart';

class RecommendationConfig {
  final Color bgColor;
  final Color borderColor;
  final Color iconColor;
  final IconData icon;

  RecommendationConfig({
    required this.bgColor,
    required this.borderColor,
    required this.iconColor,
    required this.icon,
  });

  factory RecommendationConfig.fromSeverity(String severity) {
    switch (severity.toLowerCase()) {
      case "high":
        return RecommendationConfig(
          bgColor: const Color(0xFFFFF2F2),
          borderColor: const Color(0xFFFFB3B3),
          iconColor: Colors.red,
          icon: Icons.warning_amber_rounded,
        );

      case "medium":
        return RecommendationConfig(
          bgColor: const Color(0xFFFFF7E6),
          borderColor: const Color(0xFFFFD27A),
          iconColor: Colors.orange,
          icon: Icons.report_problem_outlined,
        );

      default:
        return RecommendationConfig(
          bgColor: const Color(0xFFF0FFF4),
          borderColor: const Color(0xFF9EE6B4),
          iconColor: Colors.green,
          icon: Icons.check_circle_outline,
        );
    }
  }
}

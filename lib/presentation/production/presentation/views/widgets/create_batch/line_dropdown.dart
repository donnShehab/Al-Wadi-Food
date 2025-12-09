import 'package:flutter/material.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/theme.dart';

class LineDropdown extends StatelessWidget {
  final String? selectedLine;
  final ValueChanged<String?> onChanged;

  const LineDropdown({
    super.key,
    required this.selectedLine,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedLine,
      decoration: InputDecoration(
        labelText: 'Production Line *',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      items: AppConstants.productionLines
          .map((line) => DropdownMenuItem(value: line, child: Text(line)))
          .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select a line' : null,
    );
  }
}

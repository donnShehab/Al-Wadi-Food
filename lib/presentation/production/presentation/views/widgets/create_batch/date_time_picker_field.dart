import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/widgets/custom_text_field.dart';

class DateTimePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateTimePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
  });

  Future<void> _pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        onDateSelected(
          DateTime(date.year, date.month, date.day, time.hour, time.minute),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      hint: selectedDate == null ? 'Select $label' : selectedDate.toString(),
      readOnly: true,
      onTap: () => _pickDateTime(context),
      suffixIcon: const Icon(Icons.calendar_today),
    );
  }
}

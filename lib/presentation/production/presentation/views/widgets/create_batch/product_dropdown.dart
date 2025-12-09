import 'package:flutter/material.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/theme.dart';

class ProductDropdown extends StatelessWidget {
  final String? selectedProduct;
  final ValueChanged<String?> onChanged;

  const ProductDropdown({
    super.key,
    required this.selectedProduct,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedProduct,
      decoration: InputDecoration(
        labelText: 'Product Type *',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      items: AppConstants.productTypes
          .map(
            (product) => DropdownMenuItem(value: product, child: Text(product)),
          )
          .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select a product' : null,
    );
  }
}

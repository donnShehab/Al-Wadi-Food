import 'dart:io';
import 'package:alwadi_food/core/utils/validators.dart';
import 'package:alwadi_food/presentation/production/data/models/production_batch_model.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/create_batch/date_time_picker_field.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/create_batch/image_picker_grid.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/create_batch/line_dropdown.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/create_batch/create_batch_field.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/create_batch/product_dropdown.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/create_batch/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/auth_repository.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';

class CreateBatchForm extends StatefulWidget {
  const CreateBatchForm({super.key});

  @override
  State<CreateBatchForm> createState() => _CreateBatchFormState();
}

class _CreateBatchFormState extends State<CreateBatchForm> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _operatorController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedProduct;
  String? _selectedLine;
  DateTime? _startTime;
  DateTime? _endTime;
  final List<File> _images = [];

  @override
  void dispose() {
    _quantityController.dispose();
    _operatorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState!.validate() &&
        _selectedProduct != null &&
        _selectedLine != null &&
        _startTime != null &&
        _endTime != null &&
        _images.isNotEmpty) {
      final userId = getIt<AuthRepository>().getCurrentUserId();
      final batch = ProductionBatchModel(
        batchId: DateTime.now().millisecondsSinceEpoch.toString(),
        product: _selectedProduct!,
        quantity: int.parse(_quantityController.text),
        startTime: _startTime!,
        endTime: _endTime!,
        line: _selectedLine!,
        operatorName: _operatorController.text,
        images: [],
        notes: _notesController.text,
        status: AppConstants.statusInProgress,
        createdBy: userId!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      context.read<ProductionCubit>().createBatch(batch, _images);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all required fields and add at least one image',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Production Batch')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductDropdown(
                  selectedProduct: _selectedProduct,
                  onChanged: (v) => setState(() => _selectedProduct = v),
                ),
                const SizedBox(height: 12),
                // QuantityField(controller: _quantityController),
                CreateBatchField(
                  controller: _quantityController,
                  textLabel: 'Quantity *',
                  hint: 'Enter quntity',
                  validator: (v) =>
                      Validators.validatePositiveNumber(v, 'Quantity'),
                ),
                const SizedBox(height: 12),
                LineDropdown(
                  selectedLine: _selectedLine,
                  onChanged: (v) => setState(() => _selectedLine = v),
                ),
                const SizedBox(height: 12),
                // OperatorField(controller: _operatorController),
                CreateBatchField(
                  controller: _operatorController,
                  textLabel: 'Operator Name *',
                  hint: 'Enter operator name',
                  validator: (v) =>
                      Validators.validateRequired(v, 'Operator name'),
                ),
                const SizedBox(height: 12),
                DateTimePickerField(
                  label: 'Start Time *',
                  selectedDate: _startTime,
                  onDateSelected: (v) => setState(() => _startTime = v),
                ),
                const SizedBox(height: 12),
                DateTimePickerField(
                  label: 'End Time *',
                  selectedDate: _endTime,
                  onDateSelected: (v) => setState(() => _endTime = v),
                ),
                const SizedBox(height: 12),
                // NotesField(controller: _notesController),
                CreateBatchField(
                  controller: _notesController,
                  textLabel: 'Notes',
                  hint: 'Enter notes',
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                Text(
                  'Product Images *',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ImagePickerGrid(
                  images: _images,
                  onChanged: () => setState(() {}),
                ),
                const SizedBox(height: 24),
                SubmitButtonCreateBatch(
                  onPressed: () => _handleSubmit(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

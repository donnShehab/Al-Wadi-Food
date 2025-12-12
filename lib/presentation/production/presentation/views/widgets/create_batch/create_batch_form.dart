import 'dart:io';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/create_batch/create_batch_field.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/create_batch/date_time_picker_field.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/create_batch/image_picker_grid.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/create_batch/line_dropdown.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/create_batch/product_dropdown.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/create_batch/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/core/utils/validators.dart';
import 'package:alwadi_food/presentation/widgets/custom_app_bar.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/auth_repository.dart';
import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/presentation/production/data/models/production_batch_model.dart';
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: buildAppBar(
        context,
        title: "Create Batch",
        backgroundColor: theme.colorScheme.primary,
        titleColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _buildHeaderCard(theme),

            const SizedBox(height: 20),

            /// Product Section
            _sectionCard(theme, "Product Information", [
              ProductDropdown(
                selectedProduct: _selectedProduct,
                onChanged: (v) => setState(() => _selectedProduct = v),
              ),
              const SizedBox(height: 12),
              CreateBatchField(
                controller: _quantityController,
                textLabel: "Quantity *",
                hint: "Enter quantity",
                keyboardType: TextInputType.number,
                validator: (v) =>
                    Validators.validatePositiveNumber(v, "Quantity"),
              ),
            ]),

            const SizedBox(height: 20),

            /// Production Details
            _sectionCard(theme, "Production Details", [
              LineDropdown(
                selectedLine: _selectedLine,
                onChanged: (v) => setState(() => _selectedLine = v),
              ),
              const SizedBox(height: 12),
              CreateBatchField(
                controller: _operatorController,
                textLabel: "Operator Name *",
                hint: "Enter operator name",
                validator: (v) =>
                    Validators.validateRequired(v, "Operator name"),
              ),
            ]),

            const SizedBox(height: 20),

            /// Time Section
            _sectionCard(theme, "Production Timing", [
              DateTimePickerField(
                label: "Start Time *",
                selectedDate: _startTime,
                onDateSelected: (v) => setState(() => _startTime = v),
              ),
              const SizedBox(height: 12),
              DateTimePickerField(
                label: "End Time *",
                selectedDate: _endTime,
                onDateSelected: (v) => setState(() => _endTime = v),
              ),
            ]),

            const SizedBox(height: 20),

            /// Notes Section
            _sectionCard(theme, "Additional Notes", [
              CreateBatchField(
                controller: _notesController,
                textLabel: "Notes",
                hint: "Enter details or observations",
                maxLines: 3,
              ),
            ]),

            const SizedBox(height: 20),

            /// Images Section
            _sectionCard(theme, "Product Images *", [
              ImagePickerGrid(
                images: _images,
                onChanged: () => setState(() {}),
              ),
            ]),

            const SizedBox(height: 32),

            SubmitButtonCreateBatch(onPressed: () => _handleSubmit(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(
              Icons.factory,
              size: 32,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              "Start a new production batch and document all key details for tracking and QC review.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(ThemeData theme, String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() != true ||
        _selectedProduct == null ||
        _selectedLine == null ||
        _startTime == null ||
        _endTime == null ||
        _images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields.")),
      );
      return;
    }

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
  }
}

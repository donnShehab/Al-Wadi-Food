import 'dart:io';
import 'dart:ui';

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
  // ✅ KEEP EXACT (logic)
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _operatorController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedProduct;
  String? _selectedLine;
  DateTime? _startTime;
  final List<File> _images = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ✅ UI-only: cinematic executive background (very subtle)
    final bg = BoxDecoration(
      gradient: RadialGradient(
        center: Alignment.topCenter,
        radius: 1.25,
        colors: [
          theme.colorScheme.surface,
          theme.colorScheme.primary.withOpacity(0.035),
        ],
      ),
    );

    return Scaffold(
      // ✅ KEEP appbar logic unchanged (same builder)
      appBar: buildAppBar(
        context,
        title: "Create Batch",
        backgroundColor: theme.colorScheme.primary,
        titleColor: Colors.white,
      ),
      body: DecoratedBox(
        decoration: bg,
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 140),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildHeaderCard(theme),

                      const SizedBox(height: 18),

                      /// Product Section
                      _sectionCard(
                        theme,
                        "Product Information",
                        icon: Icons.inventory_2_outlined,
                        children: [
                          ProductDropdown(
                            selectedProduct: _selectedProduct,
                            onChanged: (v) =>
                                setState(() => _selectedProduct = v),
                          ),
                          const SizedBox(height: 12),
                          CreateBatchField(
                            controller: _quantityController,
                            textLabel: "Quantity *",
                            hint: "Enter quantity",
                            keyboardType: TextInputType.number,
                            validator: (v) => Validators.validatePositiveNumber(
                              v,
                              "Quantity",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// Production Details
                      _sectionCard(
                        theme,
                        "Production Details",
                        icon: Icons.factory_outlined,
                        children: [
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
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// Time Section
                      _sectionCard(
                        theme,
                        "Production Timing",
                        icon: Icons.schedule_rounded,
                        children: [
                          DateTimePickerField(
                            label: "Start Time *",
                            selectedDate: _startTime,
                            onDateSelected: (v) =>
                                setState(() => _startTime = v),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// Notes Section
                      _sectionCard(
                        theme,
                        "Additional Notes",
                        icon: Icons.notes_rounded,
                        children: [
                          CreateBatchField(
                            controller: _notesController,
                            textLabel: "Notes",
                            hint: "Enter details or observations",
                            maxLines: 3,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// Images Section
                      _sectionCard(
                        theme,
                        "Product Images *",
                        icon: Icons.photo_library_outlined,
                        children: [
                          ImagePickerGrid(
                            images: _images,
                            onChanged: () => setState(() {}),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              /// ✅ Sticky Submit (UI only — same onPressed logic)
              Align(
                alignment: Alignment.bottomCenter,
                child: _StickySubmitBar(
                  child: SubmitButtonCreateBatch(
                    onPressed: () => _handleSubmit(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ UI-only: premium header card (less “heavy”, more executive)
  Widget _buildHeaderCard(ThemeData theme) {
    final surface = theme.colorScheme.surface;
    final border = theme.colorScheme.onSurface.withOpacity(0.08);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.92),
            theme.colorScheme.primary.withOpacity(0.70),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: surface.withOpacity(0.92),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.factory,
              size: 28,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "Start a new production batch and document all key details for tracking and QC review.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.95),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ UI-only: executive section card (icon + title, calmer typography)
  Widget _sectionCard(
    ThemeData theme,
    String title, {
    required IconData icon,
    required List<Widget> children,
  }) {
    final surface = theme.colorScheme.surface;
    final border = theme.colorScheme.onSurface.withOpacity(0.08);
    final titleColor = theme.colorScheme.onSurface.withOpacity(0.88);
    final iconTint = theme.colorScheme.primary.withOpacity(0.12);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconTint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 20, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  // ✅ KEEP EXACT logic — لا تغييرات
  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() != true ||
        _selectedProduct == null ||
        _selectedLine == null ||
        _startTime == null ||
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
      endTime: _startTime!,
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

/// ✅ UI-only: sticky submit bar with glass + safe area padding (no logic)
class _StickySubmitBar extends StatelessWidget {
  const _StickySubmitBar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = theme.colorScheme.onSurface.withOpacity(0.10);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.78),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: border, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 22,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

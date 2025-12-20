

import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/core/utils/validators.dart';
import 'package:alwadi_food/presentation/widgets/custom_button.dart';
import 'package:alwadi_food/presentation/widgets/custom_text_field.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// 👈 لا يوجد default role
  String? _role;

  void _handleSignup(BuildContext context) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_role == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a role')));
      return;
    }

    context.read<AuthCubit>().signUp(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      role: _role!, // آمن 100%
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthCubit>().state is AuthLoading;

    return SafeArea(
      child: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// -------- Name --------
              CustomTextField(
                controller: _nameController,
                label: 'Name',
                validator: (value) =>
                    Validators.validateRequired(value, "Name"),
              ),

              const SizedBox(height: 16),

              /// -------- Email --------
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                validator: Validators.validateEmail,
              ),

              const SizedBox(height: 16),

              /// -------- Password --------
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                validator: Validators.validatePassword,
              ),

              const SizedBox(height: 16),

              /// -------- Role --------
              DropdownButtonFormField<String>(
                value: _role,
                decoration: const InputDecoration(labelText: 'Role *'),
                items: const [
                  DropdownMenuItem(
                    value: AppConstants.roleManager,
                    child: Text("Manager"),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.roleSupervisor,
                    child: Text("Supervisor"),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.roleQC,
                    child: Text("QC"),
                  ),
                ],
                validator: (value) =>
                    value == null ? 'Please select a role' : null,
                onChanged: (value) => setState(() => _role = value),
              ),

              const SizedBox(height: 32),

              /// -------- Submit --------
              CustomButton(
                text: 'Create Account',
                icon: Icons.person_add,
                isLoading: loading,
                onPressed: () => _handleSignup(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

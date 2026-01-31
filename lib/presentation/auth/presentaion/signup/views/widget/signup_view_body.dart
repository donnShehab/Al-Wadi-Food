import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/core/utils/validators.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/auth/presentaion/widgets/auth_scaffold.dart';
import 'package:alwadi_food/presentation/widgets/brand/alwadi_icon.dart';
import 'package:alwadi_food/presentation/widgets/custom_button.dart';
import 'package:alwadi_food/presentation/widgets/custom_text_field.dart';
import 'package:alwadi_food/presentation/widgets/surfaces/executive_card.dart';
import 'package:alwadi_food/theme.dart';

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

  String? _role;

  void _handleSignup(BuildContext context) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role')),
      );
      return;
    }

    context.read<AuthCubit>().signUp(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      role: _role!,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _roleDecoration(BuildContext context) {
    final theme = Theme.of(context);

    // This makes the Dropdown match your CustomTextField “premium” style.
    return InputDecoration(
      labelText: 'Role *',
      filled: true,
      fillColor: theme.colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.colorScheme.onSurface.withOpacity(0.06),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.colorScheme.onSurface.withOpacity(0.06),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.colorScheme.primary.withOpacity(0.55),
          width: 1.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthCubit>().state is AuthLoading;

    return AuthScaffold(
      // Signup is reached from Login, not Splash — so we keep it clean:
      // No Hero here to avoid tag conflicts and keep navigation stable.
      heroLogo: const AlwadiIcon(size: 70),
      title: 'Sign Up',
      subtitle: 'Create your account',
      card: ExecutiveCard(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Name',
                validator: (value) =>
                    Validators.validateRequired(value, "Name"),
              ),
              const SizedBox(height: 18),

              CustomTextField(
                controller: _emailController,
                label: 'Email',
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 18),

              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 18),

              DropdownButtonFormField<String>(
                value: _role,
                decoration: _roleDecoration(context),
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
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

              const SizedBox(height: 22),

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

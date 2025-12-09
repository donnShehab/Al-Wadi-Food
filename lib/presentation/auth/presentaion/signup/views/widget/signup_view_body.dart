import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/core/utils/validators.dart';
import 'package:alwadi_food/presentation/widgets/custom_button.dart';
import 'package:alwadi_food/presentation/widgets/custom_text_field.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/theme.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'manager';

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

    return Padding(
      padding: AppSpacing.paddingLg,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              label: 'Name',
              controller: _nameController,
              validator: (value) => Validators.validateRequired(value, "Name"),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email',
              controller: _emailController,
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Password',
              controller: _passwordController,
              obscureText: true,
              validator: Validators.validatePassword,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: const InputDecoration(label: Text("Role")),
              items: const [
                DropdownMenuItem(value: 'manager', child: Text("Manager")),
                DropdownMenuItem(
                  value: 'supervisor',
                  child: Text("Supervisor"),
                ),
                DropdownMenuItem(value: 'qc', child: Text("QC")),
              ],
              onChanged: (value) => setState(() => _role = value!),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Create Account',
              icon: Icons.person_add,
              isLoading: loading,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthCubit>().signUp(
                    name: _nameController.text.trim(),
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                    role: _role,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

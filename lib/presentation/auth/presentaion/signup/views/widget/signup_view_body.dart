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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _role = 'manager';

  void handleSignup(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (name.isEmpty || email.isEmpty || password.isEmpty) return;

      context.read<AuthCubit>().signUp(
        role: _role,
        name: name,
        email: email,
        password: password,
      );
    }
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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _nameController,
                  label: 'Name',
                  validator: (value) =>
                      Validators.validateRequired(value, "Name"),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
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
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _role = value);
                    }
                  },
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Create Account',
                  icon: Icons.person_add,
                  isLoading: loading,
                  onPressed: () => handleSignup(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

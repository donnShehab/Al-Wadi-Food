import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/core/utils/validators.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/widgets/custom_button.dart';
import 'package:alwadi_food/presentation/widgets/custom_text_field.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SigninViewBody extends StatefulWidget {
  const SigninViewBody({super.key});

  @override
  State<SigninViewBody> createState() => _SigninViewBodyState();
}

class _SigninViewBodyState extends State<SigninViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscure = true;
  // handle Login use Cubit to signin
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      if (email.isEmpty || password.isEmpty) return;

      context.read<AuthCubit>().signIn(email: email, password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Icon(
                    Icons.ac_unit,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Welcome Back',
                    style: theme.textTheme.headlineMedium?.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Sign in to continue',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Email
                CustomTextField(
                  suffixIcon: Icon(
                    Icons.email,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  validator: Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Password
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  validator: Validators.validatePassword,
                  obscureText: _obscure,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () => setState(() {
                      _obscure = !_obscure;
                    }),
                  ),
                ),

                const SizedBox(height: 32),

                // Login Button
                CustomButton(
                  text: 'Sign In',
                  onPressed: _handleLogin,
                  icon: Icons.login,
                ),

                TextButton(
                  onPressed: () => context.push(AppRouter.KsignupView),
                  child: const Text("Create a new account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

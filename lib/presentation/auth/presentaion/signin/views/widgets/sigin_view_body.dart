import 'dart:ui' as ui;

import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/core/utils/validators.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/widgets/brand/alwadi_icon.dart';
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

class _SigninViewBodyState extends State<SigninViewBody>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ✅ KEEP EXACT (as old code)
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  // ✅ KEEP EXACT controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscure = true;


  // ✅ UI ONLY: entrance animation for title/card (no logic change)
  late final AnimationController _entranceController;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _cardOpacity;
  late final Animation<double> _titleSlide;
  late final Animation<double> _cardSlide;

  // ✅ KEEP EXACT logic
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      if (email.isEmpty || password.isEmpty) return;

      context.read<AuthCubit>().signIn(email: email, password: password);
    }
  }

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );

    _titleOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.00, 0.55, curve: Curves.easeOutCubic),
    );

    _cardOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.15, 1.00, curve: Curves.easeOutCubic),
    );

    _titleSlide = Tween<double>(begin: 10, end: 0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.00, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _cardSlide = Tween<double>(begin: 14, end: 0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 1.00, curve: Curves.easeOutCubic),
      ),
    );

    // Start entrance slightly after first frame (lets icon fall feel primary)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 140));
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {

    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Cinematic background (very subtle)
    final bg = BoxDecoration(
      gradient: RadialGradient(
        center: Alignment.topCenter,
        radius: 1.2,
        colors: [
          theme.colorScheme.surface,
          theme.colorScheme.primary.withOpacity(0.035),
        ],
      ),
    );

    return Scaffold(
      body: DecoratedBox(
        decoration: bg,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 42),

                  // ✅ KEEP EXACT: your planned falling icon
                  const Center(child: LoginFallingAlwadiIcon()),

                  const SizedBox(height: 18),

                  // Title + subtitle entrance (executive)
                  AnimatedBuilder(
                    animation: _entranceController,
                    builder: (context, _) {
                      return Opacity(
                        opacity: _titleOpacity.value,
                        child: Transform.translate(
                          offset: Offset(0, _titleSlide.value),
                          child: Column(
                            children: [
                              Text(
                                'Welcome Back',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sign in to continue',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withOpacity(0.72),
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

const SizedBox(height: 34),

                  // Executive card entrance
                  AnimatedBuilder(
                    animation: _entranceController,
                    builder: (context, _) {
                      return Opacity(
                        opacity: _cardOpacity.value,
                        child: Transform.translate(
                          offset: Offset(0, _cardSlide.value),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 520),                              child: _ExecutiveCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                   _FieldGlow(
                                      child: CustomTextField(
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
                                    ),
                              
                                    const SizedBox(height: AppSpacing.lg),
                              
                                   _FieldGlow(
                                      child: CustomTextField(
                                        controller: _passwordController,
                                        label: 'Password',
                                        hint: 'Enter your password',
                                        validator: Validators.validatePassword,
                                        obscureText: _obscure,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscure
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color:
                                                theme.colorScheme.onSurfaceVariant,
                                          ),
                                          onPressed: () => setState(() {
                                            _obscure = !_obscure;
                                          }),
                                        ),
                                      ),
                                    ),
                              
                              
                                    const SizedBox(height: 22),
                              
                                    // Button press micro interaction (executive)
                                    _PressScale(
                                      child: CustomButton(
                                        text: 'Sign In',
                                        onPressed: _handleLogin,
                                        icon: Icons.login,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 16),

                  Center(
                    child: TextButton.icon(
                      onPressed: () => context.push(AppRouter.KSignup),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary.withOpacity(
                          0.78,
                        ),
                        textStyle: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                      icon: Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 18,
                        color: theme.colorScheme.primary.withOpacity(0.78),
                      ),
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Create a new account"),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: theme.colorScheme.primary.withOpacity(0.78),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// =====================
///  Executive Card UI
/// =====================
/// UI-only: premium card style (radius, shadow, border).
class _ExecutiveCard extends StatelessWidget {
  const _ExecutiveCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final surface = theme.colorScheme.surface;
    final outline = theme.colorScheme.onSurface.withOpacity(0.06);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(surface, Colors.white, 0.10) ?? surface,
            surface,
          ],
        ),
        border: Border.all(color: outline, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
            spreadRadius: -6,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// =====================
///  Focus Glow Wrapper
/// =====================
/// UI-only: highlights active field without touching field logic.
class _FieldGlow extends StatefulWidget {
  const _FieldGlow({required this.child});

  final Widget child;

  @override
  State<_FieldGlow> createState() => _FieldGlowState();
}

class _FieldGlowState extends State<_FieldGlow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Focus(
      onFocusChange: (hasFocus) {
        if (!mounted) return;
        setState(() => _focused = hasFocus);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.14),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ]
              : const [],
        ),
        child: widget.child,
      ),
    );
  }
}


/// =====================
///  Press Scale Wrapper
/// =====================
/// UI-only: makes primary action feel premium.
class _PressScale extends StatefulWidget {
  const _PressScale({required this.child});

  final Widget child;

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        scale: _pressed ? 0.985 : 1.0,
        child: widget.child,
      ),
    );
  }
}

/// =====================
///  Login Falling Icon
/// =====================
/// KEEP AS-IS (your current logo + motion plan).
class LoginFallingAlwadiIcon extends StatefulWidget {
  const LoginFallingAlwadiIcon({super.key});

  @override
  State<LoginFallingAlwadiIcon> createState() => _LoginFallingAlwadiIconState();
}

class _LoginFallingAlwadiIconState extends State<LoginFallingAlwadiIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const int _durationMs = 700;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _durationMs),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final double progress = Curves.easeInOutCubic.transform(
          _controller.value,
        );

        final double offsetY =
            ui.lerpDouble(-size.height * 0.4, 0.0, progress) ?? 0.0;

        return Transform.translate(
          offset: Offset(0, offsetY),
          child: const AlwadiIcon(), // same icon, unchanged
        );
      },
    );
  }
}

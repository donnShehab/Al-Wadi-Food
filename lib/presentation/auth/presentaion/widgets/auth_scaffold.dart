import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.heroLogo,
    required this.title,
    required this.subtitle,
    required this.card,
    this.footer,
    this.maxWidth = 520,
  });

  final Widget heroLogo;
  final String title;
  final String subtitle;
  final Widget card;
  final Widget? footer;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.25,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primary.withOpacity(0.035),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth >= 600
                  ? AppSpacing.xxl
                  : AppSpacing.lg;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: AppSpacing.lg,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 18),

                        // Brand header zone (continuation of Splash)
                        Center(child: heroLogo),
                        const SizedBox(height: 16),

                        Center(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withOpacity(0.72),
                              height: 1.25,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Executive card zone
                        card,

                        if (footer != null) ...[
                          const SizedBox(height: 14),
                          Center(child: footer!),
                        ],

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

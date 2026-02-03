import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeHeader extends StatelessWidget {
  final UserEntity user;
  const HomeHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final roleBg = theme.colorScheme.primary.withOpacity(0.10);
    final roleBorder = theme.colorScheme.primary.withOpacity(0.22);
    final roleFg = theme.colorScheme.primary.withOpacity(0.90);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Name + Role
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${user.name}',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: roleBg,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: roleBorder, width: 1),
              ),
              child: Text(
                user.role.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: roleFg,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),

        /// Actions (settings + logout) — logic unchanged
        Row(
          children: [
            _HeaderActionButton(
              tooltip: 'Settings',
              icon: Icons.settings,
              foreground: theme.colorScheme.primary,
              onPressed: () => context.push(AppRouter.KsettingsView),
            ),
            const SizedBox(width: 10),
            _HeaderActionButton(
              tooltip: 'Sign out',
              icon: Icons.logout,
              foreground: theme.colorScheme.error,
              onPressed: () {
                context.read<AuthCubit>().signOut();
                context.go(AppRouter.KloginView);
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// UI-only: executive icon button (soft surface + micro press).
class _HeaderActionButton extends StatefulWidget {
  const _HeaderActionButton({
    required this.tooltip,
    required this.icon,
    required this.foreground,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  State<_HeaderActionButton> createState() => _HeaderActionButtonState();
}

class _HeaderActionButtonState extends State<_HeaderActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bg = theme.colorScheme.surface;
    final border = theme.colorScheme.onSurface.withOpacity(0.08);

    return Tooltip(
      message: widget.tooltip,
      child: Listener(
        onPointerDown: (_) => setState(() => _pressed = true),
        onPointerUp: (_) => setState(() => _pressed = false),
        onPointerCancel: (_) => setState(() => _pressed = false),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          scale: _pressed ? 0.96 : 1.0,
          child: Material(
            color: bg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: border, width: 1),
            ),
            elevation: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: widget.onPressed,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(widget.icon, color: widget.foreground, size: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

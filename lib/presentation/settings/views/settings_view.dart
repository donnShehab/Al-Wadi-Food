import 'package:alwadi_food/core/localization/app_localizations.dart';
import 'package:alwadi_food/presentation/settings/cubit/app_settings_cubit.dart';
import 'package:alwadi_food/presentation/settings/cubit/app_settings_state.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings, style: theme.textTheme.titleLarge?.semiBold),
        centerTitle: true,
      ),
      body: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          return Padding(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionCard(
                  title: t.theme,
                  child: SegmentedButton<ThemeMode>(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                    ),
                    segments: <ButtonSegment<ThemeMode>>[
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text(t.system),
                        icon: const Icon(Icons.auto_mode),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text(t.light),
                        icon: const Icon(Icons.light_mode),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text(t.dark),
                        icon: const Icon(Icons.dark_mode),
                      ),
                    ],
                    selected: {state.themeMode},
                    onSelectionChanged: (selection) {
                      final selected = selection.first;
                      context.read<AppSettingsCubit>().updateThemeMode(
                        selected,
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionCard(
                  title: t.language,
                  child: SegmentedButton<String>(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                    ),
                    segments: <ButtonSegment<String>>[
                      ButtonSegment(
                        value: 'en',
                        label: Text(t.english),
                        icon: const Icon(Icons.language),
                      ),
                      ButtonSegment(
                        value: 'es',
                        label: Text(t.spanish),
                        icon: const Icon(Icons.translate),
                      ),
                    ],
                    selected: {state.locale.languageCode},
                    onSelectionChanged: (selection) {
                      final lang = selection.first;
                      context.read<AppSettingsCubit>().updateLocale(
                        Locale(lang),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(title, style: theme.textTheme.titleMedium?.semiBold),
          ),
          child,
        ],
      ),
    );
  }
}

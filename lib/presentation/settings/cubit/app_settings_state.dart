import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final bool loading;

  const AppSettingsState({
    required this.themeMode,
    required this.locale,
    this.loading = false,
  });

  AppSettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? loading,
  }) {
    return AppSettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale, loading];
}

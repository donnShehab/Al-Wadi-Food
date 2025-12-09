import 'package:alwadi_food/core/services/preferences_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_settings_state.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  final PreferencesService _prefs;
  AppSettingsCubit(this._prefs)
      : super(AppSettingsState(themeMode: ThemeMode.system, locale: const Locale('en'), loading: true));

  Future<void> load() async {
    try {
      await _prefs.init();
      final themeMode = _prefs.getThemeMode();
      final locale = _prefs.getLocale(fallback: const Locale('en'));
      emit(state.copyWith(themeMode: themeMode, locale: locale, loading: false));
    } catch (e) {
      debugPrint('AppSettingsCubit.load error: $e');
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));
    await _prefs.setThemeMode(mode);
  }

  Future<void> updateLocale(Locale locale) async {
    emit(state.copyWith(locale: locale));
    await _prefs.setLocale(locale);
  }
}

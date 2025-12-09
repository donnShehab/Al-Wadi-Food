import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A tiny wrapper around SharedPreferences to persist app settings locally.
/// Stores theme mode and language (localeCode).
class PreferencesService {
  static const _keyThemeMode = 'prefs_theme_mode';
  static const _keyLocaleCode = 'prefs_locale_code';

  SharedPreferences? _prefs;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('PreferencesService.init error: $e');
    }
  }

  ThemeMode getThemeMode() {
    try {
      final raw = _prefs?.getString(_keyThemeMode);
      switch (raw) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        case 'system':
        default:
          return ThemeMode.system;
      }
    } catch (e) {
      debugPrint('PreferencesService.getThemeMode error: $e');
      return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      await _prefs?.setString(_keyThemeMode, switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        _ => 'system',
      });
    } catch (e) {
      debugPrint('PreferencesService.setThemeMode error: $e');
    }
  }

  Locale getLocale({Locale fallback = const Locale('en')}) {
    try {
      final code = _prefs?.getString(_keyLocaleCode);
      if (code == null || code.isEmpty) return fallback;
      // Support languageCode[-countryCode]
      final parts = code.split('-');
      if (parts.length == 2) return Locale(parts[0], parts[1]);
      return Locale(parts[0]);
    } catch (e) {
      debugPrint('PreferencesService.getLocale error: $e');
      return fallback;
    }
  }

  Future<void> setLocale(Locale locale) async {
    try {
      final code = [
        locale.languageCode,
        if (locale.countryCode?.isNotEmpty == true) locale.countryCode,
      ].join('-');
      await _prefs?.setString(_keyLocaleCode, code);
    } catch (e) {
      debugPrint('PreferencesService.setLocale error: $e');
    }
  }
}

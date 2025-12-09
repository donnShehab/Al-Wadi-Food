import 'package:flutter/material.dart';

/// Minimal, manual localization to avoid build-time codegen.
/// Extend as needed by adding keys per screen.
class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const supportedLocales = [Locale('en'), Locale('es')];

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'appTitle': 'IceBox Factory Manager',
      'settings': 'Settings',
      'theme': 'Theme',
      'system': 'System',
      'light': 'Light',
      'dark': 'Dark',
      'language': 'Language',
      'english': 'English',
      'spanish': 'Español',
    },
    'es': {
      'appTitle': 'Gestor de Fábrica IceBox',
      'settings': 'Ajustes',
      'theme': 'Tema',
      'system': 'Sistema',
      'light': 'Claro',
      'dark': 'Oscuro',
      'language': 'Idioma',
      'english': 'Inglés',
      'spanish': 'Español',
    },
  };

  String _t(String key) =>
      _localizedValues[locale.languageCode]?[key] ??
      _localizedValues['en']![key] ??
      key;

  String get appTitle => _t('appTitle');
  String get settings => _t('settings');
  String get theme => _t('theme');
  String get system => _t('system');
  String get light => _t('light');
  String get dark => _t('dark');
  String get language => _t('language');
  String get english => _t('english');
  String get spanish => _t('spanish');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

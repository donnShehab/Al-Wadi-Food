// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Skip`
  String get skipButton {
    return Intl.message('Skip', name: 'skipButton', desc: '', args: []);
  }

  /// `Next`
  String get nextButton {
    return Intl.message('Next', name: 'nextButton', desc: '', args: []);
  }

  /// `Get Started`
  String get getStartedButton {
    return Intl.message(
      'Get Started',
      name: 'getStartedButton',
      desc: '',
      args: [],
    );
  }

  /// `Fastest Delivery`
  String get onboarding1Title {
    return Intl.message(
      'Fastest Delivery',
      name: 'onboarding1Title',
      desc: '',
      args: [],
    );
  }

  /// `Select your chilled and frozen products easily, and receive your order fresh and fast.`
  String get onboarding1Description {
    return Intl.message(
      'Select your chilled and frozen products easily, and receive your order fresh and fast.',
      name: 'onboarding1Description',
      desc: '',
      args: [],
    );
  }

  /// `Unforgettable Quality & Flavor`
  String get onboarding2Title {
    return Intl.message(
      'Unforgettable Quality & Flavor',
      name: 'onboarding2Title',
      desc: '',
      args: [],
    );
  }

  /// `Meat, poultry, canned goods, and cold products carefully selected to ensure the best taste for your family.`
  String get onboarding2Description {
    return Intl.message(
      'Meat, poultry, canned goods, and cold products carefully selected to ensure the best taste for your family.',
      name: 'onboarding2Description',
      desc: '',
      args: [],
    );
  }

  /// `Our Offers Never End!`
  String get onboarding3Title {
    return Intl.message(
      'Our Offers Never End!',
      name: 'onboarding3Title',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy exclusive discounts and weekly saving offers designed specifically for you and your family.`
  String get onboarding3Description {
    return Intl.message(
      'Enjoy exclusive discounts and weekly saving offers designed specifically for you and your family.',
      name: 'onboarding3Description',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

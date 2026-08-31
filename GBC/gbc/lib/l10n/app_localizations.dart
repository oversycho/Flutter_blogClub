import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [Locale('en'), Locale('fa')];

  // Add new keys here as new screens need them — both languages together
  // so nothing gets left half-translated.
  static const Map<String, Map<String, String>> _values = {
    'en': {
      'home': 'Home',
      'add_post': 'Add Post',
      'profile': 'Profile',
      'settings': 'Settings',
      'appearance': 'Appearance',
      'language': 'Language',
      'theme_light': 'Light',
      'theme_dark': 'Dark',
      'theme_system': 'System',
      'log_out': 'Log out',
      'log_in': 'Log in',
    },
    'fa': {
      'home': 'خانه',
      'add_post': 'ایجاد پست',
      'profile': 'پروفایل',
      'settings': 'تنظیمات',
      'appearance': 'ظاهر',
      'language': 'زبان',
      'theme_light': 'روشن',
      'theme_dark': 'تیره',
      'theme_system': 'سیستم',
      'log_out': 'خروج از حساب',
      'log_in': 'ورود',
    },
  };

  /// Usage: AppLocalizations.of(context).t('home')
  String t(String key) {
    return _values[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales
          .map((l) => l.languageCode)
          .contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

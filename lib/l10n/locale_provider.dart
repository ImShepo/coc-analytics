import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeStorageKey = 'app_locale';

const supportedAppLocales = [
  Locale('es'),
  Locale('en'),
  Locale('pt'),
  Locale('fr'),
  Locale('it'),
];

final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((ref) => LocaleNotifier());

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('es')) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeStorageKey);
    if (code == null) return;

    final saved = Locale(code);
    if (supportedAppLocales.any((l) => l.languageCode == saved.languageCode)) {
      state = saved;
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedAppLocales
        .any((l) => l.languageCode == locale.languageCode)) {
      return;
    }
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeStorageKey, locale.languageCode);
  }
}

String localeDisplayName(Locale locale, String Function(String key) tr) {
  return switch (locale.languageCode) {
    'es' => tr('languageEs'),
    'en' => tr('languageEn'),
    'pt' => tr('languagePt'),
    'fr' => tr('languageFr'),
    'it' => tr('languageIt'),
    _ => locale.languageCode.toUpperCase(),
  };
}

String localeFlagEmoji(Locale locale) {
  return switch (locale.languageCode) {
    'es' => '🇪🇸',
    'en' => '🇬🇧',
    'pt' => '🇧🇷',
    'fr' => '🇫🇷',
    'it' => '🇮🇹',
    _ => '🌐',
  };
}

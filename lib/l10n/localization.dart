import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'messages_all_locales.dart';
import 'package:untitled/l10n/messages_all.dart';
import 'package:untitled/l10n/messages_all_locales.dart';
import 'package:untitled/l10n/messages_en.dart'; // For English
import 'package:untitled/l10n/messages_ar.dart'; // For Arabic


class AppLocalizations {
  AppLocalizations(Locale locale) : _localeName = Intl.canonicalizedLocale(locale.toString());

  final String _localeName;

  static Future<AppLocalizations> load(Locale locale) async {
    final String localeName = Intl.canonicalizedLocale(locale.toString());
    await initializeMessages(localeName);
    return AppLocalizations(locale);
  }

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  // Add your localized strings here
  String get helloWorld => Intl.message('Hello, World!', name: 'helloWorld');
// Add other localized strings...

// The rest of your AppLocalizations class...
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {

  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/l10n/translations.g.dart'
    show AppLocaleUtils, LocaleSettings, ExtAppLocale;
import 'package:sembast/sembast.dart';

import '../app/db_keys.dart';
import '../app/local_db.dart';
import '../l10n/translations.g.dart' show AppLocaleUtils, LocaleSettings;
import 'helper_functions.dart';

class LocaleManager {
  static Future<Locale> getSavedLocaleCode() async {
    var store = StoreRef.main();
    final futureLocale = await LocaleSettings.useDeviceLocale();
    final deviceLocale = futureLocale.flutterLocale;
    try {
      // Get stored images
      final storedLocal = await store
          .record(DbKeys.appLocal)
          .get(await LocalDB.db) as Map<String, dynamic>?;
      if (storedLocal == null) {
        print('stored locale is null $deviceLocale');
        return deviceLocale;
      }
      print(
          'stored locale is not null ${LocaleMapExtension.fromMap(storedLocal)}');

      return LocaleMapExtension.fromMap(storedLocal) ?? deviceLocale;
    } catch (e) {
      return deviceLocale;
    }
  }

  static final appLocaleProvider = FutureProvider<Locale>((ref) async {
    var store = StoreRef.main();
    final futureLocale = await LocaleSettings.useDeviceLocale();
    final deviceLocale = futureLocale.flutterLocale;
    try {
      // Get stored images
      final storedLocal = await store
          .record(DbKeys.appLocal)
          .get(await LocalDB.db) as Map<String, dynamic>?;
      if (storedLocal == null) return deviceLocale;
      return LocaleMapExtension.fromMap(storedLocal) ?? deviceLocale;
    } catch (e) {
      return deviceLocale;
    }
  });
  static final changeAppLocale = FutureProviderFamily<Locale, Locale>(
    (ref, arg) async {
      var store = StoreRef.main();
      Locale deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;

      try {
        // Get stored images
        final storedLocal = await store
            .record(DbKeys.appLocal)
            .put(await LocalDB.db, arg.toMap())
            .then(
          (value) async {
            await LocaleSettings.setLocaleRaw(arg.toLanguageTag());

            print('language updated $value');
          },
        ) as Map<String, dynamic>?;
        if (storedLocal == null) return arg;
        return LocaleMapExtension.fromMap(storedLocal) ?? deviceLocale;
      } catch (e) {
        return deviceLocale;
      }
    },
  );
}

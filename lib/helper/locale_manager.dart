import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/l10n/translations.g.dart'
    show LocaleSettings, ExtAppLocale, AppLocale;
import 'package:sembast/sembast.dart';

import '../app/db_keys.dart';
import '../app/local_db.dart';
import 'helper_functions.dart';

class LocaleManager {
  static Future<Locale> changeAppLocaleFunc(Locale arg) async {
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
          await LocaleSettings.setLocale(
              arg.languageCode == 'ar' ? AppLocale.ar : AppLocale.en);
        },
      ) as Map<String, dynamic>?;
      if (storedLocal == null) return arg;
      return LocaleMapExtension.fromMap(storedLocal) ?? deviceLocale;
    } catch (e) {
      return deviceLocale;
    }
  }

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
        return deviceLocale;
      }

      return LocaleMapExtension.fromMap(storedLocal) ?? deviceLocale;
    } catch (e) {
      return deviceLocale;
    }
  }

  static final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
    (ref) => LocaleNotifier(),
  );
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
            await LocaleSettings.setLocale(
                arg.languageCode == 'ar' ? AppLocale.ar : AppLocale.en);
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

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadInitialLocale();
  }

  Future<void> _loadInitialLocale() async {
    var store = StoreRef.main();
    final futureLocale = await LocaleSettings.useDeviceLocale();
    final deviceLocale = futureLocale.flutterLocale;
    try {
      final storedLocal = await store
          .record(DbKeys.appLocal)
          .get(await LocalDB.db) as Map<String, dynamic>?;
      final parsed = LocaleMapExtension.fromMap(storedLocal ?? {});
      state = parsed ?? deviceLocale;
      await LocaleSettings.setLocaleRaw(state.toLanguageTag());
    } catch (e) {
      state = deviceLocale;
      await LocaleSettings.setLocale(AppLocale.en); // fallback
    }
  }

  Future<void> updateLocale(Locale newLocale) async {
    // Store
    var store = StoreRef.main();
    await store
        .record(DbKeys.appLocal)
        .put(await LocalDB.db, newLocale.toMap());

    // Set Flutter's locale state
    await LocaleSettings.setLocaleRaw(newLocale.toLanguageTag());
    await LocaleSettings.setLocale(
      newLocale.languageCode == 'ar' ? AppLocale.ar : AppLocale.en,
    );

    // Update app state
    state = newLocale;
  }
}

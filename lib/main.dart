import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/helper/locale_manager.dart';
import 'app/app_router.dart';
import 'core/consts.dart';
import 'l10n/translations.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: './key.env');

  final savedLangCode = await LocaleManager.getSavedLocaleCode();
  final locale = AppLocale.values.firstWhere(
    (e) => e.languageCode == savedLangCode.languageCode,
    orElse: () => AppLocale.en,
  );
  await LocaleSettings.setLocale(locale);

  runApp(
    ProviderScope(
      child: MyApp(), // no longer wrapped with TranslationProvider here
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = AppRouter(ref);
    final currentLocale = ref.watch(LocaleManager.localeProvider);
    return TranslationProvider(
      // 👈 wrap here, so it rebuilds when locale changes
      child: MaterialApp.router(
        title: 'Glower',
        routerConfig: appRouter.config(),
        supportedLocales: Consts.supportedLocale,
        locale: currentLocale,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        theme: _buildTheme(),
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: const Color(0xff4C7B8B),
        onPrimary: Colors.white,
        secondary: const Color(0xfffff9f0),
        onSecondary: const Color(0xff4C7B8B),
        primaryContainer: const Color(0xff6E9CA7),
        onPrimaryContainer: const Color(0xff102B33),
        secondaryContainer: const Color(0xfffff0dd),
        onSecondaryContainer: const Color(0xff3A545B),
        surface: const Color(0xfffdfdfd),
        onSurface: const Color(0xff1C2B2F),
        error: const Color(0xffD32F2F),
        onError: Colors.white,
      ),
      fontFamily: 'Roboto',
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: const Color(0xff282828).withAlpha(60)),
        hintStyle: TextStyle(color: const Color(0xff323a3f).withAlpha(180)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff4C7B8B), width: 0.5),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: const Color(0xff282828).withAlpha(128), width: 0.4),
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    );
  }
}

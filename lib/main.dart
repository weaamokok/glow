import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:glow/core/app_exception_handler.dart';
import 'package:glow/helper/locale_manager.dart';
import 'package:glow/resources/resources.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upgrader/upgrader.dart';
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
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // Optional: Log or report the error
    debugPrint('Flutter ErrorWidget: ${details.exceptionAsString()}');

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Images.error),
            SizedBox(height: 10),
            Text(
              'Oops! Something went wrong.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              AppExceptionHandler.getMessage(details.exceptionAsString()),
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  };

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = AppRouter(ref);
    final currentLocale = ref.watch(LocaleManager.localeProvider);
    return TranslationProvider(
      // 👈 wrap here, so it rebuilds when locale changes
      child: MaterialApp.router(
        title: 'Glower',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.config(),
        supportedLocales: Consts.supportedLocale,
        locale: currentLocale,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        theme: _buildTheme(),
        builder: (context, child) => UpgradeAlert(child: child),
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
        surface: const Color(0xffFBFAF6),
        onSurface: const Color(0xff1C2B2F),
        error: const Color(0xffD32F2F),
        onError: Colors.white,
      ),
      fontFamily: 'Roboto',

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(0),
          backgroundColor: WidgetStatePropertyAll(Color(0xff73B79B)),
          foregroundColor: WidgetStatePropertyAll(Colors.white),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(15),
              side: BorderSide(color: Color(0xff282828)),
            ),
          ),
        ),
      ),
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
            color: const Color(0xff282828).withAlpha(128),
            width: 0.4,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
      ),
    );
  }
}

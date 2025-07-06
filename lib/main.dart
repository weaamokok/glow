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

  await dotenv.load(
    fileName: './key.env',
  );
  // Load saved locale code from LocaleManager
  final savedLangCode = await LocaleManager.getSavedLocaleCode();

  // Set slang locale globally BEFORE runApp

  final locale = AppLocale.values.firstWhere(
    (e) => e.languageCode == savedLangCode.languageCode,
    orElse: () => AppLocale.en,
  );
  await LocaleSettings.setLocale(locale);

  runApp(ProviderScope(child: TranslationProvider(child: MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appRouter = AppRouter(ref);
    final asyncLocale = ref.watch(LocaleManager.appLocaleProvider);

    print('current locale $asyncLocale');
    MaterialApp getApp({Locale? locale}) {
      return MaterialApp.router(
        title: 'Glowr',
        routerConfig: appRouter.config(),
        supportedLocales: Consts.supportedLocale,
        locale: locale,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        theme: ThemeData(
            colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: Color(0xff4C7B8B),
              // Deep teal-blue
              onPrimary: Colors.white,
              // For text/icons on primary

              secondary: Color(0xfffff9f0),
              // Soft cream
              onSecondary: Color(0xff4C7B8B),
              // Contrast text/icons on secondary

              primaryContainer: Color(0xff6E9CA7),
              // Lighter shade of primary
              onPrimaryContainer: Color(0xff102B33),

              secondaryContainer: Color(0xfffff0dd),
              // Slightly darker than secondary
              onSecondaryContainer: Color(0xff3A545B),
              // Dark text for readability

              surface: Color(0xfffdfdfd),
              // Soft white surface
              onSurface: Color(0xff1C2B2F),
              // Text/icons on surface

              error: Color(0xffD32F2F),
              // Standard material red
              onError: Colors.white, // White text on error color
            ),
            fontFamily: 'Roboto',
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: Color(0xff282828).withAlpha(60)),
              hintStyle:
                  TextStyle(color: Color(0xff323a3f).withValues(alpha: .7)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff4C7B8B), width: 0.5),
                borderRadius: BorderRadius.circular(12.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color(0xff282828).withValues(alpha: .5), width: 0.4),
                borderRadius: BorderRadius.circular(12.0),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ///////-////////
              // contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              // focusedBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(
              //     color: Color(0xff282828).withAlpha(40),
              //   ),
              // ),
              // enabledBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(
              //     color: Color(0xff282828).withAlpha(40),
              //   ),
              // )
              ///////////-/./////
              // focusedBorder: OutlineInputBorder(
              //     borderSide:
              //         BorderSide(color: Color(0xff4C7B8B).withValues(alpha: .7)),
              //     borderRadius: BorderRadius.circular(12)),
              // enabledBorder: OutlineInputBorder(
              //     borderSide:
              //         BorderSide(color: Color(0xff4C7B8B).withValues(alpha: .7)),
              //     borderRadius: BorderRadius.circular(12)),
            )),
      );
    }

    return asyncLocale.whenOrNull(data: (data) => getApp(locale: data)) ??
        getApp();
  }
}

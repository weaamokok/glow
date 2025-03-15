import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app_router.dart';

void main() async {
  await dotenv.load(
    fileName: './key.env',
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appRouter = AppRouter(ref);
    return MaterialApp.router(
      title: 'Glow',
      routerConfig: appRouter.config(),
      theme: ThemeData(
          colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: Color(0xff4C7B8B),
              onPrimary: Color(0xff282828),
              secondary: Color(0xff4C7B8B),
              onSecondary: Colors.white,
              error: Color(0xD5A80A0A),
              onError: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xff282828)),
          fontFamily: 'Tajawal',
          inputDecorationTheme: InputDecorationTheme(
              hintStyle:
                  TextStyle(color: Color(0xff4C7B8B).withValues(alpha: .7)),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0xff4C7B8B).withValues(alpha: .7)),
                  borderRadius: BorderRadius.circular(12)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0xff4C7B8B).withValues(alpha: .7)),
                  borderRadius: BorderRadius.circular(12)))),
    );
  }
}

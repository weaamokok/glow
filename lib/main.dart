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
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
}

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
      theme: ThemeData(fontFamily: 'Tajawal'),
    );
  }
}

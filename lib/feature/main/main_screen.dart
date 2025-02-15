import 'package:auto_route/auto_route.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/feature/prompt_creator/prompt_creator_stepper_screen.dart';

import 'main_deps.dart';

@RoutePage()
class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final indexBottomNavbar = ref.watch(indexBottomNavbarProvider);
final isFirestRun= ref.read(isFirstRunProvider).then((value) {
  showBottomSheet(context: context, builder: (context) {
    return PromptCreatorStepperScreen();
  },);
},);
    return  Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexBottomNavbar,
          onTap: (value) => ref
              .read(indexBottomNavbarProvider.notifier)
              .update((state) => value),
        items: const [
          BottomNavigationBarItem(icon: Icon(EneftyIcons.home_2_outline), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(EneftyIcons.calendar_2_outline), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(EneftyIcons.user_outline), label: 'Setting'),
        ],
      ),
      body: Screens[indexBottomNavbar],
    );
  }
}
final Screens = [
  const Center(
    child: Text('Hello From Home Screen'),
  ),
  const Center(
    child: Text('Hello From Favorite Screen'),
  ),
  const Center(
    child: Text('Hello From Settings Screen'),
  ),
];
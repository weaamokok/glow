import 'package:auto_route/auto_route.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/feature/calendar/calendar_screen.dart';
import 'package:glow/feature/home/home_screen.dart';

import 'main_deps.dart';

@RoutePage()
class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final indexBottomNavbar = ref.watch(indexBottomNavbarProvider);

    return Scaffold(
      backgroundColor: Color(0xfff6f5f5),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: indexBottomNavbar,
        selectedItemColor: Color(0xffEFB036),
        onTap: (value) => ref
            .read(indexBottomNavbarProvider.notifier)
            .update((state) => value),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(EneftyIcons.home_2_outline), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(EneftyIcons.calendar_2_outline), label: 'schedule'),
          BottomNavigationBarItem(
              icon: Icon(EneftyIcons.user_outline), label: 'Setting'),
        ],
      ),
      body: screens[indexBottomNavbar],
    );
  }
}

final screens = [
  const HomeScreen(),
  const CalendarScreen(),
  const Center(
    child: Text('Hello From Settings Screen'),
  ),
];

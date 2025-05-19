import 'package:auto_route/auto_route.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/feature/calendar/calendar_screen.dart';
import 'package:glow/feature/home/home_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../home/home_deps.dart';
import 'main_deps.dart';

@RoutePage()
class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final indexBottomNavbar = ref.watch(indexBottomNavbarProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
              margin: EdgeInsetsDirectional.only(end: 18),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Color(0xff282828), width: 1.5)),
              child: Icon(
                Icons.add,
                weight: 2,
              ))
        ],
        title: Padding(
          padding: const EdgeInsetsDirectional.only(start: 4.0),
          child: Text(
            'Glowr',
            style: TextStyle(fontFamily: 'Lilita', fontSize: 28),
          ),
        ),
        bottom: indexBottomNavbar == 0
            ? PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: 22),
                  child: GlowBubble(
                    text: ref.read(HomeDeps.greetingProvider),
                    label: DateFormat.MMMMEEEEd().format(DateTime.now()),
                  ),
                ))
            : null,
      ),
      bottomNavigationBar: BottomNavBar(indexBottomNavbar: indexBottomNavbar),
      bottomSheet: indexBottomNavbar == 0
          ? AnimatedContainer(
              curve: Curves.easeInToLinear,
              duration: kThemeAnimationDuration,
              transformAlignment: AlignmentDirectional.bottomCenter,
              padding: EdgeInsets.only(left: 30, right: 30, top: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                  border: Border(
                      right: BorderSide(color: Color(0xff282828)),
                      top: BorderSide(color: Color(0xff282828)),
                      left: BorderSide(color: Color(0xff282828)))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 2,
                          children: [
                            Text(
                              '40%',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'of your schedule is done, Keep going..✨ ',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    //make progress bar dynamic
                    width: double.infinity, // Outer container takes full width
                    height: 30, // Fixed height for the progress bar track
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff282828)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FractionallySizedBox(
                      alignment: AlignmentDirectional.centerStart,
                      // Start progress from the left
                      widthFactor: 0.5,
                      // Replace `0.5` with your progress value (e.g., 0.7 for 70%)
                      child: Container(
                        margin: const EdgeInsets.all(4), // Inner margin
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xff282828)),
                          color: Color(0xffA2D7D8), // Progress bar color
                          borderRadius: BorderRadius.circular(
                              16), // Slightly smaller radius than outer
                        ),
                        height:
                            28, // Inner height: outer height (36) - margin (4*2) = 28
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          : null,
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

class GlowBubble extends StatelessWidget {
  const GlowBubble(
      {required this.text, this.label, this.backgroundColor, super.key});

  final String? label;
  final String text;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: backgroundColor ?? Color(0xffB399D4),
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(15),
              bottomStart: Radius.circular(15),
              topEnd: Radius.circular(15),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label ?? '',
              style: TextStyle(color: Colors.white.withValues(alpha: .67)),
            ),
            Text(text,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

List<DotNavigationBarItem> _items = [
  DotNavigationBarItem(
    icon: const Icon(EneftyIcons.home_2_outline),
    // selectedColor: Colors.black,
  ),
  DotNavigationBarItem(
    icon: const Icon(EneftyIcons.calendar_2_outline),
    // selectedColor: Colors.black,
  ),
  DotNavigationBarItem(
    icon: const Icon(EneftyIcons.user_outline),
    // selectedColor: Colors.black,
  ),
];

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key, required this.indexBottomNavbar});

  final int indexBottomNavbar;

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: indexBottomNavbar == 0
              ? Border(
                  right: BorderSide(color: Color(0xff282828)),
                  left: BorderSide(color: Color(0xff282828)))
              : null),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Color(0xff282828)),
            borderRadius: BorderRadius.circular(
              40,
            )),
        margin: const EdgeInsets.only(
          bottom: 20,
        ),
        height: 60,
        child: DotNavigationBar(
          // splashColor: Colors.black,
          unselectedItemColor:
              Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
          selectedItemColor:
              Theme.of(context).bottomNavigationBarTheme.selectedItemColor,

          backgroundColor: Colors.transparent,
          borderRadius: 30,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          paddingR: const EdgeInsets.only(bottom: 0, top: 0),
          itemPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          enableFloatingNavBar: false,
          marginR: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          currentIndex: indexBottomNavbar,
          onTap: (value) => ref
              .read(indexBottomNavbarProvider.notifier)
              .update((state) => value),
          dotIndicatorColor: Color(0xffEFB036),
          items: _items,
        ),
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/feature/calendar/calendar_screen.dart';
import 'package:glow/feature/home/home_screen.dart';
import 'package:glow/feature/main/widget/glow_progress_widget.dart';
import 'package:glow/feature/main/widget/weather_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../home/home_deps.dart';
import '../home/update_action_bottom_sheet.dart';
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
              child: InkWell(
                child: Icon(
                  Icons.add,
                  weight: 2,
                ),
                onTap: () =>
                    showModalBottomSheet(
                        context: context,

                        builder: (context) => UpdateActionBottomSheet()),
              ))
        ],
        title: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 4.0,
          ),
          child: Text(
            'Glowr',
            style: TextStyle(fontFamily: 'Lilita', fontSize: 28),
          ),
        ),
        bottom: indexBottomNavbar == 0
            ? PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 22, end: 14),
              child: GlowBubble(
                text: ref.read(HomeDeps.greetingProvider),
                label: DateFormat.MMMMEEEEd().format(DateTime.now()),
              ),
            ))
            : null,
      ),
      bottomNavigationBar: BottomNavBar(indexBottomNavbar: indexBottomNavbar),
      bottomSheet: indexBottomNavbar == 0 ? GlowProgressWidget() : null,
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
            border: Border.all(),
            color: backgroundColor ?? Color(0xffB399D4),
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(15),
              bottomStart: Radius.circular(15),
              topEnd: Radius.circular(15),
            )),
        child: Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label ?? '',
                    style:
                    TextStyle(color: Colors.white.withValues(alpha: .67)),
                  ),
                  Text(text,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: VerticalDivider(
                color: Colors.white.withAlpha(80),
              ),
            ),
            Flexible(child: WeatherSummaryWidget())
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
          Theme
              .of(context)
              .bottomNavigationBarTheme
              .unselectedItemColor,
          selectedItemColor:
          Theme
              .of(context)
              .bottomNavigationBarTheme
              .selectedItemColor,
          backgroundColor: Colors.transparent,
          borderRadius: 30,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          paddingR: const EdgeInsets.only(bottom: 0, top: 0),
          itemPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          enableFloatingNavBar: false,
          marginR: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          currentIndex: indexBottomNavbar,
          onTap: (value) =>
              ref
                  .read(indexBottomNavbarProvider.notifier)
                  .update((state) => value),
          dotIndicatorColor: Color(0xffEFB036),
          items: _items,
        ),
      ),
    );
  }
}

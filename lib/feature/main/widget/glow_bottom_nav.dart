import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

import '../../calendar/calendar_screen.dart';
import '../../home/home_screen.dart';
import '../../profile/profile_screen.dart';
import '../main_deps.dart';
import 'glow_progress_widget.dart';

class GlowBottomNavBar extends ConsumerWidget {
  const GlowBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexBottomNavbar = ref.watch(indexBottomNavbarProvider);

    return BottomBar(
      hideOnScroll: true,
      scrollOpposite: false,
      icon: (width, height) => const Icon(
        EneftyIcons.arrow_up_3_outline,
        color: Color(0xff4C7B8B),
      ),
      barAlignment: Alignment.bottomCenter,
      respectSafeArea: true,
      fit: StackFit.expand,
      barColor: Colors.transparent,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (indexBottomNavbar == 0) GlowProgressWidget(),
          Stack(
            children: [
              if (indexBottomNavbar == 0)
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                        vertical: BorderSide(color: const Color(0xff282828))),
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xff282828)),
                  borderRadius: BorderRadius.circular(50),
                ),
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_navIcons.length, (index) {
                    final isSelected = index == indexBottomNavbar;
                    return GestureDetector(
                      onTap: () => ref
                          .read(indexBottomNavbarProvider.notifier)
                          .update((_) => index),
                      child: Icon(
                        _navIcons[index],
                        color: isSelected
                            ? const Color(0xff4C7B8B)
                            : Colors.grey.withAlpha(99),
                        size: 24,
                      ),
                    );
                  }),
                ),
              ),
            ],
          )
        ],
      ),
      body: (context, controller) =>
          _buildScreen(indexBottomNavbar, controller),
    );
  }
}

final List<IconData> _navIcons = [
  EneftyIcons.home_2_outline,
  EneftyIcons.calendar_2_outline,
  EneftyIcons.user_outline,
];

Widget _buildScreen(int index, ScrollController controller) {
  switch (index) {
    case 0:
      return HomeScreen(controller: controller);
    case 1:
      return CalendarScreen(controller: controller);
    case 2:
      return ProfileScreen(controller: controller);
    default:
      return const SizedBox.shrink();
  }
}

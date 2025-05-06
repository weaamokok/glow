import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:glow/domain/glow.dart';
import 'package:glow/feature/home/home_deps.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../helper/helper_functions.dart';
import '../calendar/calendar_deps.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(CalendarDeps.scheduleProvider);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: Color(0xffB399D4),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Text(
                'GLOWR',
                style: TextStyle(fontFamily: 'Lilita', fontSize: 25),
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat.MMMMEEEEd().format(DateTime.now())),
                    Text(ref.read(HomeDeps.greetingProvider)),
                  ],
                )
              ],
            ),
            FutureBuilder(
              future: ref.watch(CalendarDeps.scheduleProvider),
              builder: (context, snapshot) {
                //  if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) return SizedBox();
                final dailySchedule = snapshot.data?.dailySchedule;

                final currentSlot =
                    getcurrentSlot(dailySchedule: dailySchedule ?? []);
                final nextActions = snapshot.data?.dailySchedule
                        .firstWhere(
                          (element) => element.timeSlot == currentSlot,
                        )
                        .actions ??
                    [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: nextActions
                      .map(
                        (e) => Card(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color(0xff282828),
                              ),
                              borderRadius: BorderRadius.circular(25)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  e.category ?? '',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e.title ?? ''),
                                    Text(e.priority ?? ''),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(EneftyIcons.timer_2_outline),
                                        Text("${e.duration}min"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(EneftyIcons.location_outline),
                                        Text(e.location ?? ''),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
                //  return snapshot.data?.dailySchedule.where((element) => element.==, )
                //  }
              },
            )
          ],
        ),
      ),
    );
  }
}

Slot? getcurrentSlot({required List<DailyTimeSlot> dailySchedule}) {
  final currentTime = getDateTimeWithTime('');
  for (int i = 0; i < dailySchedule.length; i++) {
    if (i + 1 < dailySchedule.length) {
      final slotStart = getDateTimeWithTime(dailySchedule[i].startTime ?? '');
      final slotEnd = getDateTimeWithTime(dailySchedule[i + 1].startTime ?? '');
      if (currentTime.compareTo(slotStart) == 1 &&
          currentTime.compareTo(slotEnd) == -1) {
        return dailySchedule[i].timeSlot ?? Slot.undefined;
      }
    }
  }
  return null;
}

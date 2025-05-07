import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:glow/domain/glow.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../helper/helper_functions.dart';
import '../calendar/calendar_deps.dart';
import '../prompt_creator/prompt_creator_stepper_screen.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(CalendarDeps.scheduleProvider).then(
      (value) async {
        print('--$value ${context.mounted}');
        if (context.mounted && value == null) {
          print('here');
          await showModalBottomSheet(
            context: context,
            shape: LinearBorder(),
            isScrollControlled: true,
            useRootNavigator: true,
            constraints: BoxConstraints.expand(),
            builder: (context) {
              return PromptCreatorStepperScreen();
            },
          );
        } else {
          return value;
        }
      },
    );
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 6, bottom: 2),
              child: Text(
                'Next in your Schedule.. ⏭️',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            FutureBuilder(
              future: ref.watch(CalendarDeps.scheduleProvider),
              builder: (context, snapshot) {
                //  if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) return SizedBox();
                List<DailyTimeSlot> dailySchedule =
                    snapshot.data?.dailySchedule ?? [];
                print(dailySchedule.where(
                  (element) => element.timeSlot == Slot.night,
                ));
                final currentSlot =
                    getcurrentSlot(dailySchedule: dailySchedule);
                print('current slot $currentSlot');
                if (dailySchedule.isEmpty) return SizedBox();
                final nextActions = dailySchedule.firstWhereOrNull(
                  (element) => element.timeSlot == currentSlot,
                );
                final actions = nextActions?.actions ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 2,
                  children: actions
                      .map(
                        (e) => Card(
                          margin: EdgeInsets.all(0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1.5,
                                color: Color(0xff282828),
                              ),
                              borderRadius: BorderRadius.circular(25)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    spacing: 2,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.category ?? '',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            e.title ?? '',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff282828),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                EneftyIcons.timer_2_outline,
                                                size: 16,
                                                color: Color(0xff989696),
                                              ),
                                              Text(
                                                "${e.duration}min",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xff989696)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 11,
                                            child: VerticalDivider(
                                              color: Color(0xff282828)
                                                  .withValues(alpha: .2),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(EneftyIcons.location_outline,
                                                  size: 16,
                                                  color: Color(0xff989696)),
                                              Text(
                                                e.location ?? '',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xff989696)),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: Color(0xffFF8C61),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        e.priority ?? '',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

Slot getcurrentSlot({required List<DailyTimeSlot> dailySchedule}) {
  final currentTime = getDateTimeWithTime('');
  for (int i = 0; i < dailySchedule.length; i++) {
    if (i + 1 < dailySchedule.length) {
      print(dailySchedule[i + 1].startTime);
      final slotStart = getDateTimeWithTime(dailySchedule[i].startTime ?? '');
      final slotEnd = getDateTimeWithTime(dailySchedule[i + 1].startTime ?? '');
      print('current strt ->${currentTime.compareTo(slotStart)}');
      print('current end ->${currentTime.compareTo(slotEnd)}');
      if (currentTime.compareTo(slotStart) == 1 &&
          currentTime.compareTo(slotEnd) == -1) {
        return dailySchedule[i].timeSlot ?? Slot.undefined;
      }
    }
  }
  return Slot.night;
}

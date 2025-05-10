import 'package:flutter/material.dart';
import 'package:glow/domain/glow.dart';
import 'package:glow/feature/home/action_details_sheet.dart';
import 'package:glow/ui/action_card.dart';

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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            FutureBuilder(
              future: ref.watch(CalendarDeps.scheduleProvider),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SizedBox();
                List<DailyTimeSlot> dailySchedule =
                    snapshot.data?.dailySchedule ?? [];
                print(dailySchedule.where(
                  (element) => element.timeSlot == Slot.night,
                ));
                final currentSlot =
                    getcurrentSlot(dailySchedule: dailySchedule);
                print('current slot $currentSlot');
                if (dailySchedule.isEmpty) {
                  return Column(
                    children: [Text('no items')],
                  );
                }
                final nextActions = dailySchedule.firstWhereOrNull(
                  (element) => element.timeSlot == currentSlot,
                );
                final actions = nextActions?.actions ?? [];
                print('current actions -->  $actions');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 2,
                  children: actions
                      .map((e) => ActionCard(
                            action: e,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                barrierColor: Color(0xff4A4A4A).withAlpha(70),
                                builder: (context) {
                                  return ActionDetailsSheet(action: e);
                                },
                              );
                            },
                          ))
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

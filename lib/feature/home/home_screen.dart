import 'package:flutter/material.dart';
import 'package:glow/domain/glow.dart';
import 'package:glow/ui/action_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../helper/helper_functions.dart';
import '../calendar/calendar_deps.dart';
import '../prompt_creator/prompt_creator_stepper_screen.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final schedule = ref.watch(CalendarDeps.scheduleProvider);
    // Use useEffect to handle showing the bottom sheet AFTER build completes
    print('here -$schedule');
    schedule.when(
      data: (data) {
        if (data == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showModalBottomSheet(
              context: context,
              shape: const LinearBorder(),
              isScrollControlled: true,
              constraints: BoxConstraints.expand(),
              builder: (context) => const PromptCreatorStepperScreen(),
            );
          });
        }
      },
      error: (error, stackTrace) {},
      loading: () {},
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 6, bottom: 2),
              child: Text(
                'Next in your Schedule.. ⏭️',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            Consumer(
              builder: (context, ref, widget) {
                if (!schedule.hasValue) return SizedBox();
                List<DailyTimeSlot> dailySchedule =
                    schedule.value?.dailySchedule ?? [];
                if (dailySchedule.isEmpty) {
                  return Column(
                    children: [Text('no items')],
                  );
                }
                final currentSlot = getCurrentSlot(
                  dailySchedule: dailySchedule,
                );
                print('crrent slot $currentSlot');
                final nextActions = dailySchedule.firstWhereOrNull(
                  (element) {
                    return element.timeSlot == currentSlot;
                  },
                );
                final today = DateUtils.dateOnly(DateTime.now());

                final actions = nextActions?.actions
                        ?.where((action) =>
                            action.instances?.any((instance) =>
                                DateUtils.dateOnly(
                                    instance.date ?? DateTime(2000)) ==
                                today) ??
                            false)
                        .toList() ??
                    [];
                final sortedActions = [...actions]..sort((a, b) {
                    if (a.datedInstance()?.status == ActionStatus.completed &&
                        b.datedInstance()?.status == ActionStatus.completed) {
                      return 0;
                    }
                    return a.datedInstance()?.status == ActionStatus.completed
                        ? 1
                        : -1;
                  });

                return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 2,
                    children: [
                      ...sortedActions.map((e) {
                        print('action $e');
                        return ManageableActionCard(
                          action: e,
                          instanceId: e.datedInstance()?.id,
                        );
                      }),
                      SizedBox(
                        height: 100,
                      )
                    ]);
              },
            )
          ],
        ),
      ),
    );
  }
}

Slot getCurrentSlot({
  required List<DailyTimeSlot> dailySchedule,
}) {
  final currentTime = getDateTimeWithTime('');

  for (int i = 0; i < dailySchedule.length; i++) {
    if (i + 1 < dailySchedule.length) {
      final slotStart = getDateTimeWithTime(dailySchedule[i].startTime ?? '');
      final slotEnd = getDateTimeWithTime(dailySchedule[i + 1].startTime ?? '');

      if (currentTime.isAfter(slotStart) && currentTime.isBefore(slotEnd)) {
        return dailySchedule[i].timeSlot ?? Slot.night;
      }
    }
  }

  // If current time is after the last slot, return the last one
  if (dailySchedule.isNotEmpty) {
    final lastSlotTime =
        getDateTimeWithTime(dailySchedule.last.startTime ?? '');
    if (currentTime.isAfter(lastSlotTime)) {
      return dailySchedule.last.timeSlot ?? Slot.night;
    }
  }

  return Slot.night;
}

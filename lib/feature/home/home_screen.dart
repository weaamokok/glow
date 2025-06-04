import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    print('schedule $schedule');
    // Use useEffect to handle showing the bottom sheet AFTER build completes
    useEffect(() {
      if (schedule.value == null && context.mounted) {
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
      return null;
    }, [
      schedule.value,
    ]);

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
                print('daily sch ${dailySchedule}');
                final currentSlot =
                    getcurrentSlot(dailySchedule: dailySchedule);

                final nextActions = dailySchedule.firstWhereOrNull(
                  (element) {
                    print(
                        'element ${element.timeSlot} start time ${element.timeSlot}');
                    return element.timeSlot == currentSlot;
                  },
                );
                final actions = nextActions?.actions ?? [];
                print('actions $currentSlot');
// Sort actions so completed ones come last
                final sortedActions = [...actions]..sort((a, b) {
                    if (a.datedInstance()?.status == ActionStatus.completed &&
                        b.datedInstance()?.status == ActionStatus.completed) {
                      return 0;
                    }
                    return a.datedInstance()?.status == ActionStatus.completed
                        ? 1
                        : -1;
                  });

                print('sorted actions ${sortedActions}');
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 2,
                    children: [
                      ...sortedActions.map((e) {
                        return ManageableActionCard(
                          action: e,
                          instanceId: e.datedInstance()?.id ?? '',
                        );
                      }),
                    ]);
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
      final slotStart = getDateTimeWithTime(dailySchedule[i].startTime ?? '');
      final slotEnd = getDateTimeWithTime(dailySchedule[i + 1].startTime ?? '');
      if (currentTime.compareTo(slotStart) == 1 &&
          currentTime.compareTo(slotEnd) == -1) {
        return dailySchedule[i].timeSlot ?? Slot.undefined;
      }
    }
  }
  return Slot.night;
}

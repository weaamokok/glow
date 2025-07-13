import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glow/domain/glow.dart';
import 'package:glow/l10n/translations.g.dart';
import 'package:glow/ui/action_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../helper/helper_functions.dart';
import '../calendar/calendar_deps.dart';
import '../prompt_creator/prompt_creator_stepper_screen.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key, this.controller});

  final ScrollController? controller;

  @override
  Widget build(BuildContext context, ref) {
    final schedule = ref.watch(CalendarDeps.scheduleProvider);
    final hasOpenedPromptCreator = useState(false);
    print('schedule $schedule');
    useEffect(() {
      schedule.when(
        data: (data) {
          if (data == null && !hasOpenedPromptCreator.value) {
            hasOpenedPromptCreator.value = true; // prevent multiple openings
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) =>
                const PromptCreatorStepperBody(
                  isEdit: false,
                ),
              );
            });
          }
        },
        error: (_, __) {},
        loading: () {},
      );
      return null;
    }, [schedule]);

    final local = context.t;
    return SingleChildScrollView(
      controller: controller,
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
                local.homeScreenTitle,
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
                    children: [Text(local.emptyActionList)],
                  );
                }
                final currentSlot = getCurrentSlot(
                  dailySchedule: dailySchedule,
                );
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
                final sortedActions = [...actions]
                  ..sort((a, b) {
                    if (a
                        .datedInstance()
                        ?.status == ActionStatus.completed &&
                        b
                            .datedInstance()
                            ?.status == ActionStatus.completed) {
                      return 0;
                    }
                    return a
                        .datedInstance()
                        ?.status == ActionStatus.completed
                        ? 1
                        : -1;
                  });

                return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 2,
                    children: [
                      ...sortedActions.map((e) {
                        return ManageableActionCard(
                          action: e,
                          instanceId: e
                              .datedInstance()
                              ?.id,
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

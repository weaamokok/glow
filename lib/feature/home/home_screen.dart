import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glow/domain/glow.dart';
import 'package:glow/l10n/translations.g.dart';
import 'package:glow/ui/action_card.dart';
import 'package:home_widget/home_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../helper/helper_functions.dart';
import '../../resources/resources.dart';
import '../calendar/calendar_deps.dart';
import '../prompt_creator/prompt_creator_stepper_screen.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key, this.controller});

  final ScrollController? controller;
void promptCreator(context){

  WidgetsBinding.instance.addPostFrameCallback((_) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
      const PromptCreatorStepperScreen(isEdit: false),
    );
  });
}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedule = ref.watch(CalendarDeps.scheduleProvider);
    final hasOpenedPromptCreator = useState(false);
    final local = context.t;

    // Handle prompt creator sheet
    useEffect(() {
      schedule.when(
        data: (data) {
          if (data == null && !hasOpenedPromptCreator.value) {
            hasOpenedPromptCreator.value = true;
            promptCreator(context);
          }
        },
        error: (_, __) {},
        loading: () {},
      );
      return null;
    }, [schedule]);

    // Compute actions & update widget
    final sortedActions = useMemoized(() {
      //  if (!schedule.hasValue) return <GAction>[];

      final dailySchedule = schedule.value?.dailySchedule ?? [];
      if (dailySchedule.isEmpty) return [];

      final currentSlot = getCurrentSlot(dailySchedule: dailySchedule);
      final nextActions = dailySchedule.firstWhereOrNull(
        (element) => element.timeSlot == currentSlot,
      );

      final today = DateUtils.dateOnly(DateTime.now());
      final actions =
          nextActions?.actions
              ?.where(
                (action) =>
                    action.instances?.any(
                      (instance) =>
                          DateUtils.dateOnly(instance.date ?? DateTime(2000)) ==
                          today,
                    ) ??
                    false,
              )
              .toList() ??
          [];

      final sorted = [...actions]
        ..sort((a, b) {
          if (a.datedInstance()?.status == ActionStatus.completed &&
              b.datedInstance()?.status == ActionStatus.completed) {
            return 0;
          }
          return a.datedInstance()?.status == ActionStatus.completed ? 1 : -1;
        });

      return sorted;
    }, [schedule]);

    // Update HomeWidget
    useEffect(() {
      Future.microtask(() async {
        if (sortedActions.isNotEmpty) {
          final firstIncompleteAction = sortedActions.firstWhereOrNull(
            (action) =>
                action.datedInstance()?.status != ActionStatus.completed,
          );

          if (firstIncompleteAction != null) {
            await HomeWidget.saveWidgetData<String>(
              'widgetTitle',
              firstIncompleteAction.title ?? 'No title',
            );
            await HomeWidget.saveWidgetData<String>(
              'widgetCategory',
              firstIncompleteAction.category ?? '',
            );
            await HomeWidget.saveWidgetData<String>(
              'widgetPriority',
              describeEnum(firstIncompleteAction.priority ?? 'medium').name,
            );
            await HomeWidget.saveWidgetData<String>(
              'widgetDetails',
              '${firstIncompleteAction.duration ?? 0}min | ${firstIncompleteAction.location ?? "No location"}',
            );
            await HomeWidget.updateWidget(name: 'MyWidgetProvider');
          }
        }
      });
      return null;
    }, [sortedActions]);

    return SingleChildScrollView(
      controller: controller,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 6, bottom: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.value == null? local.homeScreen.emptyScheduleTitle: local.homeScreen.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ), if(schedule.value == null) Text(local.homeScreen.emptyScheduleSubTitle,
                    style: const TextStyle(
                    color: Colors.grey

                    ),
                  ),
                ],
              ),
            ),
            if (schedule.value == null)
              GUserWidget(
                imagePath: Images.emptySchdule,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                label: local.homeScreen.emptyScheduleMessage,
                child: ElevatedButton(
                  onPressed: () {
                    promptCreator(context);
                  },

                  child: Text(local.homeScreen.createScheduleCta),
                ),
              )
            else if (sortedActions.isEmpty)
              GUserWidget(imagePath: Images.emptyActions, label: local.noActionsToday           ,     padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
    )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...sortedActions.map(
                    (e) => ManageableActionCard(
                      action: e,
                      instanceId: e.datedInstance()?.id,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class GUserWidget extends StatelessWidget {
  const GUserWidget({
    super.key,
    this.padding,
    required this.imagePath,
    required this.label,
    this.child,
  });

  final EdgeInsets? padding;
  final String label;
  final String imagePath;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 25.0),
      child: Center(
        child: Column(
          spacing: 5,
          children: [
            Image.asset(imagePath, height: 250),
            Text(label, textAlign: TextAlign.center),
            ?child,
          ],
        ),
      ),
    );
  }
}

Slot getCurrentSlot({required List<DailyTimeSlot> dailySchedule}) {
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
    final lastSlotTime = getDateTimeWithTime(
      dailySchedule.last.startTime ?? '',
    );
    if (currentTime.isAfter(lastSlotTime)) {
      return dailySchedule.last.timeSlot ?? Slot.night;
    }
  }

  return Slot.night;
}

GPriority describeEnum(String priority) {
  switch (priority.toUpperCase()) {
    case 'HIGH':
      return GPriority.high;
    case 'MEDIUM':
      return GPriority.medium;
    case 'LOW':
      return GPriority.low;
    default:
      return GPriority.unKnown;
  }
}

enum GPriority { low, medium, high, unKnown }

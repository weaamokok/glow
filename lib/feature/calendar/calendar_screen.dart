import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glow/domain/action_instance.dart';
import 'package:glow/domain/glow.dart';
import 'package:glow/ui/action_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../helper/helper_functions.dart';
import 'calendar_deps.dart';

class CalendarScreen extends HookConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final selectedDay = useState(DateTime.now());
    final currentWeekDates = currentWeek();
    currentWeekDates.sort();
    final glowSchedule = ref.watch(CalendarDeps.scheduleProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          CalenderHeader(selectedDay: selectedDay),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Consumer(builder: (context, ref, widget) {
              return glowSchedule.map(
                data: (data) {
                  final allActions = data.value?.dailySchedule
                      .map(
                        (e) =>
                            e.actions
                                ?.where(
                                  (action) =>
                                      action.datedInstance(
                                          date: selectedDay.value) !=
                                      null,
                                )
                                .toList() ??
                            <ScheduleAction>[],
                      )
                      .toList();

                  final actions =
                      allActions?.expand((list) => list).toList() ?? [];
                  if (actions.isEmpty) return Text('empty');
                  return Container(
                    padding: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(),
                    child: Column(
                      spacing: 14,
                      children: data.value?.dailySchedule.map(
                            (dailyTime) {
                              if ((dailyTime.actions ?? []).isEmpty) {
                                return Text('empty');
                              }
                              return Column(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.symmetric(
                                        horizontal: 8),
                                    child: Row(
                                      spacing: 10,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            dailyTime.timeSlot?.name ?? '',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          child: SizedBox(
                                              width: double.infinity,
                                              child: Divider(
                                                  height: 2,
                                                  color: Color(0xff282828)
                                                      .withValues(alpha: .1))),
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                      spacing: 5,
                                      children: dailyTime.actions?.map(
                                            (e) {
                                              ActionInstance?
                                                  actionCurrentInstance =
                                                  e.datedInstance(
                                                      date: selectedDay.value);

                                              if (actionCurrentInstance !=
                                                  null) {
                                                return ManageableActionCard(
                                                  instanceId:
                                                      actionCurrentInstance.id,
                                                  action: e,
                                                );
                                              } else {
                                                return SizedBox();
                                              }
                                            },
                                          ).toList() ??
                                          []),
                                ],
                              );
                            },
                          ).toList() ??
                          [],
                    ),
                  );
                },
                error: (error) => Text('something went wrong $error'),
                loading: (loading) => CircularProgressIndicator(),
              );
            }),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

class CalenderHeader extends StatelessWidget {
  const CalenderHeader({required this.selectedDay, super.key});

  final ValueNotifier<DateTime> selectedDay;

  @override
  Widget build(BuildContext context) {
    final currentWeekDates = currentWeek();
    currentWeekDates.sort();
    return Column(
      spacing: 10,
      children: [
        Center(
          child: Text(
            DateFormat.yMd()
                        .format(selectedDay.value)
                        .compareTo(DateFormat.yMd().format(DateTime.now())) ==
                    0
                ? 'Today'
                : DateFormat.yMMMMEEEEd().format(selectedDay.value),
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: MediaQuery.of(context).size.width * .04,
          children: currentWeekDates.map(
            (e) {
              if (e == null) return SizedBox();
              return InkWell(
                onTap: () {
                  selectedDay.value = e;
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: e.day == selectedDay.value.day
                      ? BoxDecoration(
                          border:
                              Border.all(color: Color(0xffB399D4), width: 1.5),
                          borderRadius: BorderRadius.circular(24))
                      : null,
                  child: Column(
                    children: [
                      Text(
                        DateFormat('EEEE').format(e).substring(0, 3),
                        style: TextStyle(
                          color: Color(0xff282828).withValues(
                            alpha: e.day == selectedDay.value.day ? 1 : .5,
                          ),
                        ),
                      ),
                      Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                              color: e.day == selectedDay.value.day
                                  ? Color(0xffB399D4)
                                  : null,
                              borderRadius: BorderRadius.circular(18)),
                          child: Text(
                            '${e.day}',
                            style: TextStyle(
                                color: e.day == selectedDay.value.day
                                    ? Colors.white
                                    : Colors.black.withValues(
                                        alpha: e.day == selectedDay.value.day
                                            ? 1
                                            : .3,
                                      )),
                          )),
                    ],
                  ),
                ),
              );
            },
          ).toList(),
        )
      ],
    );
  }
}

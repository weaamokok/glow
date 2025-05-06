import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../prompt_creator/prompt_creator_stepper_screen.dart';
import 'calendar_deps.dart';

class CalendarScreen extends HookConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final glowSchedule = ref.watch(CalendarDeps.scheduleProvider).then(
      (value) async {
        if (context.mounted && value == null) {
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

    final selectedDay = useState(DateTime.now());

    return SingleChildScrollView(
      child: Container(
          //  color: Color(0xffB399D4),
          padding: EdgeInsets.only(
            top: 50,
          ),
          child: Column(
            children: [
              CalenderHeader(selectedDay: selectedDay),
              SizedBox(height: 20),
              FutureBuilder(
                  future: glowSchedule,
                  builder: (context, futureValue) {
                    if (futureValue.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    final dailyAction = futureValue.data?.dailySchedule
                        .map(
                          (e) => e.actions
                              ?.map(
                                (e) => ListTile(
                                  title: Text(e.title ?? ''),
                                ),
                              )
                              .toList(),
                        )
                        .toList();
                    dailyAction?.expand<Widget>(
                      (element) {
                        if (element == null) return [];

                        return element;
                      },
                    ).toList();
                    return Container(
                      //  padding: EdgeInsets.only(top: 44),
                      decoration: BoxDecoration(
                          // color: Colors.white,
                          // border: Border.symmetric(
                          //     horizontal: BorderSide(
                          //   color: Color(0xff282828),
                          // )),
                          // borderRadius: BorderRadius.vertical(
                          //   top: Radius.circular(50),
                          // ),
                          ),
                      child: Column(
                          children: futureValue.data?.dailySchedule
                                  .map(
                                    (dailyTime) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.symmetric(
                                                  horizontal: 18),
                                          child: Flexible(
                                            child: Row(
                                              spacing: 10,
                                              children: [
                                                Text(
                                                  dailyTime.timeSlot?.name ??
                                                      '',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                Flexible(
                                                  child: SizedBox(
                                                      width: double.infinity,
                                                      child: Divider(
                                                          height: 2,
                                                          color:
                                                              Color(0xff282828)
                                                                  .withValues(
                                                                      alpha:
                                                                          .2))),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: dailyTime.actions
                                                  ?.map(
                                                    (e) => ListTile(
                                                      title:
                                                          Text(e.title ?? ''),
                                                      subtitle: Text(
                                                          e.category ?? ''),
                                                    ),
                                                  )
                                                  .toList() ??
                                              [],
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList() ??
                              []),
                    );
                  })
            ],
          )),
    );
  }
}

class CalenderHeader extends StatelessWidget {
  const CalenderHeader({required this.selectedDay, super.key});

  final ValueNotifier selectedDay;

  @override
  Widget build(BuildContext context) {
    final currentWeekDates = currentWeek();
    currentWeekDates.sort();
    return Column(
      spacing: 20,
      children: [
        Center(
          child: Text(
            DateFormat.yMd()
                        .format(selectedDay.value)
                        .compareTo(DateFormat.yMd().format(DateTime.now())) ==
                    0
                ? 'Today'
                : DateFormat.yMMMMEEEEd().format(selectedDay.value),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: MediaQuery.of(context).size.width * .03,
          children: currentWeekDates.map(
            (e) {
              if (e == null) return SizedBox();
              return Container(
                padding: EdgeInsets.all(8),
                decoration: e.day == selectedDay.value.day
                    ? BoxDecoration(
                        border: Border.all(),
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
                                ? Colors.black
                                : null,
                            borderRadius: BorderRadius.circular(18)),
                        child: Text(
                          '${e.day}',
                          style: TextStyle(
                              color: e.day == selectedDay.value.day
                                  ? Colors.white
                                  : Colors.black),
                        )),
                  ],
                ),
              );
            },
          ).toList(),
        )
      ],
    );
  }
}

List<DateTime?> currentWeek() {
  return List.generate(
    7,
    (index) {
      if (index < 3) {
        return DateTime.now().subtract(Duration(days: index + 1));
      } else if (index == 3) {
        return DateTime.now();
      } else if (index > 3) {
        return DateTime.now().add(Duration(days: 7 - index));
      } else {
        return null;
      }
    },
  );
}

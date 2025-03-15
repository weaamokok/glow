import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PersonalInfoStep extends HookConsumerWidget {
  const PersonalInfoStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        spacing: 14,
        children: [
          SizedBox(
              height: 46,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'What do you do for living..?',
                ),
              )),
          SizedBox(
              height: 46,
              child: TextFormField(
                readOnly: true,
                onTap: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime(1920),
                    lastDate: DateTime.now(),

                    // builder: (context, widget) {
                    //   return Container(
                    //       width: 200,
                    //       height: 300,
                    //       padding: EdgeInsets.symmetric(
                    //           horizontal: 50, vertical: 70),
                    //       child: DateTi
                    //       // SfDateRangePicker(
                    //       //   view: DateRangePickerView.year,
                    //       // )
                    //       );
                    //    },
                  );
                },
                decoration: InputDecoration(
                    hintText: 'birth date',
                    suffixIcon: Icon(
                      EneftyIcons.calendar_2_outline,
                      color: Color(0xff4C7B8B).withValues(alpha: .7),
                    )),
              )),
          SizedBox(
              height: 46,
              child: TextFormField(
                onTap: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      Gender selectedOption = Gender.male;
                      return Dialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                ListTile(
                                  title: const Text('male'),
                                  leading: Radio<Gender>(
                                    value: Gender.male,
                                    groupValue: selectedOption,
                                    onChanged: (value) {},
                                  ),
                                ),
                                ListTile(
                                  title: const Text('female'),
                                  leading: Radio<Gender>(
                                    value: Gender.female,
                                    groupValue: selectedOption,
                                    onChanged: (value) {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                decoration: InputDecoration(
                  hintText: 'gender',
                ),
              )),
          SizedBox(
              height: 46,
              child: TextFormField(
                onTap: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      String selectedActivity = activityType.first;
                      return Dialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                                children: activityType
                                    .map(
                                      (e) => ListTile(
                                        title: Text(e),
                                        leading: Radio<String>(
                                          value: e,
                                          groupValue: selectedActivity,
                                          onChanged: (value) {},
                                        ),
                                      ),
                                    )
                                    .toList()),
                          ),
                        ),
                      );
                    },
                  );
                },
                decoration: InputDecoration(
                  hintText: 'how do you spend your day?',
                ),
              )),
          SizedBox(
              height: 46,
              child: TextFormField(
                onTap: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      String selectedActivity = activityType.first;
                      return Dialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                                children: workOutSchedule
                                    .map(
                                      (e) => ListTile(
                                        title: Text(e),
                                        leading: Radio<String>(
                                          value: e,
                                          groupValue: selectedActivity,
                                          onChanged: (value) {},
                                        ),
                                      ),
                                    )
                                    .toList()),
                          ),
                        ),
                      );
                    },
                  );
                },
                decoration: InputDecoration(
                  hintText: 'how often do you workout?',
                ),
              )),
        ],
      ),
    );
  }
}

enum Gender { male, female }

final activityType = [
  'mostly sitting',
  'mostly standing',
  'I move around a lot'
];
final workOutSchedule = [
  "I don't workout ",
  "3 days a week or less",
  "more that 3 days a week",
];

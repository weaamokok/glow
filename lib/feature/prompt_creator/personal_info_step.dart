import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glow/feature/prompt_creator/prompt_creator_deps.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PersonalInfoStep extends HookConsumerWidget {
  const PersonalInfoStep({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final promptPersonalInfo =
        ref.read(PromptCreatorDeps.promptPersonalInfoProvider);
    final workTextFieldController = useTextEditingController();
    final birthDateTextFieldController = useTextEditingController();
    final genderTextFieldController = useTextEditingController();
    final activityTextFieldController = useTextEditingController();
    final workoutScheduleTextFieldController = useTextEditingController();
    final hobbiesTextFieldController = useTextEditingController();
    final selectedOption = useValueNotifier<Gender>(Gender.male);

    // Function to format the date as yyyy-MM-dd
    String formatDate(DateTime date) {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }

    // // Function to validate all fields
    // bool validateFields() {
    //   if (workTextFieldController.text.isEmpty) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Please enter your job')),
    //     );
    //     return false;
    //   }
    //   if (birthDateTextFieldController.text.isEmpty) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Please select your birth date')),
    //     );
    //     return false;
    //   }
    //   if (genderTextFieldController.text.isEmpty) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Please select your gender')),
    //     );
    //     return false;
    //   }
    //   if (activityTextFieldController.text.isEmpty) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Please select your daily activity')),
    //     );
    //     return false;
    //   }
    //   if (workoutScheduleTextFieldController.text.isEmpty) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Please select your workout schedule')),
    //     );
    //     return false;
    //   }
    //   if (hobbiesTextFieldController.text.isEmpty) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Please enter your hobbies')),
    //     );
    //     return false;
    //   }
    //   return true;
    // }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        spacing: 14,
        children: [
          SizedBox(
              height: 46,
              child: TextFormField(
                controller: workTextFieldController,
                decoration: InputDecoration(
                  hintText: 'What do you do for living..?',
                ),
                onChanged: (value) {
                  promptPersonalInfo.value.job =
                      workTextFieldController.value.text;
                },
              )),
          SizedBox(
              height: 46,
              child: TextFormField(
                controller: birthDateTextFieldController,
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1920),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    birthDateTextFieldController.value =
                        TextEditingValue(text: formatDate(date));
                    promptPersonalInfo.value.birthDate =
                        birthDateTextFieldController.value.text;
                  }
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
                controller: genderTextFieldController,
                readOnly: true,
                onTap: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) {
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
                                    groupValue: selectedOption.value,
                                    onChanged: (value) {
                                      if (value == null) return;
                                      selectedOption.value = value;
                                      genderTextFieldController.value =
                                          TextEditingValue(
                                              text: value
                                                  .toString()
                                                  .split('.')
                                                  .last);
                                      promptPersonalInfo.value.gender =
                                          value.toString().split('.').last;
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text('female'),
                                  leading: Radio<Gender>(
                                    value: Gender.female,
                                    groupValue: selectedOption.value,
                                    onChanged: (value) {
                                      if (value == null) return;
                                      selectedOption.value = value;
                                      genderTextFieldController.value =
                                          TextEditingValue(
                                              text: value
                                                  .toString()
                                                  .split('.')
                                                  .last);
                                      promptPersonalInfo.value.gender =
                                          value.toString().split('.').last;
                                      Navigator.pop(context);
                                    },
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
                controller: activityTextFieldController,
                readOnly: true,
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
                                          onChanged: (value) {
                                            if (value == null) return;
                                            selectedActivity = value;
                                            activityTextFieldController.value =
                                                TextEditingValue(text: value);
                                            promptPersonalInfo.value.activity =
                                                value;
                                            Navigator.pop(context);
                                          },
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
                controller: workoutScheduleTextFieldController,
                readOnly: true,
                onTap: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      String selectedSchedule = workOutSchedule.first;
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
                                          groupValue: selectedSchedule,
                                          onChanged: (value) {
                                            if (value == null) return;
                                            selectedSchedule = value;
                                            workoutScheduleTextFieldController
                                                    .value =
                                                TextEditingValue(text: value);
                                            promptPersonalInfo
                                                .value.workoutSchedule = value;
                                            Navigator.pop(context);
                                          },
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
          SizedBox(
              height: 46,
              child: TextFormField(
                controller: hobbiesTextFieldController,
                decoration: InputDecoration(
                  hintText: 'what do you do in your free time?',
                ),
                onChanged: (value) {
                  promptPersonalInfo.value.hobbies =
                      hobbiesTextFieldController.value.text;
                },
              )),
          const SizedBox(height: 20),
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

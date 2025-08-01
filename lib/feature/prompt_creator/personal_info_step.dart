import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glow/domain/user_info.dart';
import 'package:glow/feature/prompt_creator/prompt_creator_deps.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../l10n/translations.g.dart';

class PersonalInfoStep extends HookConsumerWidget {
  const PersonalInfoStep({required this.isEdit, super.key});

  final bool isEdit;

  @override
  Widget build(BuildContext context, ref) {
    final local = context.t;
    final userInfoLoc = local.personalInfoStep;

    final activityType = [
      userInfoLoc.mostlySitting,
      userInfoLoc.mostlyStanding,
      userInfoLoc.moveAround,
    ];
    final workOutSchedule = [
      userInfoLoc.noWorkout,
      userInfoLoc.k3DayAWeekOrLess,
      userInfoLoc.k3DayAWeekOrMore,
    ];

    final promptPersonalInfo = ref.read(
      PromptCreatorDeps.promptPersonalInfoProvider.notifier,
    );

    final selectedOption = useValueNotifier<Gender>(Gender.male);
    final selectedActivity = useValueNotifier<String>(activityType.first);
    final selectedSchedule = useValueNotifier<String>(workOutSchedule.first);

    final personalInfo = useState<UserPersonalInfo?>(null);
    final isLoaded = useState<bool>(!isEdit);

    useEffect(() {
      if (isEdit) {
        Future.microtask(() async {
          try {
            final saved = await ref.read(
              PromptCreatorDeps.getPersonalInformation,
            );
            personalInfo.value = saved;
          } catch (e) {
            debugPrint('Failed to load personal info: $e');
          } finally {
            isLoaded.value = true;
          }
        });
      }
      return null;
    }, []);

    if (!isLoaded.value) {
      return const Center(child: CircularProgressIndicator());
    }

    final info = personalInfo.value;
    final form = FormGroup({
      'work': FormControl<String>(value: info?.job),
      'birthdate': FormControl<String>(value: info?.birthDate),
      'gender': FormControl<String>(value: info?.gender),
      'activity': FormControl<String>(value: info?.activity),
      'workout': FormControl<String>(value: info?.workoutSchedule),
      'hobbies': FormControl<String>(value: info?.hobbies),
    });

    // Set default selected values for UI state
    if (info?.gender != null) {
      selectedOption.value = info?.gender == 'female'
          ? Gender.female
          : Gender.male;
    }
    if (activityType.contains(info?.activity)) {
      selectedActivity.value = info!.activity!;
    }
    if (workOutSchedule.contains(info?.workoutSchedule)) {
      selectedSchedule.value = info!.workoutSchedule!;
    }

    String formatDate(DateTime date) {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }

    return Padding(
      padding: EdgeInsets.only(
        right: 28,
        left: 28,
        //  bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ReactiveForm(
        formGroup: form,
        child: SizedBox(
          height: 500,
          child: ListView(
            shrinkWrap: true,
            children: [
              ReactiveTextField<String>(
                formControlName: 'work',
                decoration: InputDecoration(labelText: userInfoLoc.workLabel),
                onChanged: (_) => promptPersonalInfo.updateJob(
                  form.control('work').value ?? '',
                ),
              ),
              SizedBox(height: 10),
              ReactiveTextField<String>(
                formControlName: 'birthdate',
                readOnly: true,
                decoration: InputDecoration(
                  labelText: userInfoLoc.birthDateLabel,
                  suffixIcon: Icon(
                    EneftyIcons.calendar_2_outline,
                    color: const Color(0xff4C7B8B).withAlpha(70),
                  ),
                ),
                onTap: (control) async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1920),
                    lastDate: DateTime(2017),
                  );
                  if (date != null) {
                    final formatted = formatDate(date);
                    control.value = formatted;
                    promptPersonalInfo.updateBirthDate(formatted);
                  }
                },
              ),
              SizedBox(height: 10),
              ReactiveTextField<String>(
                formControlName: 'gender',
                readOnly: true,
                decoration: InputDecoration(labelText: userInfoLoc.sexLabel),
                onTap: (control) {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: Gender.values.map((e) {
                            onTap(Gender? value) {
                              if (value == null) return;
                              selectedOption.value = value;
                              final val = value.name;
                              control.value = e == Gender.male
                                  ? userInfoLoc.male
                                  : userInfoLoc.female;
                              promptPersonalInfo.updateGender(val);
                              Navigator.pop(context);
                            }

                            return ListTile(
                              onTap: () => onTap(e),
                              title: Text(
                                e == Gender.male
                                    ? userInfoLoc.male
                                    : userInfoLoc.female,
                              ),
                              leading: Radio<Gender>(
                                value: e,
                                groupValue: selectedOption.value,
                                onChanged: (_) => onTap(e),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              ReactiveTextField<String>(
                formControlName: 'activity',
                readOnly: true,
                decoration: InputDecoration(
                  labelText: userInfoLoc.activityLabel,
                ),
                onTap: (control) {
                  onTap(value) {
                    if (value == null) return;
                    selectedActivity.value = value;
                    control.value = value;
                    promptPersonalInfo.updateActivity(value);
                    Navigator.pop(context);
                  }

                  showAdaptiveDialog(
                    context: context,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: activityType.map((e) {
                            return ListTile(
                              onTap: () => onTap(e),
                              title: Text(e),
                              leading: Radio<String>(
                                value: e,
                                groupValue: selectedActivity.value,
                                onChanged: onTap,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              ReactiveTextField<String>(
                formControlName: 'workout',
                readOnly: true,
                decoration: InputDecoration(
                  labelText: userInfoLoc.workoutScheduleLabel,
                ),
                onTap: (control) {
                  onTap(e) {
                    selectedSchedule.value = e;
                    control.value = e;
                    promptPersonalInfo.updateWorkoutSchedule(e);
                    Navigator.pop(context);
                  }

                  showAdaptiveDialog(
                    context: context,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: workOutSchedule.map((e) {
                            return ListTile(
                              onTap: () => onTap(e),
                              title: Text(e),
                              leading: Radio<String>(
                                value: e,
                                groupValue: selectedSchedule.value,
                                onChanged: onTap,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              ReactiveTextField<String>(
                formControlName: 'hobbies',
                decoration: InputDecoration(
                  labelText: userInfoLoc.hobbiesLabel,
                ),
                onChanged: (control) =>
                    promptPersonalInfo.updateHobbies(control.value ?? ''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum Gender { male, female }

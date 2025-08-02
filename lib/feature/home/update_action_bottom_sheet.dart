import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glow/domain/glow.dart';
import 'package:glow/feature/calendar/calendar_deps.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../l10n/translations.g.dart';
import '../prompt_creator/prompt_creator_deps.dart';

class UpdateActionBottomSheet extends HookConsumerWidget {
  const UpdateActionBottomSheet({super.key, this.action});

  final ScheduleAction? action;

  @override
  Widget build(BuildContext context, ref) {
    final promptController = // In your widget
    ref.watch(
      PromptCreatorDeps.promptProvider.notifier,
    );
    final locale = context.t;
    final isRepeatedController = useState(ExpansibleController());

    final form = FormGroup({
      'title': FormControl<String>(
        value: action?.title,
        validators: [Validators.required],
      ),
      'description': FormControl<String>(value: action?.description),
      'recurring': FormControl<bool>(value: action?.recurring ?? false),
      'frequency': FormControl<List<String>>(value: action?.frequency ?? []),
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ReactiveForm(
        formGroup: form,
        child: Column(
          spacing: 18,
          children: [
            SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    context.maybePop();
                  },
                  child: Text(
                    locale.core.cancel,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  height: 3,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xff282828).withValues(alpha: .5),
                  ),
                ),
                ReactiveFormConsumer(
                  builder: (context, form, child) {
                    return TextButton(
                      onPressed: () async {
                        form.markAllAsTouched();
                        if (form.valid) {
                          final newAction = ScheduleAction(
                            id: action?.id ?? '',
                            title: form.control('title').value,
                            duration: action?.duration,
                            category: action?.category,
                            startDate: action?.startDate ?? DateTime.now(),
                            endDate:
                                action?.endDate ??
                                DateTime.now().add(Duration(days: 90)),
                            frequency: form.control('recurring').value
                                ? form.control('frequency').value
                                : [],
                            recurring: form.control('recurring').value,
                            priority: action?.priority,
                            instances: action?.instances ?? [],
                            location: action?.location,
                            prepNeeded: action?.prepNeeded,
                            description: form.control('description').value,
                          );

                          final updatePrompt = await promptController
                              .updateActionPrompt(
                                action: newAction,
                                isEdit: action != null,
                              );
                          updatePrompt.maybeMap(
                            orElse: () {
                              if (updatePrompt.hasError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('couldnt update')),
                                );
                              } //handle error
                            },
                            data: (data) async {
                              ref.invalidate(CalendarDeps.scheduleProvider);
                              context.maybePop();
                            },
                          );
                        }
                      },
                      child: Text(
                        locale.core.done,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            ReactiveTextField(
              formControlName: 'title',
              validationMessages: {
                ValidationMessage.required: (_) => 'title is required',
              },
              onChanged: (control) {
                form.control('title').value = control.value;
              },
              decoration: InputDecoration(
                labelText: locale.updateActionBottomSheet.title,
              ),
              textCapitalization: TextCapitalization.words,
              style: TextStyle(backgroundColor: Colors.white),
            ),
            ReactiveTextField(
              formControlName: 'description',
              onChanged: (control) {
                form.control('description').value = control.value;
              },
              decoration: InputDecoration(
                labelText: locale.updateActionBottomSheet.description,
              ),
              maxLines: 10,
              minLines: 1,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(backgroundColor: Colors.white),
            ),
            ExpansionTile(
              title: Text(locale.updateActionBottomSheet.repeat),
              initiallyExpanded: action?.recurring ?? false,
              tilePadding: const EdgeInsetsDirectional.only(start: 6),
              shape: UnderlineInputBorder(borderSide: BorderSide.none),
              collapsedShape: UnderlineInputBorder(borderSide: BorderSide.none),
              controller: isRepeatedController.value,
              onExpansionChanged: (value) {
                form.control('recurring').value = value;
              },
              controlAffinity: ListTileControlAffinity.platform,
              trailing: ReactiveSwitch(
                formControlName: 'recurring',
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (control) {
                  form.control('recurring').value = control.value ?? false;

                  if (control.value ?? false) {
                    isRepeatedController.value.expand();
                  } else {
                    isRepeatedController.value.collapse();
                  }
                },
              ),
              enabled: true,
              children: [
                ReactiveValueListenableBuilder<List<String>>(
                  formControlName: 'frequency',
                  builder: (context, control, child) {
                    final frequencyList = control.value ?? [];
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(start: 5),
                      child: Row(
                        children: locale.updateActionBottomSheet.weekdays.map((
                          day,
                        ) {
                          return InkWell(
                            onTap: () {
                              final updated = List<String>.from(frequencyList);
                              if (updated.contains(day)) {
                                updated.remove(day);
                              } else {
                                updated.add(day);
                              }
                              control.value = updated;
                            },
                            radius: 10,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: frequencyList.contains(day)
                                    ? Color(0xffB399D4)
                                    : Color(0xffF5F5F5),
                                border: Border.all(
                                  width: .5,
                                  color: Color(
                                    0xff282828,
                                  ).withValues(alpha: .5),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                day,
                                style: TextStyle(
                                  color: frequencyList.contains(day)
                                      ? Colors.white
                                      : Color(0xff282828).withValues(alpha: .5),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

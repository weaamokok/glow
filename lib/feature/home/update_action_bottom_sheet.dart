import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glow/domain/glow.dart';
import 'package:glow/feature/home/home_deps.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../helper/helper_functions.dart';
import '../prompt_creator/prompt_creator_deps.dart';

class UpdateActionBottomSheet extends HookConsumerWidget {
  const UpdateActionBottomSheet({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final selectedDays = useState<List<String>>([]);
    final isRepeatedController = useState(ExpansibleController());
    final isRepeated = useState(false);
    final titleController = useState(TextEditingController());
    final descriptionController = useState(TextEditingController());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        spacing: 18,
        children: [
          SizedBox(
            height: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  context.maybePop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                height: 3,
                width: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xff282828).withValues(alpha: .5)),
              ),
              TextButton(
                onPressed: () async {
                  final action = ScheduleAction(
                    id: '',
                    title: titleController.value.text,
                    duration: null,
                    category: null,
                    startDate: DateTime.now(),
                    endDate: DateTime.now().add(Duration(days: 90)),
                    frequency: selectedDays.value,
                    recurring: selectedDays.value.isNotEmpty,
                    priority: null,
                    instances: [],
                    description: descriptionController.value.text,
                  );
                  final prompt =
                      'user added this action, can you fill the fields that wasnt been added by user based on the schedule that youve created and other actions added, here is the action : ${action.toJson()} , note: keep instances empty';
                  final actionController = // In your widget
                      ref.read(HomeDeps.actionControllerProvider.notifier);

                  final response = await ref
                      .read(PromptCreatorDeps.modelProvider)
                      .generateContent(
                    [Content.text(prompt)],
                  );
                  print('response ${response.text}');
                  actionController.addAction(
                      newAction: ScheduleAction.fromJson(response.text ?? ''),
                      targetDate: DateTime.now());
                },
                child: Text(
                  'Done',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(
            child: TextFormField(
              controller: titleController.value,
              decoration: InputDecoration(
                labelText: 'title',
              ),
            ),
          ),
          // Divider(
          //   color: Color(0xff282828).withAlpha(50),
          // ),
          SizedBox(
            child: TextFormField(
              controller: descriptionController.value,
              decoration: InputDecoration(
                labelText: 'description',
              ),
            ),
          ),
          ExpansionTile(
            title: Text('Repeat'),
            initiallyExpanded: false,
            tilePadding: const EdgeInsetsDirectional.only(start: 6),
            shape: UnderlineInputBorder(borderSide: BorderSide.none),
            collapsedShape: UnderlineInputBorder(borderSide: BorderSide.none),
            controller: isRepeatedController.value,
            onExpansionChanged: (value) => isRepeated.value = value,
            controlAffinity: ListTileControlAffinity.platform,
            trailing: Switch(
              value: isRepeated.value,
              onChanged: (value) {
                isRepeated.value = value;
                if (value) {
                  print('value $value');
                  isRepeatedController.value.expand();
                } else {
                  isRepeatedController.value.collapse();
                }
              },
            ),
            enabled: true,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 5),
                child: Row(
                  children: weekDays.map(
                    (day) {
                      return InkWell(
                        onTap: () {
                          final updatedDays = selectedDays.value;
                          if (selectedDays.value.contains(day)) {
                            selectedDays.value =
                                updatedDays.where((d) => d != day).toList();
                          } else {
                            selectedDays.value = [...updatedDays, day];
                          }
                        },
                        radius: 10,
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: selectedDays.value.contains(day)
                                    ? Color(0xffB399D4)
                                    : Color(0xffF5F5F5),
                                border: Border.all(
                                    width: .5,
                                    color: Color(0xff282828)
                                        .withValues(alpha: .5)),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              day,
                              style: TextStyle(
                                  color: selectedDays.value.contains(day)
                                      ? Colors.white
                                      : Color(0xff282828)
                                          .withValues(alpha: .5)),
                            )),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

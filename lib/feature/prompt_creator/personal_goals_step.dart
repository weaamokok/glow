import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glow/feature/prompt_creator/prompt_creator_deps.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PersonalGoalsStep extends HookConsumerWidget {
  const PersonalGoalsStep({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final promptPersonalInfo =
        ref.read(PromptCreatorDeps.promptPersonalInfoProvider.notifier);
    final goalsTextFieldController = useTextEditingController();
    final notesTextFieldController = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        spacing: 14,
        children: [
          SizedBox(
              height: 46,
              child: TextFormField(
                controller: goalsTextFieldController,
                decoration: InputDecoration(
                  hintText: "what's your goal from this glow up",
                ),
                onChanged: (value) {
                  promptPersonalInfo
                      .updateGoals(goalsTextFieldController.value.text);
                },
              )),
          SizedBox(
              height: 46,
              child: TextFormField(
                controller: notesTextFieldController,
                decoration: InputDecoration(
                  hintText: "Any notes to take in consideration",
                ),
                onChanged: (value) {
                  promptPersonalInfo
                      .updateNotes(notesTextFieldController.value.text);
                },
              )),
        ],
      ),
    );
  }
}

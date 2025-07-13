import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glow/domain/user_info.dart';
import 'package:glow/feature/prompt_creator/prompt_creator_deps.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../l10n/translations.g.dart';

class PersonalGoalsStep extends HookConsumerWidget {
  const PersonalGoalsStep({required this.isEdit, super.key});

  final bool isEdit;

  @override
  Widget build(BuildContext context, ref) {
    final promptPersonalInfo =
        ref.read(PromptCreatorDeps.promptPersonalInfoProvider.notifier);
    final local = context.t;
    final userGoalsLoc = local.personalGoalStep;

    final personalInfo = useState<UserPersonalInfo?>(null);
    final isLoaded = useState<bool>(!isEdit);

    useEffect(() {
      if (isEdit) {
        Future.microtask(() async {
          try {
            final saved =
                await ref.read(PromptCreatorDeps.getPersonalInformation);
            personalInfo.value = saved;
          } catch (e) {
            debugPrint('Failed to load personal goal info: $e');
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
      'goals': FormControl<String>(value: info?.goals),
      'notes': FormControl<String>(value: info?.notes),
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ReactiveForm(
        formGroup: form,
        child: Column(
          spacing: 15,
          children: [
            ReactiveTextField<String>(
              formControlName: 'goals',
              decoration: InputDecoration(
                labelText: userGoalsLoc.goalsLabel,
              ),
              onChanged: (control) {
                promptPersonalInfo.updateGoals(control.value ?? '');
              },
            ),
            ReactiveTextField<String>(
              formControlName: 'notes',
              decoration: InputDecoration(
                labelText: userGoalsLoc.notesLabel,
              ),
              onChanged: (control) {
                promptPersonalInfo.updateNotes(control.value ?? '');
              },
            ),
          ],
        ),
      ),
    );
  }
}

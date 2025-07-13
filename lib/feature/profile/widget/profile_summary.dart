import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glow/domain/user_info.dart';
import 'package:glow/feature/prompt_creator/prompt_creator_deps.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../app/app_router.gr.dart';
import '../../../helper/helper_functions.dart';
import '../../../l10n/translations.g.dart';

@RoutePage()
class UserProfileSummaryScreen extends HookConsumerWidget {
  const UserProfileSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final local = context.t;
    final images = useState<List<File?>>([]);
    final personalInfo = useState<UserPersonalInfo?>(null);
    final userInfoAsync =
        useFuture(ref.read(PromptCreatorDeps.getPersonalInformation));
    useEffect(() {
      Future.microtask(() async {
        try {
          final ima = await ref.watch(PromptCreatorDeps.getSavedImages);
          personalInfo.value =
              await ref.read(PromptCreatorDeps.getPersonalInformation);
          List<File?> temp = [];
          if (ima.isNotEmpty) {
            print('not empty $ima');
            final files = await uint8ListToFile(ima ?? []);
            print('files $files');
            // Remove nulls in case of conversion failures
            for (int i = 0; i < files.length; i++) {
              final file = files[i];
              if (file != null) {
                temp.add(file);
              }
            }
            images.value = temp;
          }
        } catch (e) {
          debugPrint('Failed to load saved images: $e');
        }
      });

      return null;
    }, []);

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            _ImageGrid(images.value),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Job',
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                      Text(personalInfo.value?.workoutSchedule ?? ''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'BirthDate',
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                      Text(personalInfo.value?.birthDate ?? ''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Gender',
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                      Text(personalInfo.value?.gender ?? ''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Activity Level',
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                      Text(personalInfo.value?.activity ?? ''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hobbies',
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                      Text(personalInfo.value?.hobbies ?? ''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Note',
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                      Text(personalInfo.value?.notes ?? ''),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    )
        // userInfoAsync.when(
        //   loading: () => const Center(child: CircularProgressIndicator()),
        //   error: (e, _) => Center(child: Text(local.core.somethingWentWrong)),
        //   data: (info) {
        //     if (info == null) {
        //       return Center(child: Text('local.core.noDataFound'));
        //     }
        //
        //     return ListView(
        //       padding: const EdgeInsets.all(20),
        //       children: [
        //         _SectionTitle(local.imagePickerStep.description),
        //         _ImageGrid(userImages),
        //         const SizedBox(height: 16),
        //         _SectionTitle(local.personalInfoStep.k3DayAWeekOrMore),
        //         _InfoTile(local.personalInfoStep.workLabel, info.job),
        //         _InfoTile(local.personalInfoStep.birthDateLabel, info.birthDate),
        //         _InfoTile(local.personalInfoStep.sexLabel, info.gender),
        //         _InfoTile(local.personalInfoStep.activityLabel, info.activity),
        //         _InfoTile(local.personalInfoStep.workoutScheduleLabel,
        //             info.workoutSchedule),
        //         _InfoTile(local.personalInfoStep.hobbiesLabel, info.hobbies),
        //         const SizedBox(height: 16),
        //         _SectionTitle(local.personalGoalStep.goalsLabel),
        //         _InfoTile(local.personalGoalStep.goalsLabel, info.goals),
        //         _InfoTile(local.personalGoalStep.notesLabel, info.notes),
        //       ],
        //     );
        //   },
        // ),
        );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile(this.label, this.value, {super.key});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value!)),
        ],
      ),
    );
  }
}

class _ImageGrid extends StatelessWidget {
  const _ImageGrid(this.images, {super.key});

  final List<File?> images;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: Row(
          spacing: 5,
          children: images
              .map(
                (e) => Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade100,
                  ),
                  child: e != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(e, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.image_not_supported, size: 40),
                ),
              )
              .toList()),
    );
    SizedBox(
      height: 100,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 20.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: images.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            final file = images[index];
            return Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
              ),
              child: file != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(file, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.image_not_supported, size: 40),
            );
          },
        ),
      ),
    );
  }
}

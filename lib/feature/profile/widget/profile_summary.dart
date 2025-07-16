import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    final local = context.t.userProfileSummary;
    final images = useState<List<File?>>([]);
    final personalInfo = useState<UserPersonalInfo?>(null);
    useFuture(ref.read(PromptCreatorDeps.getPersonalInformation));
    useEffect(() {
      Future.microtask(() async {
        try {
          final ima = await ref.watch(PromptCreatorDeps.getSavedImages);
          personalInfo.value =
              await ref.read(PromptCreatorDeps.getPersonalInformation);
          List<File?> temp = [];
          if (ima.isNotEmpty) {
            final files = await uint8ListToFile(ima);
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
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
              onTap: () => context.maybePop(),
              child: Icon(EneftyIcons.arrow_left_3_outline)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 20.0, bottom: 10, end: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              local.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  context.pushRoute(
                                      PromptCreatorStepperRoute(isEdit: true));
                                },
                                child: Container(
                                  padding: EdgeInsetsDirectional.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: Color(0xff6E9CA7),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    local.editButton,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      _ImageGrid(images.value),
                      Divider(
                        color: Color(0xff282828).withAlpha(30),
                      ),
                      _InfoTile(
                        label: local.job,
                        value: personalInfo.value?.workoutSchedule ?? '',
                      ),
                      Divider(
                        color: Color(0xff282828).withAlpha(30),
                      ),
                      _InfoTile(
                        label: local.birthDate,
                        value: personalInfo.value?.birthDate,
                      ),
                      Divider(
                        color: Color(0xff282828).withAlpha(30),
                      ),
                      _InfoTile(
                        label: local.gender,
                        value: personalInfo.value?.gender,
                      ),
                      Divider(
                        color: Color(0xff282828).withAlpha(30),
                      ),
                      _InfoTile(
                        label: local.activity,
                        value: personalInfo.value?.activity,
                      ),
                      Divider(
                        color: Color(0xff282828).withAlpha(30),
                      ),
                      _InfoTile(
                        label: local.hobbies,
                        value: personalInfo.value?.hobbies,
                      ),
                      Divider(
                        color: Color(0xff282828).withAlpha(30),
                      ),
                      _InfoTile(
                        label: local.notes,
                        value: personalInfo.value?.notes,
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsetsDirectional.symmetric(vertical: 6.0, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Color(0xff282828), fontSize: 14),
          ),
          Text(
            value ?? '',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ImageGrid extends StatelessWidget {
  const _ImageGrid(this.images);

  final List<File?> images;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0, bottom: 20),
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
  }
}

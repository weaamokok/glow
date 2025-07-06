import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glow/domain/glow.dart';
import 'package:glow/feature/calendar/calendar_deps.dart';
import 'package:glow/feature/prompt_creator/image_picker_step.dart';
import 'package:glow/feature/prompt_creator/personal_goals_step.dart';
import 'package:glow/feature/prompt_creator/personal_info_step.dart';
import 'package:glow/feature/prompt_creator/prompt_creator_deps.dart';
import 'package:glow/l10n/translations.g.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

//todo add form validation
@RoutePage()
class PromptCreatorStepperScreen extends HookConsumerWidget {
  const PromptCreatorStepperScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final local = context.t;
    final stepIndex = useState(0);
    final promptCreator = ref.watch(PromptCreatorDeps.promptProvider.notifier);
    final images = ref.watch(PromptCreatorDeps.promptImagesProvider);
    final personalInfo =
        ref.watch(PromptCreatorDeps.promptPersonalInfoProvider);
    List<Widget> steps = [
      ImagePickerStep(), //image picker
      PersonalInfoStep(), //personal info
      PersonalGoalsStep(), //goals and life style
      //goals and life style
    ];
    final promptCreationState = useState(AsyncValue<GlowSchedule?>.data(null));
    final result = promptCreationState.value;
    result.map(
      data: (data) {},
      error: (error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content:
                  Text('${local.core.somethingWentWrong} ${error.error} ')));
        });
      },
      loading: (loading) {
        return;
      },
    );
//when we receive data we pop our route
    if (result.value != null) {}

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
              color: Colors.white,
              padding: EdgeInsetsDirectional.only(end: 10, top: 16),
              width: double.infinity,
              child: Column(
                children: [
                  CloseButton(),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                    width: double.infinity,
                    child: LinearProgressIndicator(
                      value: (stepIndex.value + 1) / steps.length,
                      trackGap: 12,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(15),
                      valueColor: AlwaysStoppedAnimation(Color(0xffEFB036)),
                      backgroundColor: Color(0xff4C7B8B),
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  steps[stepIndex.value.toInt()],
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: 44,
                          margin: EdgeInsets.symmetric(
                              horizontal: 18, vertical: 18),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              switch (stepIndex.value) {
                                case 0:
                                  final canProceed = images.any(
                                    (element) => element != null,
                                  );
                                  if (canProceed) {
                                    ref.read(PromptCreatorDeps
                                        .addPromptImagesProvider(images));
                                    stepIndex.value = 1;
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            content: Text(
                                                local.imageUploadValidation)));
                                  }

                                case 1:
                                  stepIndex.value = 2;
                                case 2:
                                  promptCreationState.value =
                                      AsyncValue.loading();
                                  ref.read(PromptCreatorDeps
                                      .addPromptPersonalInfoProvider(
                                          personalInfo));
                                  final state =
                                      await promptCreator.submitPrompt();
                                  state.when(
                                      loading: () =>
                                          promptCreationState.value = state,
                                      error: (error, stack) => WidgetsBinding
                                              .instance
                                              .addPostFrameCallback((_) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    content: Text(
                                                        '${local.core.somethingWentWrong} ${error} ')));
                                          }),
                                      data: (data) {
                                        if (data != null) {
                                          ref.invalidate(
                                              CalendarDeps.scheduleProvider);
                                          context.router.popUntilRoot();
                                        }
                                      });
                              }
                            },
                            style: ButtonStyle(
                              elevation: WidgetStatePropertyAll(0),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              backgroundColor: WidgetStatePropertyAll(
                                Color(0xffEFB036),
                              ),
                            ),
                            child: Text(
                              stepIndex.value == 2
                                  ? local.core.confirm
                                  : local.core.kContinue,
                              style: TextStyle(
                                  color: Color(0xff282828), fontSize: 15),
                            ),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
          if (promptCreationState.value == AsyncValue<GlowSchedule?>.loading())
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey.withValues(alpha: .7),
              child: Center(
                child: IntrinsicHeight(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      spacing: 10,
                      children: [
                        LoadingAnimationWidget.halfTriangleDot(
                            color: Color(0xffEFB036), size: 100),
                        Text(
                          local.scheduleCreationLoading,
                          style: TextStyle(
                            color: Color(0xff23486A),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CloseButton extends StatelessWidget {
  const CloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: AlignmentDirectional.topStart,
        child: IconButton(
            onPressed: () {
              context.maybePop();
            },
            icon: Icon(Icons.close)));
  }
}

class ImagePickerContainer extends StatelessWidget {
  const ImagePickerContainer(
      {super.key,
      required this.width,
      this.height,
      this.image,
      this.text,
      required this.icon,
      this.onTap,
      this.margin});

  final double width;
  final double? height;
  final File? image;
  final String? text;
  final EdgeInsets? margin;
  final Widget icon;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: DottedBorder(
          padding: EdgeInsets.zero,
          borderType: BorderType.RRect,
          radius: Radius.circular(15),
          color: Color(0xff3B6790),
          strokeWidth: 1,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: Color(0xff3B6790).withValues(alpha: .2),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15)),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      image!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon,
                      Text(
                        text ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff282828).withValues(alpha: .8)),
                      ),
                    ],
                  )),
          ),
        ),
      ),
    );
  }
}

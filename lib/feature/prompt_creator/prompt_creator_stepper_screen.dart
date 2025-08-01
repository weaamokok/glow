import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glow/domain/glow.dart';
import 'package:glow/feature/calendar/calendar_deps.dart';
import 'package:glow/feature/prompt_creator/image_picker_step.dart';
import 'package:glow/feature/prompt_creator/personal_goals_step.dart';
import 'package:glow/feature/prompt_creator/personal_info_step.dart';
import 'package:glow/feature/prompt_creator/prompt_creator_deps.dart';
import 'package:glow/l10n/translations.g.dart';
import 'package:glow/ui/bottom_sheet_handle.dart';
import 'package:glow/ui/close_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

@RoutePage()
class PromptCreatorStepperScreen extends HookConsumerWidget {
  const PromptCreatorStepperScreen({required this.isEdit, super.key});

  final bool isEdit;

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PromptCreatorStepperBody(isEdit: isEdit),
    );
  }
}

class PromptCreatorStepperBody extends HookConsumerWidget {
  const PromptCreatorStepperBody({required this.isEdit, super.key});

  final bool isEdit;

  @override
  Widget build(BuildContext context, ref) {
    final local = context.t;
    final stepIndex = useState(0);

    final promptCreator = ref.watch(PromptCreatorDeps.promptProvider.notifier);
    final images = ref.watch(PromptCreatorDeps.promptImagesProvider);
    final personalInfo = ref.watch(
      PromptCreatorDeps.promptPersonalInfoProvider,
    );
    final List<Widget> steps = [
      ImagePickerStep(isEdit: isEdit), //image picker
      PersonalInfoStep(isEdit: isEdit), //personal info
      PersonalGoalsStep(isEdit: isEdit), //goals and life style
      //goals and life style
    ];
    final promptCreationState = useState(AsyncValue<GlowSchedule?>.data(null));

    return Stack(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsetsDirectional.only(end: 10, top: 30),
          width: double.infinity,
          child: Column(
            children: [
              if (!context.router.canNavigateBack)
                CloseOrBackButton(isClose: !isEdit),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                width: double.infinity,
                child: LinearProgressIndicator(
                  value: (stepIndex.value + 1) / steps.length,
                  trackGap: 12,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(15),
                  valueColor: AlwaysStoppedAnimation(Color(0xffFFC107)),
                  backgroundColor: Color(0xff282828).withAlpha(30),
                ),
              ),
              SizedBox(height: 10),
              steps[stepIndex.value.toInt()],

              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,

                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          spacing: 4,
                          children: [
                            Text(local.photoUseDisclaimer.disclaimerTitlePart1),
                            InkWell(
                              onTap: () => showModalBottomSheet(
                                context: context,

                                builder: (context) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 15,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 8,
                                    children: [
                                      Center(child: BottomSheetHandle()),
                                      SizedBox(height: 20),
                                      Text(
                                        local
                                            .photoUseDisclaimer
                                            .disclaimerTitle,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        local
                                            .photoUseDisclaimer
                                            .disclaimerDescription,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              child: Text(
                                local.photoUseDisclaimer.disclaimerTitle,
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            Text(local.photoUseDisclaimer.disclaimerTitlePart2),
                          ],
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            if (stepIndex.value != 0)
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: 44,
                                  margin: EdgeInsets.symmetric(vertical: 18),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      stepIndex.value = stepIndex.value - 1;
                                    },
                                    style: ButtonStyle(
                                      foregroundColor: WidgetStatePropertyAll(
                                        Color(0xff282828),
                                      ),
                                      backgroundColor: WidgetStatePropertyAll(
                                        Colors.transparent,
                                      ),
                                    ),
                                    child: Text(local.core.back),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Container(
                                height: 44,
                                margin: EdgeInsets.symmetric(vertical: 18),

                                child: ElevatedButton(
                                  onPressed: () async {
                                    switch (stepIndex.value) {
                                      case 0:
                                        final canProceed = images.any(
                                          (element) => element != null,
                                        );
                                        if (canProceed) {
                                          ref.read(
                                            PromptCreatorDeps.addPromptImagesProvider(
                                              images,
                                            ),
                                          );
                                          stepIndex.value = 1;
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              content: Text(
                                                local.imageUploadValidation,
                                              ),
                                            ),
                                          );
                                        }

                                      case 1:
                                        stepIndex.value = 2;
                                      case 2:
                                        promptCreationState.value =
                                            AsyncValue.loading();
                                        ref.read(
                                          PromptCreatorDeps.addPromptPersonalInfoProvider(
                                            personalInfo,
                                          ),
                                        );
                                        final state = await promptCreator
                                            .submitPrompt();
                                        state.when(
                                          loading: () =>
                                              promptCreationState.value = state,
                                          error: (error, stack) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                                  promptCreationState.value =
                                                      state;

                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                      content: Text(' $error '),
                                                    ),
                                                  );
                                                });
                                          },
                                          data: (data) {
                                            if (data != null) {
                                              ref.invalidate(
                                                CalendarDeps.scheduleProvider,
                                              );
                                              context.router.popUntilRoot();
                                            }
                                          },
                                        );
                                    }
                                  },

                                  child: Text(
                                    stepIndex.value == 2
                                        ? local.core.confirm
                                        : local.core.kContinue,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
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
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    spacing: 10,
                    children: [
                      LoadingAnimationWidget.halfTriangleDot(
                        color: Color(0xffEFB036),
                        size: 100,
                      ),
                      Text(
                        local.scheduleCreationLoading,
                        style: TextStyle(
                          color: Color(0xff23486A),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        SizedBox(height: 500),
      ],
    );
  }
}

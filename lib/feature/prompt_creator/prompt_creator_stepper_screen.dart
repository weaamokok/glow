import 'package:auto_route/auto_route.dart';
import 'package:enefty_icons/enefty_icons.dart';
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

@RoutePage()
class PromptCreatorStepperScreen extends HookConsumerWidget {
  const PromptCreatorStepperScreen({required this.isEdit, super.key});

  final bool isEdit;

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () => context.maybePop(),
            child: Icon(EneftyIcons.arrow_left_3_outline)),
      ),
      resizeToAvoidBottomInset: false,
      body: PromptCreatorStepperBody(
        isEdit: isEdit,
      ),
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
    final futureImages = useFuture(ref.read(PromptCreatorDeps.getSavedImages));

    final promptCreator = ref.watch(PromptCreatorDeps.promptProvider.notifier);
    final images = ref.watch(PromptCreatorDeps.promptImagesProvider);
    final personalInfo =
        ref.watch(PromptCreatorDeps.promptPersonalInfoProvider);
    final List<Widget> steps = [
      ImagePickerStep(
        isEdit: isEdit,
      ), //image picker
      PersonalInfoStep(), //personal info
      PersonalGoalsStep(), //goals and life style
      //goals and life style
    ];
    final promptCreationState = useState(AsyncValue<GlowSchedule?>.data(null));
    final result = promptCreationState.value;
    result.maybeMap(
      orElse: () {},
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
    );
//when we receive data we pop our route
    if (result.value != null) {}
    print('images ${futureImages.data}');
    return Stack(
      children: [
        Container(
            color: Colors.white,
            padding: EdgeInsetsDirectional.only(end: 10, top: 16),
            width: double.infinity,
            child: Column(
              children: [
                if (!context.router.canNavigateBack) BackButton(),
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                        width: double.infinity,
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
                                          images));
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
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  content: Text(
                                                      '${local.core.somethingWentWrong} $error ')));
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
    );
  }
}
